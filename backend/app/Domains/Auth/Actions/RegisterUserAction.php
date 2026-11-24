<?php

declare(strict_types=1);

namespace App\Domains\Auth\Actions;

use App\Domains\Auth\DTOs\RegisterUserData;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class RegisterUserAction
{
    /**
     * @return array{user: User, token: string}
     */
    public function execute(RegisterUserData $data): array
    {
        return DB::transaction(function () use ($data): array {
            // is_pro / roles are never client controlled: new accounts are free members.
            $user = User::query()->create([
                'tenant_id' => $data->tenantId,
                'name' => $data->name,
                'email' => $data->email,
                'mobile_number' => $data->mobileNumber,
                'handle' => '@'.Str::slug($data->name, '.').'.'.random_int(100, 999),
                'city' => 'Colombo, LK',
                'is_pro' => false,
                'onboarding_completed' => false,
                'cultures' => $data->cultures,
                'password' => $data->password,
            ]);

            $token = $user->createToken(
                $data->deviceName,
                ['*'],
                now()->addDays((int) config('apex.token_ttl_days', 30)),
            )->plainTextToken;

            return ['user' => $user, 'token' => $token];
        });
    }
}
