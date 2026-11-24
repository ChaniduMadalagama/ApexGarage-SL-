<?php

declare(strict_types=1);

namespace App\Services\Billing;

use App\Contracts\TelcoBillingGatewayInterface;
use Illuminate\Support\Str;

final class IdeaBizBillingGateway implements TelcoBillingGatewayInterface
{
    /**
     * @return array{reference_id: string, status: string, carrier: string}
     */
    public function initiateSubscription(string $mobileNumber, string $planCode, int $dailyRateLkr): array
    {
        $normalized = preg_replace('/\D+/', '', $mobileNumber) ?? '';
        $carrier = str_starts_with($normalized, '9477') || str_starts_with($normalized, '077')
            ? 'Dialog Axiata (IdeaBiz)'
            : 'SL Telco Direct';

        return [
            'reference_id' => 'IBZ-'.strtoupper(Str::random(10)),
            'status' => 'pending_otp',
            'carrier' => $carrier,
        ];
    }

    public function verifyOtp(string $referenceId, string $otp): bool
    {
        return strlen(trim($otp)) === 6 && str_starts_with($referenceId, 'IBZ-');
    }
}
