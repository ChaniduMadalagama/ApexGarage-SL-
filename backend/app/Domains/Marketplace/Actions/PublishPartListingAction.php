<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Marketplace\DTOs\CreatePartListingData;
use App\Domains\Marketplace\Models\PartListing;
use Illuminate\Support\Facades\DB;

final class PublishPartListingAction
{
    public function execute(CreatePartListingData $data): PartListing
    {
        return DB::transaction(function () use ($data): PartListing {
            $listing = PartListing::query()->create([
                'tenant_id' => $data->tenantId,
                'user_id' => $data->userId,
                'seller_id' => $data->sellerId,
                'sku' => $data->sku,
                'brand' => $data->brand,
                'title' => $data->title,
                'subtitle' => $data->subtitle,
                'fitment' => $data->fitment ?? $data->subtitle,
                'watermark' => $data->watermark,
                'illustration' => $data->illustration,
                'photo_url' => $data->photoUrl,
                'price_lkr' => $data->priceLkr,
                'stock' => $data->stock,
                'condition' => $data->condition,
                'trust_badges' => $data->trustBadges,
                'seller_name' => $data->sellerName,
                'location' => $data->location,
                'rating' => $data->rating,
                'is_verified' => $data->isVerified,
                'specs' => $data->specs,
                'description' => $data->description,
                'status' => $data->status,
                'views_count' => 1,
                'inquiries_count' => 0,
            ]);

            event(new DomainStateChanged(
                domain: 'marketplace',
                action: 'part_listing.published',
                tenantId: $listing->tenant_id,
            ));

            return $listing;
        });
    }
}
