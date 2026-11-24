<?php

declare(strict_types=1);

namespace App\Domains\Auth\Actions;

use App\Domains\Auth\DTOs\AuthenticateUserData;
use App\Models\User;
use App\Support\PhoneNumber;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

final class IssueSanctumTokenAction
{
    /**
     * @return array{user: User, token: string}
     */
    public function execute(AuthenticateUserData $data): array
    {
        $query = User::query()->withoutGlobalScopes();

        if (PhoneNumber::looksLikeEmail($data->identifier)) {
            $query->where('email', mb_strtolower($data->identifier));
        } else {
            $mobile = PhoneNumber::normalize($data->identifier);
            $mobile !== null ? $query->where('mobile_number', $mobile) : $query->whereRaw('1 = 0');
        }

        $user = $query->first();

        // Always perform one bcrypt comparison so response time does not reveal
        // whether an account exists (prevents account enumeration by timing).
        $hash = $user !== null ? $user->password : self::dummyHash();
        $valid = Hash::check($data->password, $hash);

        if ($user === null || ! $valid) {
            throw ValidationException::withMessages([
                'identifier' => ['The provided credentials do not match our records.'],
            ]);
        }

        // One active token per device name: re-login rotates the token.
        $user->tokens()->where('name', $data->deviceName)->delete();

        $token = $user->createToken(
            $data->deviceName,
            ['*'],
            now()->addDays((int) config('apex.token_ttl_days', 30)),
        )->plainTextToken;

        return [
            'user' => $user,
            'token' => $token,
        ];
    }

    private static function dummyHash(): string
    {
        static $hash = null;

        return $hash ??= Hash::make('apexgarage-dummy-password');
    }
}
