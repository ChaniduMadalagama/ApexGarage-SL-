<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Garage\Models\ServiceRecord;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin ServiceRecord
 */
final class ServiceRecordResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'date' => $this->service_date,
            'odometer_km' => $this->odometer_km,
            'workshop' => $this->workshop,
            'parts_changed' => $this->parts_changed ?? [],
            'cost_lkr' => $this->cost_lkr,
            'next_service_km' => $this->next_service_km,
            'next_service_date' => $this->next_service_date,
            'notes' => $this->notes,
            'receipt_label' => $this->receipt_label,
        ];
    }
}
