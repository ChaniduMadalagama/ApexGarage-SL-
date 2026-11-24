<?php

declare(strict_types=1);

namespace App\Domains\Advertising\Actions;

use App\Domains\Advertising\DTOs\CreateSponsoredAdData;
use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Dashboard\Events\DomainStateChanged;
use Illuminate\Support\Facades\DB;

final class ManageSponsoredAdAction
{
    public function create(CreateSponsoredAdData $data): SponsoredAd
    {
        return DB::transaction(function () use ($data): SponsoredAd {
            $ad = SponsoredAd::query()->create([
                'tenant_id' => $data->tenantId,
                'sponsor' => $data->sponsor,
                'headline' => $data->headline,
                'placement' => $data->placement,
                'impressions' => '0',
                'clicks' => '0',
                'ctr' => '0.0%',
                'revenue_lkr' => $data->revenueLkr,
                'is_active' => true,
            ]);

            event(new DomainStateChanged(
                domain: 'advertising',
                action: 'sponsored_ad.created',
                tenantId: $ad->tenant_id,
            ));

            return $ad;
        });
    }

    public function toggle(SponsoredAd $ad): SponsoredAd
    {
        return DB::transaction(function () use ($ad): SponsoredAd {
            $ad->update(['is_active' => ! $ad->is_active]);

            event(new DomainStateChanged(
                domain: 'advertising',
                action: 'sponsored_ad.toggled',
                tenantId: $ad->tenant_id,
            ));

            return $ad->fresh() ?? $ad;
        });
    }
}
