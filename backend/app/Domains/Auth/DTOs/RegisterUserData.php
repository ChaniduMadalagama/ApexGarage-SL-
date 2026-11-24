<?php

declare(strict_types=1);

namespace App\Domains\Auth\DTOs;

final readonly class RegisterUserData
{
    /**
     * @param  array<int, string>  $cultures
     */
    public function __construct(
        public ?int $tenantId,
        public string $name,
        public string $email,
        public ?string $mobileNumber,
        public string $password,
        public array $cultures,
        public string $deviceName = 'apexgarage-mobile',
    ) {}
}
