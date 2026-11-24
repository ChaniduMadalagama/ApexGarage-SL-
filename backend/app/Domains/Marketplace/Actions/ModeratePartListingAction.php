<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Marketplace\Models\PartListing;
use Illuminate\Support\Facades\DB;

final class ModeratePartListingAction
{
    public function updateStatus(PartListing $listing, string $status): PartListing
    {
        return DB::transaction(function () use ($listing, $status): PartListing {
            $listing->update(['status' => $status]);

            event(new DomainStateChanged(
                domain: 'marketplace',
                action: 'part_listing.'.strtolower(str_replace(' ', '_', $status)),
                tenantId: $listing->tenant_id,
            ));

            return $listing->fresh() ?? $listing;
        });
    }

    public function updateInventory(PartListing $listing, int $priceLkr, int $stock): PartListing
    {
        return DB::transaction(function () use ($listing, $priceLkr, $stock): PartListing {
            $listing->update([
                'price_lkr' => max(100, $priceLkr),
                'stock' => max(0, $stock),
            ]);

            event(new DomainStateChanged(
                domain: 'marketplace',
                action: 'part_listing.inventory_updated',
                tenantId: $listing->tenant_id,
            ));

            return $listing->fresh() ?? $listing;
        });
    }
}
