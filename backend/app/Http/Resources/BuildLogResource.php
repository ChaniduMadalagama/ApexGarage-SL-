<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Garage\Models\BuildLog;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin BuildLog
 */
final class BuildLogResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'date' => $this->log_date,
            'category' => $this->category,
            'title' => $this->title,
            'brand' => $this->brand,
            'cost_lkr' => $this->cost_lkr,
            'mechanic' => $this->mechanic,
            'notes' => $this->notes,
            'photo_label' => $this->photo_label,
            'photo_url' => $this->photo_url,
        ];
    }
}
