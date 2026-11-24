<?php

declare(strict_types=1);

use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Community\Models\CommunityPost;
use App\Domains\Community\Models\Crew;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Community\Models\Promotion;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Vetting\Models\SellerApplication;
use App\Domains\Workshops\Models\Workshop;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Role;

it('registers with Sri Lankan local mobile, logs out, and revokes token', function (): void {
    Tenant::factory()->create(['slug' => 'colombo-hq']);

    $register = $this->postJson('/api/v1/auth/register', [
        'name' => 'Kasun Silva',
        'identifier' => '077 123 4567',
        'password' => 'StrongPass123!',
        'cultures' => ['JDM Cars', 'Track & Drift'],
        'device_name' => 'pixel-9',
    ]);

    $register->assertCreated()
        ->assertJsonPath('user.name', 'Kasun Silva')
        ->assertJsonPath('user.mobile_number', '+94771234567')
        ->assertJsonPath('user.onboarding_completed', false);

    $token = (string) $register->json('token');

    $this->withHeader('Authorization', 'Bearer '.$token)
        ->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJsonPath('user.mobile_number', '+94771234567');

    $this->withHeader('Authorization', 'Bearer '.$token)
        ->postJson('/api/v1/auth/logout')
        ->assertOk();

    // Token was deleted from DB; clear guard cache and verify 401
    app('auth')->forgetGuards();

    $this->withHeader('Authorization', 'Bearer '.$token)
        ->getJson('/api/v1/auth/me')
        ->assertUnauthorized();
});

it('enforces auth, VehiclePolicy ownership (IDOR), and ignores forged X-Tenant-ID', function (): void {
    $tenantA = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $tenantB = Tenant::factory()->create(['slug' => 'kandy-hub']);

    $userA = User::factory()->create(['tenant_id' => $tenantA->id]);
    $userB = User::factory()->create(['tenant_id' => $tenantB->id]);
    $userC = User::factory()->create(['tenant_id' => $tenantA->id]);

    $vehicleA = Vehicle::query()->create([
        'tenant_id' => $tenantA->id,
        'user_id' => $userA->id,
        'brand' => 'Honda',
        'title' => 'Honda Civic Type R',
        'chassis' => 'FD2',
        'category' => 'Car',
        'subtitle' => 'K20A Track Spec',
        'watermark' => 'FD2',
        'illustration' => 'fd2',
        'stage_badge' => 'Stage 2',
        'status' => 'Dyno Verified',
        'status_tone' => 'emerald',
        'year' => '2008',
        'engine_code' => 'K20A',
        'engine' => '2.0L DOHC i-VTEC',
        'current_mileage' => 64200,
        'next_service_mileage' => 68000,
        'power_value' => '245',
        'power_unit' => 'WHP',
        'torque_value' => '225 Nm',
        'estimated_value_lkr' => 14500000,
        'specs' => [],
    ]);

    // Unauthenticated access to vehicles is blocked
    $this->getJson('/api/v1/vehicles')->assertUnauthorized();

    // Cross-tenant User B cannot see Tenant A's vehicle even with forged X-Tenant-ID
    Sanctum::actingAs($userB);

    $this->withHeader('X-Tenant-ID', (string) $tenantA->id)
        ->getJson('/api/v1/vehicles')
        ->assertOk()
        ->assertJsonCount(0, 'vehicles');

    $this->getJson("/api/v1/vehicles/{$vehicleA->id}")->assertNotFound();

    // Same-tenant User C is blocked by VehiclePolicy (403)
    Sanctum::actingAs($userC);

    $this->getJson("/api/v1/vehicles/{$vehicleA->id}")->assertForbidden();

    $this->postJson("/api/v1/vehicles/{$vehicleA->id}/build-logs", [
        'title' => 'Unauthorized Mod',
        'category' => 'Engine',
        'cost_lkr' => 10000,
    ])->assertForbidden();

    $this->patchJson('/api/v1/user/active-vehicle', [
        'vehicle_id' => $vehicleA->id,
    ])->assertForbidden();
});

it('supports full garage, build log, service record, and media upload flow', function (): void {
    Storage::fake('public');
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $user = User::factory()->create(['tenant_id' => $tenant->id]);
    Sanctum::actingAs($user);

    $upload = $this->postJson('/api/v1/media/upload', [
        'file' => UploadedFile::fake()->image('receipt.jpg', 400, 400),
        'folder' => 'receipts',
    ]);
    $upload->assertCreated()->assertJsonStructure(['path', 'url']);

    $vehicleRes = $this->postJson('/api/v1/vehicles', [
        'brand' => 'Nissan',
        'title' => 'Nissan Silvia S15',
        'chassis' => 'GF-S15',
        'category' => 'Car',
        'subtitle' => 'SR20DET Street Drift',
        'watermark' => 'S15',
        'illustration' => 's15',
        'stage_badge' => 'Stage 3',
        'status' => 'Dyno Verified',
        'status_tone' => 'emerald',
        'year' => '2001',
        'engine_code' => 'SR20DET',
        'engine' => '2.0L Turbo',
        'current_mileage' => 88000,
        'next_service_mileage' => 91000,
        'power_value' => '418',
        'power_unit' => 'WHP',
        'torque_value' => '465 Nm',
        'estimated_value_lkr' => 21000000,
    ]);
    $vehicleRes->assertCreated();
    $vehicleId = (int) $vehicleRes->json('vehicle.id');

    $this->postJson("/api/v1/vehicles/{$vehicleId}/build-logs", [
        'title' => 'Link G4X ECU Tune',
        'category' => 'Engine',
        'brand' => 'Link ECU',
        'cost_lkr' => 185000,
        'mechanic' => 'Apex Dyno Lab',
        'photo_label' => (string) $upload->json('url'),
    ])->assertCreated()->assertJsonPath('build_log.title', 'Link G4X ECU Tune');

    $this->postJson("/api/v1/vehicles/{$vehicleId}/service-records", [
        'title' => 'Motul 300V Oil Change',
        'odometer_km' => 88400,
        'next_service_km' => 93400,
        'workshop' => 'Apex Dyno Lab',
        'cost_lkr' => 28500,
        'parts_changed' => ['Motul 300V 10W-40', 'HKS Oil Filter'],
    ])->assertCreated()->assertJsonPath('service_record.title', 'Motul 300V Oil Change');

    $this->patchJson('/api/v1/user/onboarding', [
        'cultures' => ['JDM Cars', 'Superbikes'],
        'onboarding_completed' => true,
    ])->assertOk()->assertJsonPath('user.onboarding_completed', true);

    $this->getJson('/api/v1/user/profile')
        ->assertOk()
        ->assertJsonPath('stats.vehicles_count', 1);
});

it('supports marketplace filters, histogram, save, reserve, and chat', function (): void {
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $seller = User::factory()->create(['tenant_id' => $tenant->id]);
    $buyer = User::factory()->create(['tenant_id' => $tenant->id]);

    $part = PartListing::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $seller->id,
        'sku' => 'AG-TEST-01',
        'title' => 'Spoon Monoblock 4-Pot Calipers',
        'brand' => 'Spoon',
        'subtitle' => 'FD2 / DC5 Bolt-on',
        'fitment' => 'Honda Civic FD2',
        'condition' => 'Brand New',
        'price_lkr' => 340000,
        'stock' => 2,
        'seller_name' => 'JDM Direct Lanka',
        'seller_id' => "seller_{$seller->id}",
        'status' => 'Approved',
        'watermark' => 'SPOON',
        'illustration' => 'caliper',
        'location' => 'Colombo 05',
        'rating' => '4.9',
        'is_verified' => true,
        'trust_badges' => ['Verified Seller'],
        'specs' => [],
        'description' => 'Genuine Spoon calipers.',
    ]);

    $this->getJson('/api/v1/marketplace/parts?q=Spoon')
        ->assertOk()
        ->assertJsonCount(1, 'parts')
        ->assertJsonPath('parts.0.title', 'Spoon Monoblock 4-Pot Calipers');

    $this->getJson('/api/v1/marketplace/parts/histogram')
        ->assertOk()
        ->assertJsonPath('max_price', 340000);

    Sanctum::actingAs($buyer);

    $this->putJson("/api/v1/marketplace/parts/{$part->id}/save", ['value' => true])
        ->assertOk()
        ->assertJsonPath('is_saved', true);

    $this->postJson("/api/v1/marketplace/parts/{$part->id}/chat", [
        'text' => 'Is this still available for pickup today?',
    ])->assertCreated()->assertJsonPath('message.from', 'me');

    $this->getJson("/api/v1/marketplace/parts/{$part->id}/chat")
        ->assertOk()
        ->assertJsonCount(1, 'messages');

    $this->postJson("/api/v1/marketplace/parts/{$part->id}/reserve", [
        'message' => 'Reserving for pickup tomorrow.',
    ])->assertCreated()->assertJsonPath('status', 'Reserved (Pickup)');
});

it('supports workshop slot booking, meets rsvp, crew membership, feed likes, and home dashboard', function (): void {
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $owner = User::factory()->create(['tenant_id' => $tenant->id]);
    $user = User::factory()->create(['tenant_id' => $tenant->id]);

    $workshop = Workshop::query()->create([
        'tenant_id' => $tenant->id,
        'owner_user_id' => $owner->id,
        'name' => 'Apex Dyno Lab Colombo',
        'location' => 'Pannipitiya',
        'specialty' => '4WD Dyno & ECU',
        'rating' => '4.9',
        'reviews_count' => 142,
        'base_price' => 'LKR 18,500',
        'tags' => ['Dyno', 'ECU'],
        'availability' => 'Slots Today',
        'is_verified' => true,
    ]);

    $meet = MeetEvent::query()->create([
        'tenant_id' => $tenant->id,
        'host_user_id' => $owner->id,
        'pin_id' => 'pin_test',
        'title' => 'Port City Night Meet',
        'event_date' => 'Sat · 9:00 PM',
        'location' => 'Colombo 01',
        'host' => 'Colombo JDM',
        'going_count' => 10,
        'pin_top_ratio' => '0.50',
        'pin_left_ratio' => '0.35',
        'pin_label' => 'Port City',
        'status' => 'Upcoming',
    ]);

    $crew = Crew::query()->create([
        'tenant_id' => $tenant->id,
        'name' => 'Colombo JDM Syndicate',
        'focus' => 'JDM',
        'description' => 'Night cruises',
        'location' => 'Colombo',
        'members_count' => 50,
    ]);

    $post = CommunityPost::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $owner->id,
        'vehicle_title' => 'FD2 Type R',
        'mod_title' => 'Hondata Tune',
        'workshop' => 'Apex Dyno Lab',
        'illustration' => 'fd2',
        'watermark' => 'K20A',
        'tags' => ['K20A'],
        'likes_count' => 5,
        'comments_count' => 1,
    ]);

    Promotion::query()->create([
        'tenant_id' => $tenant->id,
        'partner' => 'Motul',
        'code' => 'APEX15',
        'title' => '15% Off 300V',
        'description' => 'Member offer',
        'participating_workshops' => ['Apex Dyno Lab Colombo'],
        'is_active' => true,
    ]);

    Sanctum::actingAs($user);

    $slotsRes = $this->getJson("/api/v1/mechanics/{$workshop->id}/slots")->assertOk();
    $firstSlot = (string) $slotsRes->json('slots.0.slot');

    $this->postJson("/api/v1/mechanics/{$workshop->id}/book", [
        'service_key' => 'dyno',
        'slot' => $firstSlot,
    ])->assertCreated()->assertJsonPath('booking.status', 'Pending');

    $this->putJson("/api/v1/meets/{$meet->id}/rsvp", ['value' => true])
        ->assertOk()
        ->assertJsonPath('going_count', 11);

    $this->putJson("/api/v1/crews/{$crew->id}/membership", ['value' => true])
        ->assertOk()
        ->assertJsonPath('members_count', 51);

    $this->putJson("/api/v1/feed/{$post->id}/like", ['value' => true])
        ->assertOk()
        ->assertJsonPath('likes_count', 6);

    $this->postJson('/api/v1/meets', [
        'title' => 'Kandy Sunrise Run',
        'location' => 'Kandy City',
        'event_date' => 'Sun · 6:00 AM',
    ])->assertCreated()->assertJsonPath('meet.title', 'Kandy Sunrise Run');

    $this->postJson('/api/v1/crews', [
        'name' => 'Southern Touge Club',
        'focus' => 'JDM & Touge',
        'location' => 'Galle',
    ])->assertCreated()
        ->assertJsonPath('crew.name', 'Southern Touge Club')
        ->assertJsonPath('crew.members_count', 1)
        ->assertJsonPath('crew.joined_by_me', true);

    $this->getJson('/api/v1/home')
        ->assertOk()
        ->assertJsonStructure(['active_vehicle', 'next_meet', 'recommended_parts', 'active_promotion', 'feed_posts']);
});

it('allows verified workshop-partner shop owners to manage mobile dashboard, inventory, inquiries, bookings, and profile', function (): void {
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $workshopRole = Role::findOrCreate('workshop-partner', 'web');

    $buyer = User::factory()->create(['tenant_id' => $tenant->id]);
    Sanctum::actingAs($buyer);
    $this->getJson('/api/v1/seller/dashboard')->assertForbidden();

    $seller = User::factory()->create([
        'tenant_id' => $tenant->id,
        'name' => 'Ravindu Jayawardena',
        'city' => 'Colombo 05',
    ]);
    $seller->assignRole($workshopRole);

    SellerApplication::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $seller->id,
        'business_name' => 'JDM Direct Lanka',
        'owner_name' => 'Ravindu Jayawardena',
        'type' => 'JDM Parts Importer',
        'br_number' => 'PV-00284910',
        'location' => 'Colombo 05',
        'phone' => '+94 77 812 4490',
        'submitted_time_label' => 'Verified Partner',
        'status' => 'Verified',
        'documents' => ['BR.pdf'],
        'specialty' => 'Honda K-Series & SR20DET',
    ]);

    $part = PartListing::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $seller->id,
        'seller_id' => "seller_{$seller->id}",
        'sku' => 'AG-TEST-001',
        'brand' => 'HKS',
        'title' => 'HKS GTIII-RS Turbo',
        'subtitle' => 'SR20DET Bolt-On',
        'fitment' => 'Nissan Silvia S15',
        'watermark' => 'HKS',
        'illustration' => 'turbo',
        'price_lkr' => 285000,
        'stock' => 2,
        'condition' => 'Brand New',
        'seller_name' => 'JDM Direct Lanka',
        'location' => 'Colombo 05',
        'description' => 'Test turbo listing',
        'status' => 'Approved',
    ]);

    $inquiry = BuyerInquiry::query()->create([
        'tenant_id' => $tenant->id,
        'seller_user_id' => $seller->id,
        'seller_id' => "seller_{$seller->id}",
        'buyer_name' => 'Kasun Silva',
        'part_title' => $part->title,
        'vehicle' => 'Civic FD2',
        'offer_lkr' => 275000,
        'status' => 'New Inquiry',
        'time_label' => '5m ago',
    ]);

    $booking = WorkshopBooking::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $buyer->id,
        'seller_user_id' => $seller->id,
        'customer_name' => 'Kasun Silva',
        'vehicle' => 'Civic FD2',
        'service' => 'Dyno Tune',
        'slot_date' => 'Tomorrow · 10:00 AM',
        'estimate_lkr' => 45000,
        'status' => 'Pending',
    ]);

    Sanctum::actingAs($seller);

    $this->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJsonPath('user.is_seller', true);

    $this->getJson('/api/v1/seller/dashboard')
        ->assertOk()
        ->assertJsonPath('shop.business_name', 'JDM Direct Lanka')
        ->assertJsonPath('stats.listings_count', 1)
        ->assertJsonPath('stats.inquiries_count', 1)
        ->assertJsonPath('stats.bookings_count', 1);

    $this->patchJson("/api/v1/seller/parts/{$part->id}", [
        'price_lkr' => 295000,
        'stock' => 5,
    ])->assertOk()
        ->assertJsonPath('data.price_lkr', 295000)
        ->assertJsonPath('data.stock', 5);

    $this->postJson("/api/v1/seller/inquiries/{$inquiry->id}/reply", [
        'message' => 'Available for pickup today!',
        'status' => 'Replied',
    ])->assertCreated()
        ->assertJsonPath('inquiry_status', 'Replied');

    $this->patchJson("/api/v1/seller/bookings/{$booking->id}", [
        'status' => 'Confirmed',
    ])->assertOk()
        ->assertJsonPath('data.status', 'Confirmed');

    $this->patchJson('/api/v1/seller/profile', [
        'business_name' => 'JDM Direct Lanka HQ',
        'location' => 'Colombo 07',
        'phone' => '+94 77 812 4499',
        'specialty' => 'K20A & SR20DET Performance',
    ])->assertOk()
        ->assertJsonPath('shop.business_name', 'JDM Direct Lanka HQ')
        ->assertJsonPath('shop.location', 'Colombo 07');
});

it('supports feed post comments, dynamic sponsored ads on home, and photo_url on vehicles and parts', function (): void {
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $user = User::factory()->create(['tenant_id' => $tenant->id, 'name' => 'Dineth Senanayake']);

    SponsoredAd::query()->create([
        'tenant_id' => $tenant->id,
        'sponsor' => 'Motul Sri Lanka',
        'headline' => 'Motul 300V 15% Member Discount',
        'placement' => 'Home Feed Native Card',
        'impressions' => '100',
        'clicks' => '10',
        'ctr' => '10%',
        'revenue_lkr' => 50000,
        'is_active' => true,
    ]);

    $post = CommunityPost::query()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $user->id,
        'vehicle_title' => 'Civic FD2',
        'mod_title' => 'Hondata FlashPro Tune',
        'workshop' => 'Apex Dyno Lab',
        'illustration' => 'fd2',
        'watermark' => 'K20A',
        'tags' => ['K20A'],
        'likes_count' => 2,
        'comments_count' => 0,
    ]);

    Sanctum::actingAs($user);

    $this->getJson("/api/v1/feed/{$post->id}/comments")
        ->assertOk()
        ->assertJsonPath('comments_count', 0);

    $this->postJson("/api/v1/feed/{$post->id}/comments", [
        'body' => 'Clean K20A numbers!',
    ])->assertCreated()
        ->assertJsonPath('comment.body', 'Clean K20A numbers!')
        ->assertJsonPath('comments_count', 1);

    $this->getJson('/api/v1/home')
        ->assertOk()
        ->assertJsonPath('sponsored_ads.0.sponsor', 'Motul Sri Lanka')
        ->assertJsonPath('sponsored_ads.0.headline', 'Motul 300V 15% Member Discount');

    $this->postJson('/api/v1/vehicles', [
        'category' => 'Car',
        'brand' => 'Honda',
        'title' => 'Civic Type R FD2',
        'year' => '2008',
        'chassis' => 'ABA-FD2',
        'engine' => 'K20A',
        'current_mileage' => 60000,
        'next_service_mileage' => 65000,
        'power_value' => '240',
        'power_unit' => 'WHP',
        'estimated_value_lkr' => 15000000,
        'photo_url' => 'http://192.168.1.35:8000/storage/vehicles/fd2.jpg',
    ])->assertCreated()
        ->assertJsonPath('vehicle.photo_url', 'http://192.168.1.35:8000/storage/vehicles/fd2.jpg');

    $this->postJson('/api/v1/marketplace/parts', [
        'brand' => 'Spoon',
        'title' => 'Spoon Calipers',
        'subtitle' => 'FD2 Bolt-On',
        'watermark' => 'SPOON',
        'illustration' => 'caliper',
        'price_lkr' => 340000,
        'condition' => 'Brand New',
        'location' => 'Colombo 05',
        'description' => 'Authentic calipers',
        'photo_url' => 'http://192.168.1.35:8000/storage/parts/spoon.jpg',
    ])->assertCreated()
        ->assertJsonPath('part.photo_url', 'http://192.168.1.35:8000/storage/parts/spoon.jpg');
});

it('tracks live crew riding presence and meet map coordinates', function (): void {
    $tenant = Tenant::factory()->create(['slug' => 'colombo-hq']);
    $user1 = User::factory()->create(['tenant_id' => $tenant->id, 'name' => 'Kavindu Perera']);
    $user2 = User::factory()->create(['tenant_id' => $tenant->id, 'name' => 'Dineth Senanayake']);

    $crew = Crew::query()->create([
        'tenant_id' => $tenant->id,
        'name' => 'Colombo JDM Syndicate',
        'focus' => 'JDM & K-Series',
        'description' => 'Night cruises & meets',
        'location' => 'Colombo',
        'members_count' => 2,
    ]);
    $crew->members()->attach([$user1->id, $user2->id]);

    $vehicle2 = Vehicle::factory()->create([
        'tenant_id' => $tenant->id,
        'user_id' => $user2->id,
        'category' => 'Bike',
        'brand' => 'Kawasaki',
        'title' => 'Ninja ZX-4RR',
        'chassis' => 'ZX400SP',
    ]);

    Sanctum::actingAs($user2);
    $this->putJson('/api/v1/crews/live', [
        'is_riding' => true,
        'vehicle_id' => $vehicle2->id,
        'latitude' => 6.9240,
        'longitude' => 79.8442,
        'status_note' => 'Marine Drive cruise',
    ])->assertOk()
        ->assertJsonPath('rider.vehicle_title', 'Ninja ZX-4RR')
        ->assertJsonPath('rider.is_riding', true);

    Sanctum::actingAs($user1);
    $this->getJson('/api/v1/crews/live')
        ->assertOk()
        ->assertJsonPath('riders.0.name', 'Dineth Senanayake')
        ->assertJsonPath('riders.0.vehicle_title', 'Ninja ZX-4RR');

    $this->postJson('/api/v1/meets', [
        'title' => 'Port City Night Meet',
        'location' => 'Port City Promenade, Colombo 01',
        'event_date' => 'Sat, 22 Nov · 9:00 PM',
        'latitude' => 6.9319,
        'longitude' => 79.8428,
    ])->assertCreated()
        ->assertJsonPath('meet.latitude', 6.9319)
        ->assertJsonPath('meet.longitude', 79.8428);
});
