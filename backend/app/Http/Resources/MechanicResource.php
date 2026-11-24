<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Workshops\Models\Workshop;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin Workshop
 */
final class MechanicResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'location' => $this->location,
            'specialty' => $this->specialty,
            'rating' => $this->rating,
            'reviews_count' => $this->reviews_count,
            'base_price' => $this->base_price,
            'tags' => $this->tags ?? [],
            'availability' => $this->availability,
            'is_verified' => $this->is_verified,
        ];
    }
}
