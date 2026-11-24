<?php

declare(strict_types=1);

namespace App\Domains\Garage\DTOs;

final readonly class CreateBuildLogData
{
    public function __construct(
        public int $vehicleId,
        public string $category,
        public string $title,
        public string $brand,
        public int $costLkr,
        public string $mechanic,
        public ?string $notes = null,
        public ?string $photoLabel = null,
        public ?string $photoUrl = null,
        public bool $shareToFeed = false,
    ) {}
}
