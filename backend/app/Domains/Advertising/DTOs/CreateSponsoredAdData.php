<?php

declare(strict_types=1);

namespace App\Domains\Advertising\DTOs;

final readonly class CreateSponsoredAdData
{
    public function __construct(
        public ?int $tenantId,
        public string $sponsor,
        public string $headline,
        public string $placement,
        public int $revenueLkr,
    ) {}
}
