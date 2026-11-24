<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\DTOs;

final readonly class CreatePartListingData
{
    /**
     * @param  array<int, string>  $trustBadges
     * @param  array<int, array<string, mixed>>  $specs
     */
    public function __construct(
        public int $userId,
        public ?int $tenantId,
        public string $brand,
        public string $title,
        public string $subtitle,
        public string $watermark,
        public string $illustration,
        public int $priceLkr,
        public string $condition,
        public array $trustBadges,
        public string $sellerName,
        public string $location,
        public string $rating,
        public bool $isVerified,
        public array $specs,
        public string $description,
        public string $status = 'active',
        public ?string $sku = null,
        public ?string $fitment = null,
        public int $stock = 1,
        public string $sellerId = 'seller_jdm',
        public ?string $photoUrl = null,
    ) {}
}
