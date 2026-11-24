<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\Promotion;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin Promotion
 */
final class PromotionResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'partner' => $this->partner,
            'code' => $this->code,
            'title' => $this->title,
            'description' => $this->description,
            'participating_workshops' => $this->participating_workshops ?? [],
            'ends_at' => $this->ends_at?->toIso8601String(),
        ];
    }
}
