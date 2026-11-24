<?php

declare(strict_types=1);

namespace App\Domains\Subscriptions\DTOs;

final readonly class SubscribeIdeaBizData
{
    public function __construct(
        public int $userId,
        public ?int $tenantId,
        public string $mobileNumber,
        public string $planCode = 'APEX_PRO_DAILY',
        public int $dailyRateLkr = 5,
    ) {}
}
