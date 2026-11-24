<?php

declare(strict_types=1);

namespace App\Domains\Vetting\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Vetting\DTOs\RegisterMerchantData;
use App\Domains\Vetting\Models\SellerApplication;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

final class RegisterMerchantAction
{
    public function execute(RegisterMerchantData $data): SellerApplication
    {
        return DB::transaction(function () use ($data): SellerApplication {
            $user = User::query()->create([
                'tenant_id' => $data->tenantId,
                'name' => $data->ownerName,
                'email' => $data->email,
                'mobile_number' => $data->phone,
                'city' => $data->location,
                'is_pro' => false,
                'password' => Hash::make($data->password),
            ]);

            $role = Role::findOrCreate('workshop-partner', 'web');
            $user->assignRole($role);

            $application = SellerApplication::query()->create([
                'tenant_id' => $data->tenantId,
                'user_id' => $user->id,
                'business_name' => $data->shopName,
                'owner_name' => $data->ownerName,
                'type' => $data->shopType,
                'br_number' => strtoupper($data->brNumber),
                'location' => $data->location,
                'phone' => $data->phone,
                'submitted_time_label' => 'Just now',
                'status' => 'Pending',
                'documents' => ['BR_Certificate_2026.pdf', 'Tax_TIN_Certificate.pdf'],
                'specialty' => $data->specialty,
            ]);

            event(new DomainStateChanged(
                domain: 'vetting',
                action: 'seller_application.submitted',
                tenantId: $application->tenant_id,
            ));

            return $application;
        });
    }
}
