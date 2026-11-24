<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Advertising\Models\SponsoredAd;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin SponsoredAd
 */
final class SponsoredAdResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'sponsor' => $this->sponsor,
            'headline' => $this->headline,
            'placement' => $this->placement,
        ];
    }
}
