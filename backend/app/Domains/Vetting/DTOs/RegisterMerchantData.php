<?php

declare(strict_types=1);

namespace App\Domains\Vetting\DTOs;

final readonly class RegisterMerchantData
{
    public function __construct(
        public ?int $tenantId,
        public string $shopName,
        public string $ownerName,
        public string $email,
        public string $password,
        public string $phone,
        public string $brNumber,
        public string $location,
        public string $shopType,
        public string $specialty = 'JDM & Performance Parts',
    ) {}
}
