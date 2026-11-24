<?php

declare(strict_types=1);

namespace App\Domains\Subscriptions\Actions;

use App\Contracts\TelcoBillingGatewayInterface;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Subscriptions\DTOs\SubscribeIdeaBizData;
use App\Domains\Subscriptions\Jobs\SyncIdeaBizSubscriptionJob;
use App\Domains\Subscriptions\Models\Subscription;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class ActivateIdeaBizSubscriptionAction
{
    public function __construct(
        private readonly TelcoBillingGatewayInterface $billingGateway,
    ) {}

    public function execute(SubscribeIdeaBizData $data): Subscription
    {
        return DB::transaction(function () use ($data): Subscription {
            $gatewayResult = $this->billingGateway->initiateSubscription(
                mobileNumber: $data->mobileNumber,
                planCode: $data->planCode,
                dailyRateLkr: $data->dailyRateLkr,
            );

            $subscription = Subscription::query()->create([
                'tenant_id' => $data->tenantId,
                'user_id' => $data->userId,
                'plan_code' => $data->planCode,
                'carrier' => $gatewayResult['carrier'],
                'mobile_number' => $data->mobileNumber,
                'daily_rate_lkr' => $data->dailyRateLkr,
                'reference_id' => $gatewayResult['reference_id'],
                'status' => 'active',
            ]);

            User::query()->whereKey($data->userId)->update(['is_pro' => true]);

            SyncIdeaBizSubscriptionJob::dispatch($subscription->id);

            event(new DomainStateChanged(
                domain: 'subscriptions',
                action: 'ideabiz.activated',
                tenantId: $subscription->tenant_id,
            ));

            return $subscription;
        });
    }
}
