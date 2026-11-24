<?php

declare(strict_types=1);

namespace App\Domains\Auth\DTOs;

final readonly class AuthenticateUserData
{
    public function __construct(
        public string $identifier,
        public string $password,
        public string $deviceName = 'apexgarage-mobile',
    ) {}
}
