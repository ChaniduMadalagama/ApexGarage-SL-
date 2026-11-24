<?php

declare(strict_types=1);

return [
    /*
    |--------------------------------------------------------------------------
    | Default tenant (guests / public endpoints)
    |--------------------------------------------------------------------------
    | Authenticated requests always use the tenant of the Sanctum user.
    | Anonymous requests can only ever see this tenant. The client can never
    | choose a tenant (the old X-Tenant-ID header was removed).
    */
    'default_tenant_slug' => env('APEX_DEFAULT_TENANT', 'colombo-hq'),

    /*
    | Mobile access-token lifetime. Tokens are rotated per device on login.
    */
    'token_ttl_days' => (int) env('APEX_TOKEN_TTL_DAYS', 30),

    /*
    | Disk used for user uploads (receipts, photos). Use "s3" in production.
    */
    'media_disk' => env('APEX_MEDIA_DISK', 'public'),

    'pagination' => [
        'default' => 20,
        'max' => 50,
    ],

    'cache_ttl' => [
        'histogram' => 120,
        'promotion' => 300,
        'default_tenant' => 3600,
    ],

    'workshop_services' => [
        ['key' => 'dyno', 'label' => 'Dyno Tuning Session', 'price_lkr' => 18500],
        ['key' => 'ecu', 'label' => 'ECU Remap / Flash', 'price_lkr' => 24000],
        ['key' => 'service', 'label' => 'Full Performance Service', 'price_lkr' => 15000],
        ['key' => 'inspection', 'label' => 'Pre-Purchase Inspection', 'price_lkr' => 8500],
    ],

    'workshop_slot_times' => ['09:00 AM', '10:30 AM', '01:00 PM', '02:30 PM', '04:00 PM'],
    'workshop_slot_days' => 5,

    'build_log_categories' => ['Engine', 'Brakes', 'Exhaust', 'Suspension', 'Service', 'Other'],
    'cultures' => ['JDM Cars', 'Superbikes', 'Track & Drift'],
];
