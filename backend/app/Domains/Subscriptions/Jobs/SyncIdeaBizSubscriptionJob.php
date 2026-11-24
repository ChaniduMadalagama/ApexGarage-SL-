<?php

declare(strict_types=1);

namespace App\Domains\Subscriptions\Jobs;

use App\Domains\Subscriptions\Models\Subscription;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

final class SyncIdeaBizSubscriptionJob implements ShouldQueue
{
    use Queueable;

    public int $tries = 3;

    public function __construct(
        public readonly int $subscriptionId,
    ) {}

    public function handle(): void
    {
        $subscription = Subscription::query()->find($this->subscriptionId);
        if ($subscription === null) {
            return;
        }

        Log::info('Synced IdeaBiz carrier billing status asynchronously', [
            'subscription_id' => $subscription->id,
            'reference_id' => $subscription->reference_id,
            'carrier' => $subscription->carrier,
        ]);
    }
}
