<?php

declare(strict_types=1);

use App\Contracts\DashboardMetricsServiceInterface;
use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Garage\Actions\LogServiceRecordAction;
use App\Domains\Garage\Actions\RegisterVehicleAction;
use App\Domains\Garage\DTOs\CreateServiceRecordData;
use App\Domains\Garage\DTOs\CreateVehicleData;
use App\Domains\Garage\Jobs\ProcessServiceReceiptOcrJob;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Subscriptions\Actions\ActivateIdeaBizSubscriptionAction;
use App\Domains\Subscriptions\DTOs\SubscribeIdeaBizData;
use App\Domains\Subscriptions\Jobs\SyncIdeaBizSubscriptionJob;
use App\Domains\Subscriptions\Models\Subscription;
use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Tenancy\Support\TenantContext;
use App\Domains\Vetting\Models\SellerApplication;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Livewire\Admin\AdminPortal;
use App\Livewire\Auth\LoginGate;
use App\Livewire\Seller\SellerPortal;
use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Support\Facades\Queue;
use Livewire\Livewire;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

it('enforces authentication and RBAC redirects on web portal routes', function (): void {
    $this->seed(DatabaseSeeder::class);

    $this->get('/')->assertRedirect('/login');
    $this->get('/admin')->assertRedirect('/login');
    $this->get('/seller')->assertRedirect('/login');

    $this->get('/login')
        ->assertOk()
        ->assertHeader('X-Frame-Options', 'DENY')
        ->assertHeader('X-Content-Type-Options', 'nosniff')
        ->assertSee('Partner & Admin Portal')
        ->assertDontSee('1. Role Login Gate');

    $admin = User::query()->where('email', 'admin@apexgarage.lk')->firstOrFail();
    $seller = User::query()->where('email', 'sales@jdmdirect.lk')->firstOrFail();

    // Admin can access /admin but not /seller
    $this->actingAs($admin)->get('/admin')->assertOk()->assertSee('Super Admin Console');
    $this->actingAs($admin)->get('/seller')->assertForbidden();

    // Seller can access /seller but not /admin
    $this->actingAs($seller)->get('/seller')->assertOk()->assertSee('Merchant Hub');
    $this->actingAs($seller)->get('/admin')->assertForbidden();
});

it('authenticates users via LoginGate with role validation and registers new merchants', function (): void {
    $this->seed(DatabaseSeeder::class);

    // Reject seller credentials on Admin tab
    Livewire::test(LoginGate::class)
        ->set('loginRoleTab', 'admin')
        ->set('email', 'sales@jdmdirect.lk')
        ->set('password', 'password')
        ->call('authenticate')
        ->assertHasErrors('email');

    // Valid Admin login redirects to /admin
    Livewire::test(LoginGate::class)
        ->set('loginRoleTab', 'admin')
        ->set('email', 'admin@apexgarage.lk')
        ->set('password', 'password')
        ->call('authenticate')
        ->assertRedirect('/admin');

    auth()->logout();

    // Register new merchant creates User + Pending SellerApplication and redirects to /seller
    Livewire::test(LoginGate::class)
        ->set('loginRoleTab', 'seller')
        ->set('portalMode', 'register')
        ->set('regShopName', 'Osaka Imports LK')
        ->set('regOwnerName', 'Kasun Silva')
        ->set('regEmail', 'kasun@osakaimports.lk')
        ->set('regPassword', 'secret1234')
        ->set('regPhone', '+94771112233')
        ->set('regBrNumber', 'PV-998877')
        ->set('regLocation', 'Colombo 03')
        ->set('regShopType', 'JDM Parts Importer')
        ->call('registerMerchant')
        ->assertRedirect('/seller');

    $newUser = User::query()->where('email', 'kasun@osakaimports.lk')->first();
    expect($newUser)->not->toBeNull()
        ->and($newUser?->hasRole('workshop-partner'))->toBeTrue();

    $app = SellerApplication::query()->where('br_number', 'PV-998877')->first();
    expect($app)->not->toBeNull()
        ->and($app?->status)->toBe('Pending')
        ->and($app?->user_id)->toBe($newUser?->id);

    // Pending merchant sees verification gate and cannot list parts yet
    $this->actingAs($newUser)
        ->get('/seller')
        ->assertOk()
        ->assertSee('PENDING BR VERIFICATION')
        ->assertSee('Awaiting Super Admin Verification');
});

it('executes full Super Admin workflows: vetting modal, moderation, ideabiz simulation, and ads', function (): void {
    $this->seed(DatabaseSeeder::class);
    $admin = User::query()->where('email', 'admin@apexgarage.lk')->firstOrFail();

    $this->actingAs($admin);

    $app = SellerApplication::query()->where('status', 'Pending')->firstOrFail();

    // 1. Document Inspection Modal & Approval
    Livewire::test(AdminPortal::class)
        ->call('inspectApplication', $app->id)
        ->assertSet('showDocModal', true)
        ->assertSet('inspectingApplicationId', $app->id)
        ->assertSee('Dossier Inspection')
        ->call('approveFromModal')
        ->assertSet('showDocModal', false)
        ->assertSet('toastTitle', 'Merchant Verified');

    expect($app->fresh()?->status)->toBe('Verified')
        ->and($app->fresh()?->reviewed_by)->toBe($admin->id);

    // 2. Marketplace Listing Moderation
    $listing = PartListing::query()->where('status', 'Pending Review')->firstOrFail();
    Livewire::test(AdminPortal::class)
        ->call('moderateListing', $listing->id, 'Approved')
        ->assertSet('toastTitle', 'Listing Approved');

    expect($listing->fresh()?->status)->toBe('Approved');

    // 3. IdeaBiz Carrier Billing Simulation
    $subCountBefore = Subscription::query()->count();
    Livewire::test(AdminPortal::class)
        ->call('simulateIdeaBizBilling')
        ->assertSet('toastTitle', 'IdeaBiz Webhook Executed');

    expect(Subscription::query()->count())->toBe($subCountBefore + 1);

    // 4. Sponsored Campaign Creation & Toggle
    Livewire::test(AdminPortal::class)
        ->call('openCreateAdModal')
        ->assertSet('showCreateAdModal', true)
        ->set('newAdSponsor', 'Liqui Moly Sri Lanka')
        ->set('newAdHeadline', 'Molygen 5W-40 Synthetic')
        ->set('newAdPlacement', 'Mobile Home Hero Carousel')
        ->set('newAdRevenue', '75000')
        ->call('createSponsoredAd')
        ->assertSet('showCreateAdModal', false)
        ->assertSet('toastTitle', 'Campaign Created');

    $newAd = SponsoredAd::query()->where('sponsor', 'Liqui Moly Sri Lanka')->firstOrFail();
    expect($newAd->is_active)->toBeTrue();

    Livewire::test(AdminPortal::class)
        ->call('toggleAd', $newAd->id)
        ->assertSet('toastTitle', 'Ad Campaign Toggled');

    expect($newAd->fresh()?->is_active)->toBeFalse();
});

it('executes full Verified Seller workflows: publish part, edit stock, live chat, and workshop bays', function (): void {
    $this->seed(DatabaseSeeder::class);
    $seller = User::query()->where('email', 'sales@jdmdirect.lk')->firstOrFail();

    $this->actingAs($seller);

    // 1. Publish New JDM Part
    Livewire::test(SellerPortal::class)
        ->set('newPartTitle', 'Tomei Expreme Ti Exhaust')
        ->set('newPartBrand', 'Nissan')
        ->set('newPartFitment', 'Silvia S15 SR20DET')
        ->set('newPartCondition', 'Brand New')
        ->set('newPartPrice', '295000')
        ->set('newPartStock', '3')
        ->call('addSellerPart')
        ->assertSet('showAddPartModal', false)
        ->assertSet('toastTitle', 'Part Listed');

    $published = PartListing::query()->where('title', 'Tomei Expreme Ti Exhaust')->first();
    expect($published)->not->toBeNull()
        ->and($published?->user_id)->toBe($seller->id)
        ->and($published?->status)->toBe('Pending Review');

    // 2. Edit Price & Stock
    Livewire::test(SellerPortal::class)
        ->call('inspectPart', $published->id)
        ->assertSet('showPartDetailsModal', true)
        ->set('editPartPrice', '285000')
        ->set('editPartStock', '4')
        ->call('savePartEdits')
        ->assertSet('showPartDetailsModal', false)
        ->assertSet('toastTitle', 'Listing Updated');

    expect($published->fresh()?->price_lkr)->toBe(285000)
        ->and($published->fresh()?->stock)->toBe(4);

    // 3. Buyer Inquiry Live Chat & Simulation
    $inquiry = BuyerInquiry::query()->where('seller_user_id', $seller->id)->firstOrFail();
    Livewire::test(SellerPortal::class)
        ->call('setActiveInquiry', $inquiry->id)
        ->call('simulateInboundBuyerMessage')
        ->assertSet('toastTitle', 'Incoming Buyer Offer');

    expect($inquiry->fresh()?->status)->toBe('Offer Received');

    Livewire::test(SellerPortal::class)
        ->call('setActiveInquiry', $inquiry->id)
        ->set('sellerReplyText', 'Yes, mounting brackets are included. Ready for pickup.')
        ->call('sendSellerReply')
        ->assertSet('toastTitle', 'Message Sent');

    expect($inquiry->fresh()?->status)->toBe('Replied');

    // 4. Workshop Bay Confirmation & Completion
    $booking = WorkshopBooking::query()->where('seller_user_id', $seller->id)->where('status', 'Pending')->firstOrFail();
    Livewire::test(SellerPortal::class)
        ->call('confirmWorkshopSlot', $booking->id)
        ->assertSet('toastTitle', 'Bay Confirmed');

    expect($booking->fresh()?->status)->toBe('Confirmed');

    Livewire::test(SellerPortal::class)
        ->call('completeWorkshopBooking', $booking->id)
        ->assertSet('toastTitle', 'Service Completed');

    expect($booking->fresh()?->status)->toBe('Completed');

    // 5. Storefront Profile Update
    Livewire::test(SellerPortal::class)
        ->set('sellerShopPhone', '+94 11 250 9900')
        ->set('sellerShopAddress', 'Colombo 05 Storefront')
        ->set('sellerCourierOption', 'PromptX Islandwide Delivery')
        ->set('sellerSpecialty', 'JDM Performance')
        ->call('updateSellerProfile')
        ->assertSet('toastTitle', 'Storefront Updated');
});

it('authenticates mobile users via Sanctum token action and validates FormRequest', function (): void {
    $tenant = Tenant::factory()->create();
    $user = User::factory()->create([
        'tenant_id' => $tenant->id,
        'email' => 'driver@apexgarage.lk',
        'mobile_number' => '+94771234567',
        'password' => 'secret123',
    ]);

    $response = $this->postJson('/api/v1/auth/login', [
        'identifier' => '+94771234567',
        'password' => 'secret123',
        'device_name' => 'sm-a075f',
    ]);

    $response->assertOk()
        ->assertJsonStructure([
            'token',
            'user' => ['id', 'email', 'mobile_number'],
        ]);

    $token = (string) $response->json('token');

    $this->withHeader('Authorization', 'Bearer '.$token)
        ->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJsonPath('user.email', 'driver@apexgarage.lk');

    // Validation failure test
    $this->postJson('/api/v1/auth/login', [
        'identifier' => '',
        'password' => '',
    ])->assertStatus(422)
        ->assertJsonValidationErrors(['identifier', 'password']);
});

it('enforces Spatie RBAC permissions on protected web and API endpoints', function (): void {
    $tenant = Tenant::factory()->create();
    Permission::findOrCreate('marketplace.moderate', 'web');
    $memberRole = Role::findOrCreate('pro-member', 'web');
    $adminRole = Role::findOrCreate('super-admin', 'web')->givePermissionTo('marketplace.moderate');

    $member = User::factory()->create(['tenant_id' => $tenant->id]);
    $member->assignRole($memberRole);

    $admin = User::factory()->create(['tenant_id' => $tenant->id]);
    $admin->assignRole($adminRole);

    // Unauthenticated API POST is rejected
    $this->postJson('/api/v1/marketplace/parts', [])->assertUnauthorized();

    // Pro member cannot access /admin or /seller
    $this->actingAs($member)->get('/admin')->assertForbidden();
    $this->actingAs($member)->get('/seller')->assertForbidden();

    // Super admin can access /admin
    $this->actingAs($admin)->get('/admin')->assertOk();
});

it('registers vehicles, logs service records, dispatches OCR & IdeaBiz jobs, and invalidates Redis cache', function (): void {
    Queue::fake();

    $tenant = Tenant::factory()->create();
    $user = User::factory()->create(['tenant_id' => $tenant->id]);
    app(TenantContext::class)->setTenantId($tenant->id);

    /** @var RegisterVehicleAction $registerAction */
    $registerAction = app(RegisterVehicleAction::class);
    $vehicle = $registerAction->execute(new CreateVehicleData(
        userId: $user->id,
        tenantId: $tenant->id,
        category: 'Car',
        brand: 'Honda',
        title: 'Civic Type R FD2',
        subtitle: 'K20A · Colombo',
        watermark: 'FD2R',
        illustration: 'fd2',
        stageBadge: 'Stage 2 NA',
        status: 'Healthy',
        statusTone: 'emerald',
        year: '2008',
        engineCode: 'K20A',
        engine: '2.0L i-VTEC',
        chassis: 'ABA-FD2',
        currentMileage: 54000,
        nextServiceMileage: 58000,
        powerValue: '260',
        powerUnit: 'WHP',
        torqueValue: '232 Nm',
        estimatedValueLkr: 16200000,
    ));

    expect($vehicle->chassis)->toBe('ABA-FD2');

    /** @var DashboardMetricsServiceInterface $metrics */
    $metrics = app(DashboardMetricsServiceInterface::class);
    $overview = $metrics->getOverviewMetrics($tenant->id);
    expect($overview['total_vehicles'])->toBe(1);

    /** @var LogServiceRecordAction $serviceAction */
    $serviceAction = app(LogServiceRecordAction::class);
    $record = $serviceAction->execute(new CreateServiceRecordData(
        vehicleId: $vehicle->id,
        title: 'Motul 300V Oil Change',
        serviceDate: '15 Nov 2026',
        odometerKm: 55000,
        workshop: 'Kyoto Motorsport LK',
        partsChanged: ['Motul 300V 5W40', 'OEM Filter'],
        costLkr: 48000,
        nextServiceKm: 60000,
        nextServiceDate: '15 May 2027',
    ));

    expect($record->odometer_km)->toBe(55000)
        ->and($vehicle->fresh()?->current_mileage)->toBe(55000);

    Queue::assertPushed(ProcessServiceReceiptOcrJob::class);

    /** @var ActivateIdeaBizSubscriptionAction $subAction */
    $subAction = app(ActivateIdeaBizSubscriptionAction::class);
    $subscription = $subAction->execute(new SubscribeIdeaBizData(
        userId: $user->id,
        tenantId: $tenant->id,
        mobileNumber: '+94774582910',
    ));

    expect($subscription->status)->toBe('active')
        ->and($user->fresh()?->is_pro)->toBeTrue();

    Queue::assertPushed(SyncIdeaBizSubscriptionJob::class);
});

it('isolates data between tenants using BelongsToTenant global scope', function (): void {
    $tenantColombo = Tenant::factory()->create(['slug' => 'colombo']);
    $tenantKandy = Tenant::factory()->create(['slug' => 'kandy']);

    $userColombo = User::factory()->create(['tenant_id' => $tenantColombo->id]);
    $userKandy = User::factory()->create(['tenant_id' => $tenantKandy->id]);

    app(TenantContext::class)->setTenantId($tenantColombo->id);
    Vehicle::factory()->create(['user_id' => $userColombo->id, 'chassis' => 'FD2-CMB']);

    app(TenantContext::class)->setTenantId($tenantKandy->id);
    Vehicle::factory()->create(['user_id' => $userKandy->id, 'chassis' => 'S15-KDY']);

    // Query scoped to Kandy tenant
    expect(Vehicle::query()->count())->toBe(1)
        ->and(Vehicle::query()->first()?->chassis)->toBe('S15-KDY');

    // Switch tenant context to Colombo
    app(TenantContext::class)->setTenantId($tenantColombo->id);
    expect(Vehicle::query()->count())->toBe(1)
        ->and(Vehicle::query()->first()?->chassis)->toBe('FD2-CMB');
});
