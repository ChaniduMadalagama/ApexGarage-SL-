<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Community\Models\CommunityPost;
use App\Domains\Community\Models\Crew;
use App\Domains\Community\Models\CrewLivePresence;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Community\Models\Promotion;
use App\Domains\Garage\Models\BuildLog;
use App\Domains\Garage\Models\ServiceRecord;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\InquiryMessage;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Subscriptions\Models\Subscription;
use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Tenancy\Support\TenantContext;
use App\Domains\Vetting\Models\SellerApplication;
use App\Domains\Workshops\Models\Workshop;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        app()[PermissionRegistrar::class]->forgetCachedPermissions();

        $tenant = Tenant::query()->firstOrCreate(
            ['slug' => 'colombo-hq'],
            [
                'name' => 'ApexGarage Sri Lanka HQ',
                'domain' => 'hq.apexgarage.lk',
                'is_active' => true,
                'settings' => ['region' => 'LK', 'currency' => 'LKR', 'telco_gateway' => 'Dialog IdeaBiz'],
            ]
        );

        app(TenantContext::class)->setTenantId($tenant->id);

        $permissions = [
            'users.manage',
            'sellers.approve',
            'parts.moderate',
            'ads.manage',
            'billing.view',
            'garage.manage',
            'workshops.verify',
        ];

        foreach ($permissions as $permission) {
            Permission::findOrCreate($permission, 'web');
        }

        $superAdminRole = Role::findOrCreate('super-admin', 'web');
        $superAdminRole->syncPermissions($permissions);

        $workshopRole = Role::findOrCreate('workshop-partner', 'web');
        $workshopRole->syncPermissions(['garage.manage', 'workshops.verify']);

        $proMemberRole = Role::findOrCreate('pro-member', 'web');
        $proMemberRole->syncPermissions(['garage.manage']);

        // ------------------------------------------------------------------
        // 2 Enthusiast User Profiles
        // User 1: 2 Cars (FD2 + S15)
        // User 2: 1 Car + 1 Bike (Evo IX + ZX-4RR)
        // ------------------------------------------------------------------
        $admin = User::query()->withoutGlobalScopes()->updateOrCreate(
            ['email' => 'admin@apexgarage.lk'],
            [
                'tenant_id' => $tenant->id,
                'name' => 'Kavindu Perera',
                'mobile_number' => '+94774582910',
                'handle' => '@kavindu.fd2r',
                'crew' => 'Colombo JDM Syndicate',
                'city' => 'Colombo 07, LK',
                'is_pro' => true,
                'password' => Hash::make('password'),
            ]
        );
        $admin->assignRole([$superAdminRole, $proMemberRole]);

        $userTwo = User::query()->withoutGlobalScopes()->updateOrCreate(
            ['email' => 'dineth@apexgarage.lk'],
            [
                'tenant_id' => $tenant->id,
                'name' => 'Dineth Senanayake',
                'mobile_number' => '+94771234567',
                'handle' => '@dineth.evo9',
                'crew' => 'Colombo JDM Syndicate',
                'city' => 'Kandy / Colombo, LK',
                'is_pro' => true,
                'password' => Hash::make('password'),
            ]
        );
        $userTwo->assignRole([$proMemberRole]);

        // ------------------------------------------------------------------
        // 3 Verified Shop (Seller) Profiles
        // ------------------------------------------------------------------
        $sellerUser = User::query()->withoutGlobalScopes()->updateOrCreate(
            ['email' => 'sales@jdmdirect.lk'],
            [
                'tenant_id' => $tenant->id,
                'name' => 'Ravindu Jayawardena',
                'mobile_number' => '+94778124490',
                'handle' => '@jdmdirect.lk',
                'crew' => 'JDM Importers Guild',
                'city' => 'Colombo 05, LK',
                'is_pro' => true,
                'password' => Hash::make('password'),
            ]
        );
        $sellerUser->assignRole([$workshopRole, $proMemberRole]);

        $motoSellerUser = User::query()->withoutGlobalScopes()->updateOrCreate(
            ['email' => 'moto@hillcountry.lk'],
            [
                'tenant_id' => $tenant->id,
                'name' => 'Nuwan Dissanayake',
                'mobile_number' => '+94769021184',
                'handle' => '@hillcountry.moto',
                'crew' => 'HillCountry MotoHub',
                'city' => 'Kandy, LK',
                'is_pro' => true,
                'password' => Hash::make('password'),
            ]
        );
        $motoSellerUser->assignRole([$workshopRole, $proMemberRole]);

        $boostSellerUser = User::query()->withoutGlobalScopes()->updateOrCreate(
            ['email' => 'parts@boostyard.lk'],
            [
                'tenant_id' => $tenant->id,
                'name' => 'Sahan Perera',
                'mobile_number' => '+94773390012',
                'handle' => '@boostyard.lk',
                'crew' => 'Sri Lanka Drift & Silvia Club',
                'city' => 'Pannipitiya, LK',
                'is_pro' => true,
                'password' => Hash::make('password'),
            ]
        );
        $boostSellerUser->assignRole([$workshopRole, $proMemberRole]);

        // ------------------------------------------------------------------
        // User 1 Vehicles: 2 Cars
        // ------------------------------------------------------------------
        $fd2 = Vehicle::query()->updateOrCreate(
            ['chassis' => 'ABA-FD2', 'user_id' => $admin->id],
            [
                'tenant_id' => $tenant->id,
                'category' => 'Car',
                'brand' => 'Honda',
                'title' => 'Civic Type R FD2',
                'subtitle' => 'K20A Naturally Aspirated · Colombo',
                'watermark' => 'FD2R',
                'illustration' => 'fd2',
                'stage_badge' => 'Stage 2 NA',
                'status' => 'Service Due in 650 km',
                'status_tone' => 'amber',
                'year' => '2008',
                'engine_code' => 'K20A',
                'engine' => '2.0L DOHC i-VTEC',
                'current_mileage' => 64350,
                'next_service_mileage' => 65000,
                'power_value' => '262',
                'power_unit' => 'WHP',
                'torque_value' => '234 Nm',
                'estimated_value_lkr' => 16500000,
                'specs' => [
                    ['label' => 'Hondata FlashPro Tuned'],
                    ['label' => 'Toda Racing A3 Camshafts'],
                    ['label' => 'J\'s Racing 70RR Titanium'],
                ],
            ]
        );

        BuildLog::query()->updateOrCreate(
            ['vehicle_id' => $fd2->id, 'title' => 'Hondata FlashPro Custom Dyno Map'],
            [
                'log_date' => '12 Oct 2026',
                'category' => 'ECU & Electronics',
                'brand' => 'Hondata',
                'cost_lkr' => 245000,
                'mechanic' => 'Apex Dyno Lab Colombo',
                'notes' => 'VTEC engagement lowered to 4,800 RPM with 8,600 RPM rev limit.',
                'photo_label' => 'Dyno Sheet · 262 WHP',
            ]
        );

        ServiceRecord::query()->updateOrCreate(
            ['vehicle_id' => $fd2->id, 'title' => 'Motul 300V 5W40 Competition Oil & LSD Service'],
            [
                'service_date' => '02 Sep 2026',
                'odometer_km' => 60000,
                'workshop' => 'Apex Dyno Lab Colombo',
                'parts_changed' => ['Motul 300V 5W40 (5L)', 'OEM Honda Hamp Oil Filter', 'Cusco LSD Gear Oil'],
                'cost_lkr' => 68500,
                'next_service_km' => 65000,
                'next_service_date' => '20 Nov 2026',
                'notes' => 'Zero metal shavings on magnetic drain plug.',
                'receipt_label' => 'INV-2026-0891.pdf',
            ]
        );

        $s15 = Vehicle::query()->updateOrCreate(
            ['chassis' => 'GF-S15', 'user_id' => $admin->id],
            [
                'tenant_id' => $tenant->id,
                'category' => 'Car',
                'brand' => 'Nissan',
                'title' => 'Silvia S15 Spec-R Aero',
                'subtitle' => 'SR20DET Garrett G25-550 · Street Drift',
                'watermark' => 'S15',
                'illustration' => 's15',
                'stage_badge' => 'Stage 3 Turbo',
                'status' => 'Dyno Verified',
                'status_tone' => 'emerald',
                'year' => '2001',
                'engine_code' => 'SR20DET',
                'engine' => '2.0L Turbocharged Inline-4',
                'current_mileage' => 88400,
                'next_service_mileage' => 91000,
                'power_value' => '418',
                'power_unit' => 'WHP',
                'torque_value' => '465 Nm',
                'estimated_value_lkr' => 21000000,
                'specs' => [
                    ['label' => 'Link G4X Plug-In Standalone'],
                    ['label' => 'Garrett G25-550 .72 A/R'],
                    ['label' => 'Tein Flex Z Coilovers'],
                ],
            ]
        );

        BuildLog::query()->updateOrCreate(
            ['vehicle_id' => $s15->id, 'title' => 'Garrett G25-550 Turbo & Link G4X Flex Map'],
            [
                'log_date' => '28 Sep 2026',
                'category' => 'Forced Induction',
                'brand' => 'Garrett',
                'cost_lkr' => 780000,
                'mechanic' => 'BoostYard Pannipitiya',
                'notes' => '1.5 bar boost target on 95 octane + meth injection.',
                'photo_label' => 'Dyno Pull · 418 WHP',
            ]
        );

        ServiceRecord::query()->updateOrCreate(
            ['vehicle_id' => $s15->id, 'title' => 'HKS 10W50 Synthetic & Gearbox Oil Flush'],
            [
                'service_date' => '15 Aug 2026',
                'odometer_km' => 86000,
                'workshop' => 'BoostYard Pannipitiya',
                'parts_changed' => ['HKS Super Oil 10W50', 'Nismo Oil Filter', 'Redline MT-90'],
                'cost_lkr' => 54000,
                'next_service_km' => 91000,
                'next_service_date' => '15 Dec 2026',
                'notes' => 'Compression tested 155 PSI across all 4 cylinders.',
                'receipt_label' => 'INV-2026-0742.pdf',
            ]
        );

        // ------------------------------------------------------------------
        // User 2 Vehicles: 1 Car + 1 Bike
        // ------------------------------------------------------------------
        $evo = Vehicle::query()->updateOrCreate(
            ['chassis' => 'GH-CT9A', 'user_id' => $userTwo->id],
            [
                'tenant_id' => $tenant->id,
                'category' => 'Car',
                'brand' => 'Mitsubishi',
                'title' => 'Lancer Evolution IX MR',
                'subtitle' => '4G63T MIVEC AWD · Touge Spec',
                'watermark' => 'EVO9',
                'illustration' => 's15',
                'stage_badge' => 'Stage 2 Tuned',
                'status' => 'Track Ready',
                'status_tone' => 'emerald',
                'year' => '2006',
                'engine_code' => '4G63T',
                'engine' => '2.0L MIVEC Turbo AWD',
                'current_mileage' => 72100,
                'next_service_mileage' => 75000,
                'power_value' => '385',
                'power_unit' => 'WHP',
                'torque_value' => '480 Nm',
                'estimated_value_lkr' => 23500000,
                'specs' => [
                    ['label' => 'HKS GTII 7460R Turbo'],
                    ['label' => 'Brembo 4-Pot Factory Kit'],
                    ['label' => 'Ohlins Road & Track DFV'],
                ],
            ]
        );

        BuildLog::query()->updateOrCreate(
            ['vehicle_id' => $evo->id, 'title' => 'Ohlins DFV Coilover & Corner Balance'],
            [
                'log_date' => '05 Oct 2026',
                'category' => 'Suspension & Chassis',
                'brand' => 'Ohlins',
                'cost_lkr' => 620000,
                'mechanic' => 'Nugegoda Alignment & Track Setup',
                'notes' => 'Dialed -2.4 deg front camber for Hanthana & Katukurunda.',
                'photo_label' => 'Alignment Sheet',
            ]
        );

        ServiceRecord::query()->updateOrCreate(
            ['vehicle_id' => $evo->id, 'title' => 'AYC Pump Bleed & Motul 300V Oil Change'],
            [
                'service_date' => '19 Sep 2026',
                'odometer_km' => 70000,
                'workshop' => 'Apex Dyno Lab Colombo',
                'parts_changed' => ['Motul 300V 10W40', 'DiaQueen ATF SP-III', 'OEM Timing Belt'],
                'cost_lkr' => 92000,
                'next_service_km' => 75000,
                'next_service_date' => '10 Jan 2027',
                'notes' => 'AYC pressure verified healthy at 11 bar.',
                'receipt_label' => 'INV-2026-0912.pdf',
            ]
        );

        $zx4rr = Vehicle::query()->updateOrCreate(
            ['chassis' => 'ZX400SP', 'user_id' => $userTwo->id],
            [
                'tenant_id' => $tenant->id,
                'category' => 'Bike',
                'brand' => 'Kawasaki',
                'title' => 'Ninja ZX-4RR KRT Edition',
                'subtitle' => '399cc Inline-4 Screamer · 16,000 RPM',
                'watermark' => 'ZX4RR',
                'illustration' => 'zx4rr',
                'stage_badge' => 'Full System + Woolich',
                'status' => 'Track Ready',
                'status_tone' => 'emerald',
                'year' => '2024',
                'engine_code' => 'ZX400PE',
                'engine' => '399cc Liquid-Cooled Inline-4',
                'current_mileage' => 4120,
                'next_service_mileage' => 6000,
                'power_value' => '79',
                'power_unit' => 'WHP',
                'torque_value' => '42 Nm',
                'estimated_value_lkr' => 4850000,
                'specs' => [
                    ['label' => 'Akrapovic Carbon Racing Line'],
                    ['label' => 'Ohlins NIX30 Front Cartridges'],
                    ['label' => 'Woolich Quickshifter'],
                ],
            ]
        );

        BuildLog::query()->updateOrCreate(
            ['vehicle_id' => $zx4rr->id, 'title' => 'Akrapovic Titanium Slip-On + Woolich Flash'],
            [
                'log_date' => '22 Oct 2026',
                'category' => 'Exhaust & ECU',
                'brand' => 'Akrapovic',
                'cost_lkr' => 310000,
                'mechanic' => 'Kandy Superbike Works',
                'notes' => 'Removed factory 11,500 RPM restriction; pulls cleanly to 16,000 RPM.',
                'photo_label' => 'Woolich Dyno · 79 WHP',
            ]
        );

        ServiceRecord::query()->updateOrCreate(
            ['vehicle_id' => $zx4rr->id, 'title' => 'Motul 7100 10W40 & Chain Tension Service'],
            [
                'service_date' => '01 Oct 2026',
                'odometer_km' => 4000,
                'workshop' => 'Kandy Superbike Works',
                'parts_changed' => ['Motul 7100 10W40 (3L)', 'K&N KN-303 Oil Filter'],
                'cost_lkr' => 26500,
                'next_service_km' => 6000,
                'next_service_date' => '15 Dec 2026',
                'notes' => 'Brake pads 85% remaining.',
                'receipt_label' => 'INV-2026-0994.pdf',
            ]
        );

        // ------------------------------------------------------------------
        // Marketplace Part Listings: 3 Shops x 12 Products = 36 Approved Products
        // ------------------------------------------------------------------
        $shopCatalogs = [
            // Shop 1: JDM Direct Lanka (12 products)
            [
                'user' => $sellerUser,
                'seller_id' => 'seller_jdm',
                'seller_name' => 'JDM Direct Lanka',
                'location' => 'Colombo 05',
                'rating' => '4.95',
                'products' => [
                    ['AG-JDM-001', 'HKS', 'HKS GTIII-RS Sports Turbocharger', 'Internal Wastegate Actuator Kit Included', 'Nissan Silvia S15 / SR20DET', 'JDM Recond', 285000, 2, 'HKS', 'turbo', 'Original HKS JDM reconditioned turbocharger with zero shaft play.'],
                    ['AG-JDM-002', 'Spoon', 'Spoon Monoblock 4-Pot Calipers', 'Direct Bolt-on FD2 / DC5 with 300mm Rotors', 'Honda Civic FD2 / Integra DC5', 'Brand New', 340000, 1, 'SPOON', 'caliper', 'Authentic Spoon Sports rigid monoblock 4-piston calipers in signature Spoon blue.'],
                    ['AG-JDM-003', 'Tein', 'Tein Flex Z 16-Way Coilovers', 'Full Length Ride Height & Pillowball Mounts', 'Civic FD2 / Silvia S15', 'JDM Recond', 210000, 3, 'TEIN', 'coilover', 'Reconditioned Tein coilovers tested for zero leaks with fresh damping oil.'],
                    ['AG-JDM-004', 'J\'s Racing', 'J\'s Racing 70RR Titanium Catback', 'Full Titanium Single-Exit Track Exhaust', 'Honda Civic Type R FD2', 'JDM Recond', 265000, 1, 'JSR', 'exhaust', 'Ultra-lightweight 70mm titanium exhaust system imported from Osaka.'],
                    ['AG-JDM-005', 'Hondata', 'Hondata FlashPro ECU Programmer', 'Unlocked Unit Ready for K20A / K24', 'Honda Civic FD2 / FN2 / S2000', 'Brand New', 195000, 4, 'HOND', 'turbo', 'Brand new sealed Hondata FlashPro with USB tuning cable and live datalogging.'],
                    ['AG-JDM-006', 'Tomei', 'Tomei Expreme Ti Titanium Exhaust', 'Lightweight Single Exit 80mm Piping', 'Nissan Silvia S15 / Evo IX', 'Brand New', 245000, 2, 'TOMEI', 'exhaust', 'Genuine Tomei Expreme Ti titanium exhaust with silencer and springs.'],
                    ['AG-JDM-007', 'Brembo', 'Brembo GT 6-Pot Front Brake Kit', '355mm 2-Piece Slotted Floating Rotors', 'Evo IX / Impreza STI / S15', 'JDM Recond', 420000, 1, 'BREM', 'caliper', 'Refurbished Brembo GT 6-pot calipers with fresh seals and Ferodo DS2500 pads.'],
                    ['AG-JDM-008', 'Cusco', 'Cusco Street Zero A Coilovers', '40-Way Adjustable Damper + Camber Plates', 'Mitsubishi Evo VII-IX CT9A', 'JDM Recond', 235000, 2, 'CUSCO', 'coilover', 'Clean JDM import Cusco Street Zero A suspension kit with spanner wrenches.'],
                    ['AG-JDM-009', 'HKS', 'HKS Super SQV4 Blow-Off Valve Kit', 'Vehicle Specific Flange + Recirc Fitting', 'SR20DET / 4G63T / EJ20', 'Brand New', 68000, 6, 'HKS', 'turbo', 'Authentic HKS SQV4 sequential blow-off valve with triple-fin sound.'],
                    ['AG-JDM-010', 'Toda', 'Toda Racing Spec A3 Camshafts', 'Aggressive NA Profile for K20A VTEC', 'Honda K20A Type R', 'Brand New', 290000, 1, 'TODA', 'turbo', 'Genuine Toda Racing billet camshafts for high-RPM naturally aspirated builds.'],
                    ['AG-JDM-011', 'Project Mu', 'Project Mu HC+800 Track Pads', 'High-Temp Fade Resistant Front Pad Set', 'Brembo / Spoon 4-Pot Calipers', 'Brand New', 58000, 5, 'PMU', 'caliper', '0-800C operating range street and track compound pads.'],
                    ['AG-JDM-012', 'Fujitsubo', 'Fujitsubo Legalis R Catback', 'JASMA Certified Deep Street Exhaust', 'Honda Civic FD2 / Accord CL7', 'JDM Recond', 145000, 2, 'FUJI', 'exhaust', 'Stainless steel Fujitsubo Legalis R exhaust in mint JDM condition.'],
                ],
            ],
            // Shop 2: HillCountry MotoHub (12 products)
            [
                'user' => $motoSellerUser,
                'seller_id' => 'seller_moto',
                'seller_name' => 'HillCountry MotoHub',
                'location' => 'Kandy',
                'rating' => '4.92',
                'products' => [
                    ['AG-MOTO-001', 'Akrapovic', 'Akrapovic Carbon Slip-On Exhaust', 'Titanium Link Pipe & Carbon Fiber Muffler', 'Kawasaki Ninja ZX-4RR (ZX400P)', 'Brand New', 195000, 3, 'AKRA', 'exhaust', 'Genuine Akrapovic slip-on exhaust system for 2024+ Ninja ZX-4RR.'],
                    ['AG-MOTO-002', 'Ohlins', 'Ohlins NIX30 Front Fork Cartridges', '30mm Race Piston + External Preload', 'Kawasaki ZX-4RR / ZX-6R', 'Brand New', 365000, 2, 'OHLN', 'coilover', 'Complete Ohlins NIX30 cartridge kit with 9.5 N/mm linear springs.'],
                    ['AG-MOTO-003', 'Brembo', 'Brembo Stylema M4.30 Monoblock Pair', '100mm Radial Mount Track Calipers', 'Ducati / Kawasaki / Yamaha R1', 'Brand New', 280000, 2, 'BREM', 'caliper', 'Lightweight Brembo Stylema radial calipers with titanium pistons.'],
                    ['AG-MOTO-004', 'SC Project', 'SC-Project CR-T Titanium Exhaust', 'MotoGP Style Mesh Tip Muffler', 'Yamaha R6 / Kawasaki ZX-10R', 'Brand New', 175000, 3, 'SCP', 'exhaust', 'Authentic Italian SC-Project CR-T titanium slip-on with carbon clamp.'],
                    ['AG-MOTO-005', 'Brembo', 'Brembo RCS19 Corsa Corta Master', 'Adjustable Bite Point & Ratio 18/20mm', 'Universal Sportbike Radial', 'Brand New', 98000, 5, 'RCS', 'caliper', 'Original Brembo 19RCS Corsa Corta radial brake master cylinder.'],
                    ['AG-MOTO-006', 'Ohlins', 'Ohlins TTX GP Rear Shock Absorber', 'Twin-Tube Piggyback Track Shock', 'Kawasaki ZX-10R / Ninja ZX-4RR', 'Brand New', 345000, 1, 'OHLN', 'coilover', 'Ohlins TTX GP rear shock with hydraulic preload adjuster.'],
                    ['AG-MOTO-007', 'Austin Racing', 'Austin Racing GP1R Titanium Can', 'Inconel & Titanium Ultra-Short Slip-On', 'BMW S1000RR / CBR1000RR-R', 'Used - Mint', 165000, 1, 'AR', 'exhaust', 'Clean Austin Racing GP1R exhaust with removable db killer.'],
                    ['AG-MOTO-008', 'Woolich', 'Woolich Racing LogBox & Quickshifter', 'ECU Flash Harness + Auto Blipper Sensor', 'Kawasaki ZX-4RR / Suzuki GSX-R', 'Brand New', 148000, 3, 'WOOL', 'turbo', 'Complete Woolich Racing tuning interface with strain-gauge quickshifter.'],
                    ['AG-MOTO-009', 'Galfer', 'Galfer Wave 320mm Floating Rotors', 'Stainless Track Rotors (Front Pair)', 'Kawasaki / Honda / Yamaha 600-1000cc', 'Brand New', 135000, 2, 'GALF', 'caliper', 'High-carbon stainless steel floating wave brake rotors for track days.'],
                    ['AG-MOTO-010', 'Arrow', 'Arrow Pro-Race Titanium Full System', '4-2-1 Titanium Header + Nichrom Can', 'Yamaha YZF-R7 / MT-07', 'Brand New', 255000, 2, 'ARRW', 'exhaust', 'Full racing titanium exhaust system reducing weight by 4.2 kg.'],
                    ['AG-MOTO-011', 'Bitubo', 'Bitubo XXF31 Rear Racing Monoshock', 'High/Low Speed Compression + Rebound', 'Honda CBR600RR / Yamaha R6', 'Brand New', 260000, 1, 'BITU', 'coilover', 'Italian Bitubo XXF31 competition monoshock in red anodize.'],
                    ['AG-MOTO-012', 'Sprint Filter', 'Sprint P08 F1-85 Air Filter', 'Waterproof Polyester High-Flow Element', 'Kawasaki ZX-4RR / ZX-10R', 'Brand New', 38000, 8, 'SPRT', 'turbo', 'Dry-type racing air filter requiring zero oiling and lifetime cleanable.'],
                ],
            ],
            // Shop 3: BoostYard Pannipitiya (12 products)
            [
                'user' => $boostSellerUser,
                'seller_id' => 'seller_boostyard',
                'seller_name' => 'BoostYard Pannipitiya',
                'location' => 'Pannipitiya',
                'rating' => '4.88',
                'products' => [
                    ['AG-BYD-001', 'Garrett', 'Garrett G25-550 Dual Ball Bearing', '0.72 A/R V-Band Reverse Rotation', 'SR20DET / 4G63T / K20 Turbo', 'Brand New', 465000, 2, 'GARR', 'turbo', 'Genuine Garrett Motion G-Series turbo capable of 550 HP with fast spool.'],
                    ['AG-BYD-002', 'Link ECU', 'Link G4X Plug-In Standalone ECU', 'Built-In MAP Sensor & Wideband Support', 'Nissan Silvia S15 / Evo IX', 'Brand New', 385000, 2, 'LINK', 'turbo', 'Brand new Link G4X plug-in ECU with anti-lag, launch control & flex fuel.'],
                    ['AG-BYD-003', 'TiAL', 'TiAL MV-R 44mm External Wastegate', 'V-Band Water-Cooled Wastegate (Red)', 'Universal Custom Turbo Manifold', 'Brand New', 92000, 4, 'TIAL', 'turbo', 'Authentic TiAL Sport MV-R 44mm wastegate with full spring pack.'],
                    ['AG-BYD-004', 'BC Racing', 'BC Racing BR-RA Drift Coilovers', '30-Click Damping + Front Camber Tops', 'Nissan Silvia S13 / S14 / S15', 'Brand New', 225000, 3, 'BC', 'coilover', '8K/6K drift-spec spring rates ready for street & Katukurunda track use.'],
                    ['AG-BYD-005', 'AP Racing', 'AP Racing Pro 5000R 6-Pot Calipers', 'Forged Radi-CAL Track Caliper Set', 'Custom Bracket / Evo / Skyline', 'Brand New', 540000, 1, 'AP', 'caliper', 'Motorsport-grade AP Racing Radi-CAL II forged calipers for serious time attack.'],
                    ['AG-BYD-006', 'HKS', 'HKS R-Type Front Mount Intercooler', '600x300x103mm Bar & Plate Core', 'Nissan Silvia S15 / Skyline GT-R', 'JDM Recond', 175000, 2, 'HKS', 'turbo', 'Authentic HKS Type-R intercooler kit with mandrel-bent aluminum piping.'],
                    ['AG-BYD-007', 'Invidia', 'Invidia N1 Titanium Tip Catback', '76mm Stainless Piping + Burnt Tip', 'Mitsubishi Evo VII-IX / WRX STI', 'Brand New', 158000, 3, 'INV', 'exhaust', 'Deep, aggressive turbo-back sound with 3-inch high-flow mandrel bends.'],
                    ['AG-BYD-008', 'MCA', 'MCA Pro Comfort Drift Coilovers', 'Australian Track-Tuned Mono-Tube', 'Nissan Silvia S15 / Toyota GT86', 'Used - Mint', 240000, 1, 'MCA', 'coilover', 'Freshly serviced MCA coilovers with zero knocks or leaks.'],
                    ['AG-BYD-009', 'Wilwood', 'Wilwood Hydro Handbrake + Line Kit', 'Vertical/Horizontal Billet Lever', 'Drift Builds (S15 / E36 / GT86)', 'Brand New', 64000, 5, 'WILW', 'caliper', 'Billet aluminum hydraulic handbrake with 0.625 master cylinder.'],
                    ['AG-BYD-010', 'BorgWarner', 'BorgWarner EFR 7163 Internal Gate', 'Gamma-Ti Turbine Wheel + BOV Integrated', '2.0L - 2.5L High Response Builds', 'Brand New', 495000, 1, 'EFR', 'turbo', 'Ultra-fast spooling EFR 7163 turbocharger with integrated recirculation valve.'],
                    ['AG-BYD-011', 'Vibrant', 'Vibrant 3-Inch Titanium Resonator', 'Ultra Quiet Resonator + V-Band Clamps', 'Custom Turbo Exhaust Builds', 'Brand New', 48000, 6, 'VIBR', 'exhaust', 'Straight-through perforated core resonator to eliminate highway drone.'],
                    ['AG-BYD-012', 'Fortune Auto', 'Fortune Auto 500 Series Coilovers', 'Digressive Piston + Swift Springs', 'Honda Civic FD2 / Subaru STI', 'Brand New', 315000, 2, 'FA500', 'coilover', 'Hand-assembled modular coilovers with Swift spring upgrade.'],
                ],
            ],
        ];

        foreach ($shopCatalogs as $shop) {
            foreach ($shop['products'] as $index => $item) {
                [$sku, $brand, $title, $subtitle, $fitment, $condition, $priceLkr, $stock, $watermark, $illustration, $description] = $item;

                PartListing::query()->updateOrCreate(
                    ['sku' => $sku],
                    [
                        'tenant_id' => $tenant->id,
                        'user_id' => $shop['user']->id,
                        'seller_id' => $shop['seller_id'],
                        'brand' => $brand,
                        'title' => $title,
                        'subtitle' => $subtitle,
                        'fitment' => $fitment,
                        'watermark' => $watermark,
                        'illustration' => $illustration,
                        'price_lkr' => $priceLkr,
                        'stock' => $stock,
                        'condition' => $condition,
                        'trust_badges' => ['Verified Seller', 'Hologram Inspected'],
                        'seller_name' => $shop['seller_name'],
                        'location' => $shop['location'],
                        'rating' => $shop['rating'],
                        'is_verified' => true,
                        'specs' => [['label' => $fitment]],
                        'description' => $description,
                        'status' => 'Approved',
                        'views_count' => 140 + ($index * 37),
                        'inquiries_count' => 4 + ($index % 9),
                    ]
                );
            }
        }

        PartListing::query()->updateOrCreate(
            ['sku' => 'AG-MOD-001'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $sellerUser->id,
                'seller_id' => 'seller_jdm',
                'brand' => 'Tomei',
                'title' => 'Tomei Poncam Type-R Camshafts (Pending)',
                'subtitle' => '260 Deg Drop-In Camshaft Set',
                'fitment' => 'Nissan Silvia S15 / SR20DET',
                'watermark' => 'TOMEI',
                'illustration' => 'turbo',
                'price_lkr' => 185000,
                'stock' => 1,
                'condition' => 'Brand New',
                'trust_badges' => ['Verified Seller'],
                'seller_name' => 'JDM Direct Lanka',
                'location' => 'Colombo 05',
                'rating' => '4.95',
                'is_verified' => true,
                'specs' => [['label' => 'Nissan Silvia S15 / SR20DET']],
                'description' => 'Pending moderation review listing for SR20DET.',
                'status' => 'Pending Review',
                'views_count' => 24,
                'inquiries_count' => 1,
            ]
        );

        // ------------------------------------------------------------------
        // Seller Applications (3 Verified Shops + 1 Pending Review)
        // ------------------------------------------------------------------
        $applicationsSeed = [
            [
                'user_id' => $sellerUser->id,
                'business_name' => 'JDM Direct Lanka',
                'owner_name' => 'Ravindu Jayawardena',
                'type' => 'JDM Parts Importer',
                'br_number' => 'PV-00284910',
                'location' => 'Colombo 05',
                'phone' => '+94 77 812 4490',
                'submitted_time_label' => 'Verified Partner',
                'status' => 'Verified',
                'reviewed_by' => $admin->id,
                'reviewed_at' => now()->subDays(30),
                'documents' => ['BR_Certificate_2026.pdf', 'Customs_Import_License.pdf'],
                'specialty' => 'Nissan SR20DET / RB26 & Honda K-Series',
            ],
            [
                'user_id' => $motoSellerUser->id,
                'business_name' => 'HillCountry MotoHub',
                'owner_name' => 'Nuwan Dissanayake',
                'type' => 'Superbike Parts & Exhausts',
                'br_number' => 'W-118294',
                'location' => 'Kandy',
                'phone' => '+94 76 902 1184',
                'submitted_time_label' => 'Verified Partner',
                'status' => 'Verified',
                'reviewed_by' => $admin->id,
                'reviewed_at' => now()->subDays(21),
                'documents' => ['Kandy_MC_Trade_License.pdf'],
                'specialty' => 'Kawasaki ZX-4RR / ZX-10R & Akrapovic',
            ],
            [
                'user_id' => $boostSellerUser->id,
                'business_name' => 'BoostYard Pannipitiya',
                'owner_name' => 'Sahan Perera',
                'type' => 'Recond Performance Parts',
                'br_number' => 'W-094812',
                'location' => 'Pannipitiya',
                'phone' => '+94 77 339 0012',
                'submitted_time_label' => 'Verified Partner',
                'status' => 'Verified',
                'reviewed_by' => $admin->id,
                'reviewed_at' => now()->subDays(14),
                'documents' => ['BR_BoostYard.pdf'],
                'specialty' => 'Garrett Turbos, Link ECUs, Drift Coilovers',
            ],
            [
                'user_id' => null,
                'business_name' => 'Galle Euro & JDM Spares',
                'owner_name' => 'Malith Fernando',
                'type' => 'Performance Spares',
                'br_number' => 'W-204911',
                'location' => 'Galle',
                'phone' => '+94 71 884 2210',
                'submitted_time_label' => '3 hours ago',
                'status' => 'Pending',
                'reviewed_by' => null,
                'reviewed_at' => null,
                'documents' => ['Galle_BR_2026.pdf'],
                'specialty' => 'Subaru EJ20 & European Brakes',
            ],
        ];

        foreach ($applicationsSeed as $app) {
            SellerApplication::query()->updateOrCreate(
                ['br_number' => $app['br_number']],
                array_merge($app, ['tenant_id' => $tenant->id])
            );
        }

        // ------------------------------------------------------------------
        // Sponsored Ads
        // ------------------------------------------------------------------
        $adsSeed = [
            [
                'sponsor' => 'Motul Sri Lanka',
                'headline' => 'Motul 300V Ester Core 10W-40 — 15% Member Discount',
                'placement' => 'Home Feed Native Card',
                'impressions' => '18,420',
                'clicks' => '1,290',
                'ctr' => '7.0%',
                'revenue_lkr' => 85000,
                'is_active' => true,
            ],
            [
                'sponsor' => 'Yokohama Tyres LK',
                'headline' => 'Advan Neova AD09 Track & Street Compound Stock Arrived',
                'placement' => 'Marketplace Top Banner',
                'impressions' => '12,150',
                'clicks' => '740',
                'ctr' => '6.1%',
                'revenue_lkr' => 65000,
                'is_active' => true,
            ],
        ];

        foreach ($adsSeed as $ad) {
            SponsoredAd::query()->updateOrCreate(
                ['headline' => $ad['headline']],
                array_merge($ad, ['tenant_id' => $tenant->id])
            );
        }

        // ------------------------------------------------------------------
        // Buyer Inquiries
        // ------------------------------------------------------------------
        $inq1 = BuyerInquiry::query()->updateOrCreate(
            ['buyer_name' => 'Kavindu Perera', 'part_title' => 'HKS GTIII-RS Sports Turbocharger'],
            [
                'tenant_id' => $tenant->id,
                'seller_user_id' => $sellerUser->id,
                'seller_id' => 'seller_jdm',
                'vehicle' => 'Nissan Silvia S15 (SR20DET)',
                'offer_lkr' => 275000,
                'status' => 'New Inquiry',
                'time_label' => '14m ago',
            ]
        );
        if ($inq1->messages()->count() === 0) {
            InquiryMessage::query()->create([
                'buyer_inquiry_id' => $inq1->id,
                'sender_type' => 'buyer',
                'body' => 'Ayubowan! Does the HKS GTIII-RS come with the actuator bracket and oil feed banjo for S15 SR20DET?',
            ]);
        }

        $inq2 = BuyerInquiry::query()->updateOrCreate(
            ['buyer_name' => 'Dineth Senanayake', 'part_title' => 'Akrapovic Carbon Slip-On Exhaust'],
            [
                'tenant_id' => $tenant->id,
                'seller_user_id' => $motoSellerUser->id,
                'seller_id' => 'seller_moto',
                'vehicle' => 'Kawasaki Ninja ZX-4RR (ZX400P)',
                'offer_lkr' => 190000,
                'status' => 'Reserved (Pickup)',
                'time_label' => '2h ago',
            ]
        );
        if ($inq2->messages()->count() === 0) {
            InquiryMessage::query()->create([
                'buyer_inquiry_id' => $inq2->id,
                'sender_type' => 'buyer',
                'body' => 'Can I pick this up in Kandy this Saturday morning?',
            ]);
            InquiryMessage::query()->create([
                'buyer_inquiry_id' => $inq2->id,
                'sender_type' => 'seller',
                'sender_user_id' => $motoSellerUser->id,
                'body' => 'Yes! Reserved for you at HillCountry MotoHub Kandy.',
            ]);
        }

        // ------------------------------------------------------------------
        // Workshop Bookings
        // ------------------------------------------------------------------
        WorkshopBooking::query()->updateOrCreate(
            ['customer_name' => 'Kavindu Perera', 'service' => '65,000 km Major Service + Hondata Dyno Check'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $admin->id,
                'seller_user_id' => $sellerUser->id,
                'vehicle' => 'Honda Civic Type R (FD2 · K20A)',
                'slot_date' => 'Tomorrow · 10:00 AM',
                'estimate_lkr' => 48500,
                'status' => 'Confirmed',
            ]
        );

        WorkshopBooking::query()->updateOrCreate(
            ['customer_name' => 'Kavindu Perera', 'service' => 'S15 Link G4X Boost & Timing Dyno Check'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $admin->id,
                'seller_user_id' => $sellerUser->id,
                'vehicle' => 'Nissan Silvia S15 (SR20DET)',
                'slot_date' => 'Thu, 19 Nov · 11:00 AM',
                'estimate_lkr' => 32000,
                'status' => 'Pending',
            ]
        );

        WorkshopBooking::query()->updateOrCreate(
            ['customer_name' => 'Dineth Senanayake', 'service' => 'Woolich ECU Quickshifter Calibration'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $userTwo->id,
                'seller_user_id' => $motoSellerUser->id,
                'vehicle' => 'Kawasaki Ninja ZX-4RR (399cc)',
                'slot_date' => 'Wed, 18 Nov · 2:30 PM',
                'estimate_lkr' => 24000,
                'status' => 'Pending',
            ]
        );

        // ------------------------------------------------------------------
        // Subscriptions
        // ------------------------------------------------------------------
        Subscription::query()->updateOrCreate(
            ['reference_id' => 'IBZ-98412'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $admin->id,
                'plan_code' => 'ApexGarage PRO Monthly',
                'carrier' => 'Dialog Axiata (IdeaBiz)',
                'mobile_number' => '+94 77 458 2910',
                'daily_rate_lkr' => 16,
                'status' => 'CHARGED',
            ]
        );

        Subscription::query()->updateOrCreate(
            ['reference_id' => 'IBZ-98411'],
            [
                'tenant_id' => $tenant->id,
                'user_id' => $userTwo->id,
                'plan_code' => 'ApexGarage PRO Monthly',
                'carrier' => 'Dialog Axiata (IdeaBiz)',
                'mobile_number' => '+94 77 123 4567',
                'daily_rate_lkr' => 16,
                'status' => 'CHARGED',
            ]
        );

        // ------------------------------------------------------------------
        // Verified Tuning Workshops
        // ------------------------------------------------------------------
        $workshopsSeed = [
            [
                'name' => 'Apex Dyno Lab Colombo',
                'location' => 'Pannipitiya, Colombo',
                'specialty' => '4WD Rolling Road, Link G4X & Hondata ECU Tuning',
                'rating' => '4.9',
                'reviews_count' => 142,
                'base_price' => 'LKR 18,500',
                'tags' => ['Dyno', 'ECU', 'JDM'],
                'availability' => 'Slots Today',
                'is_verified' => true,
                'owner_user_id' => $sellerUser->id,
            ],
            [
                'name' => 'Kandy Superbike Works',
                'location' => 'Peradeniya Rd, Kandy',
                'specialty' => 'Woolich Racing ECU Flash, Suspension & Valve Clearance',
                'rating' => '4.8',
                'reviews_count' => 89,
                'base_price' => 'LKR 14,000',
                'tags' => ['Superbikes', 'Woolich', 'Brembo'],
                'availability' => 'Tomorrow',
                'is_verified' => true,
                'owner_user_id' => $motoSellerUser->id,
            ],
            [
                'name' => 'Nugegoda Alignment & Track Setup',
                'location' => 'Nawala Rd, Nugegoda',
                'specialty' => 'Corner Balancing, Coilover Setup & Track Alignment',
                'rating' => '4.9',
                'reviews_count' => 116,
                'base_price' => 'LKR 9,500',
                'tags' => ['Alignment', 'Coilovers', 'Track'],
                'availability' => 'Slots Today',
                'is_verified' => true,
                'owner_user_id' => $boostSellerUser->id,
            ],
        ];

        foreach ($workshopsSeed as $workshopData) {
            Workshop::query()->updateOrCreate(
                ['name' => $workshopData['name']],
                array_merge($workshopData, ['tenant_id' => $tenant->id])
            );
        }

        // ------------------------------------------------------------------
        // Enthusiast Crews (3 Crews with members attached)
        // ------------------------------------------------------------------
        $crew1 = Crew::query()->updateOrCreate(
            ['name' => 'Colombo JDM Syndicate'],
            [
                'tenant_id' => $tenant->id,
                'focus' => 'JDM & K-Series',
                'description' => 'Night cruises, dyno nights and Katukurunda track days across Western Province.',
                'location' => 'Colombo',
                'members_count' => 340,
            ]
        );
        $crew1->members()->syncWithoutDetaching([$admin->id, $userTwo->id, $sellerUser->id]);

        $crew2 = Crew::query()->updateOrCreate(
            ['name' => 'HillCountry MotoHub'],
            [
                'tenant_id' => $tenant->id,
                'focus' => 'Superbikes',
                'description' => 'Weekend canyon runs through Kandy, Nuwara Eliya and Knuckles.',
                'location' => 'Kandy',
                'members_count' => 185,
            ]
        );
        $crew2->members()->syncWithoutDetaching([$userTwo->id, $motoSellerUser->id]);

        $crew3 = Crew::query()->updateOrCreate(
            ['name' => 'Sri Lanka Drift & Silvia Club'],
            [
                'tenant_id' => $tenant->id,
                'focus' => 'RWD & Drift',
                'description' => 'S-chassis, GT86 and 1JZ/2JZ builders sharing setup data and track days.',
                'location' => 'Colombo / Negombo',
                'members_count' => 112,
            ]
        );
        $crew3->members()->syncWithoutDetaching([$admin->id, $boostSellerUser->id]);

        // ------------------------------------------------------------------
        // 3 Meetups hosted by one account / crew (Kavindu / Colombo JDM Syndicate)
        // ------------------------------------------------------------------
        $meetsSeed = [
            [
                'pin_id' => 'pin_port_city',
                'title' => 'Colombo Night Touge & Port City Meet',
                'event_date' => 'Sat, 22 Nov · 9:00 PM',
                'location' => 'Port City Promenade, Colombo 01',
                'host' => 'Colombo JDM Syndicate',
                'going_count' => 128,
                'pin_top_ratio' => '0.58',
                'pin_left_ratio' => '0.32',
                'pin_label' => 'Port City',
                'latitude' => 6.9319,
                'longitude' => 79.8428,
                'description' => 'Static JDM showcase, rolling shots and midnight espresso cruise.',
                'status' => 'Upcoming',
            ],
            [
                'pin_id' => 'pin_katukurunda',
                'title' => 'Katukurunda Time Attack Practice Day',
                'event_date' => 'Sun, 30 Nov · 7:30 AM',
                'location' => 'Katukurunda Circuit, Kalutara',
                'host' => 'Colombo JDM Syndicate',
                'going_count' => 64,
                'pin_top_ratio' => '0.72',
                'pin_left_ratio' => '0.36',
                'pin_label' => 'Katukurunda',
                'latitude' => 6.5553,
                'longitude' => 79.9746,
                'description' => 'Open lap timing sessions for street-legal and track-prepped builds.',
                'status' => 'Upcoming',
            ],
            [
                'pin_id' => 'pin_galle_cruise',
                'title' => 'Southern Expressway Sunrise Cars & Coffee',
                'event_date' => 'Sun, 07 Dec · 6:00 AM',
                'location' => 'Kottawa -> Welipenna Rest Area',
                'host' => 'Colombo JDM Syndicate',
                'going_count' => 89,
                'pin_top_ratio' => '0.80',
                'pin_left_ratio' => '0.42',
                'pin_label' => 'Welipenna',
                'latitude' => 6.4250,
                'longitude' => 80.1300,
                'description' => 'Early morning convoy for JDM cars and superbikes with drone photography.',
                'status' => 'Upcoming',
            ],
        ];

        foreach ($meetsSeed as $meetData) {
            $meet = MeetEvent::query()->updateOrCreate(
                ['pin_id' => $meetData['pin_id']],
                array_merge($meetData, [
                    'tenant_id' => $tenant->id,
                    'host_user_id' => $admin->id,
                ])
            );
            $meet->attendees()->syncWithoutDetaching([$admin->id, $userTwo->id]);
        }

        // ------------------------------------------------------------------
        // Live Crew Presence (Actively Online & Riding)
        // ------------------------------------------------------------------
        CrewLivePresence::query()->updateOrCreate(
            ['user_id' => $admin->id],
            [
                'tenant_id' => $tenant->id,
                'vehicle_id' => $fd2->id,
                'is_riding' => true,
                'latitude' => 6.9147,
                'longitude' => 79.8614,
                'status_note' => 'Heading to Port City Promenade',
                'last_seen_at' => now(),
            ]
        );

        CrewLivePresence::query()->updateOrCreate(
            ['user_id' => $userTwo->id],
            [
                'tenant_id' => $tenant->id,
                'vehicle_id' => $zx4rr->id,
                'is_riding' => true,
                'latitude' => 6.9240,
                'longitude' => 79.8442,
                'status_note' => 'Marine Drive evening cruise',
                'last_seen_at' => now(),
            ]
        );

        // ------------------------------------------------------------------
        // Community Feed Posts
        // ------------------------------------------------------------------
        $postsSeed = [
            [
                'user_id' => $admin->id,
                'vehicle_title' => 'Honda Civic Type R (FD2)',
                'mod_title' => 'Hondata FlashPro Street Tune + 262 WHP Dyno Pull',
                'workshop' => 'Apex Dyno Lab Colombo',
                'illustration' => 'fd2',
                'watermark' => 'K20A',
                'tags' => ['K20A', 'Dyno Verified', 'Colombo'],
                'likes_count' => 84,
                'comments_count' => 14,
            ],
            [
                'user_id' => $admin->id,
                'vehicle_title' => 'Nissan Silvia S15 Spec-R',
                'mod_title' => 'Garrett G25-550 Turbo Kit & Link G4X Flex Fuel Map',
                'workshop' => 'BoostYard Pannipitiya',
                'illustration' => 's15',
                'watermark' => 'SR20',
                'tags' => ['418 WHP', 'S15', 'Track'],
                'likes_count' => 162,
                'comments_count' => 33,
            ],
            [
                'user_id' => $userTwo->id,
                'vehicle_title' => 'Mitsubishi Lancer Evolution IX MR',
                'mod_title' => 'Ohlins Road & Track DFV Corner Balance Setup',
                'workshop' => 'Nugegoda Alignment & Track Setup',
                'illustration' => 's15',
                'watermark' => 'EVO9',
                'tags' => ['4G63T', 'Ohlins', 'AWD'],
                'likes_count' => 97,
                'comments_count' => 19,
            ],
            [
                'user_id' => $userTwo->id,
                'vehicle_title' => 'Kawasaki Ninja ZX-4RR',
                'mod_title' => 'Akrapovic Titanium Slip-On + Woolich Quickshifter',
                'workshop' => 'Kandy Superbike Works',
                'illustration' => 'zx4rr',
                'watermark' => 'ZX4RR',
                'tags' => ['16,000 RPM', 'Akrapovic', 'Kandy'],
                'likes_count' => 119,
                'comments_count' => 21,
            ],
        ];

        foreach ($postsSeed as $postData) {
            CommunityPost::query()->updateOrCreate(
                ['mod_title' => $postData['mod_title']],
                array_merge($postData, ['tenant_id' => $tenant->id])
            );
        }

        // ------------------------------------------------------------------
        // Active Partner Promotion
        // ------------------------------------------------------------------
        Promotion::query()->updateOrCreate(
            ['code' => 'APEX-MOTUL15'],
            [
                'tenant_id' => $tenant->id,
                'partner' => 'Motul Sri Lanka',
                'title' => '15% Off 300V Ester Core Oil + Free Filter',
                'description' => 'Valid for all ApexGarage members at verified Colombo & Kandy partner workshops.',
                'participating_workshops' => [
                    'Apex Dyno Lab Colombo',
                    'Kandy Superbike Works',
                    'Nugegoda Alignment & Track Setup',
                ],
                'is_active' => true,
                'starts_at' => now()->subDays(5),
                'ends_at' => now()->addDays(45),
            ]
        );
    }
}
