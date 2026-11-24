<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Marketplace\Models\PartListing;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin PartListing
 */
final class PartResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'sku' => $this->sku,
            'brand' => $this->brand,
            'title' => $this->title,
            'subtitle' => $this->subtitle,
            'fitment' => $this->fitment,
            'watermark' => $this->watermark,
            'illustration' => $this->illustration,
            'photo_url' => $this->photo_url,
            'price_lkr' => $this->price_lkr,
            'stock' => $this->stock,
            'condition' => $this->condition,
            'trust_badges' => $this->trust_badges ?? [],
            'seller_name' => $this->seller_name,
            'location' => $this->location,
            'rating' => $this->rating,
            'is_verified' => $this->is_verified,
            'specs' => $this->specs ?? [],
            'description' => $this->description,
            'status' => $this->status,
            'saved_by_me' => (bool) $this->resource->getAttribute('saved_by_me'),
            'is_mine' => $request->user('sanctum')?->getAuthIdentifier() === $this->user_id,
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
