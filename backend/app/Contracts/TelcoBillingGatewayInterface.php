<?php

declare(strict_types=1);

namespace App\Contracts;

interface TelcoBillingGatewayInterface
{
    /**
     * @return array{reference_id: string, status: string, carrier: string}
     */
    public function initiateSubscription(string $mobileNumber, string $planCode, int $dailyRateLkr): array;

    public function verifyOtp(string $referenceId, string $otp): bool;
}
