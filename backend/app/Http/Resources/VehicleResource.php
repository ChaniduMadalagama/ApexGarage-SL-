<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Garage\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Callers must eager load `latestServiceRecord` and `buildLogs_count` /
 * `serviceRecords_count` (list) or `buildLogs` / `serviceRecords` (detail).
 *
 * @mixin Vehicle
 */
final class VehicleResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $latest = $this->relationLoaded('latestServiceRecord') ? $this->latestServiceRecord : null;
        $lastServiceMileage = $latest !== null ? $latest->odometer_km : $this->current_mileage;
        $kmLeft = $this->next_service_mileage - $this->current_mileage;

        return [
            'id' => $this->id,
            'category' => $this->category,
            'brand' => $this->brand,
            'title' => $this->title,
            'subtitle' => $this->subtitle,
            'watermark' => $this->watermark,
            'illustration' => $this->illustration,
            'photo_url' => $this->photo_url,
            'stage_badge' => $this->stage_badge,
            'status' => $this->status,
            'status_tone' => $this->status_tone,
            'year' => $this->year,
            'chassis' => $this->chassis,
            'engine_code' => $this->engine_code,
            'engine' => $this->engine,
            'current_mileage' => $this->current_mileage,
            'last_service_mileage' => $lastServiceMileage,
            'service_interval' => max(0, $this->next_service_mileage - $lastServiceMileage),
            'next_service_mileage' => $this->next_service_mileage,
            'next_service_date' => $latest?->next_service_date,
            'km_left_until_service' => $kmLeft,
            'is_service_urgent' => $kmLeft <= 1000,
            'power_value' => $this->power_value,
            'power_unit' => $this->power_unit,
            'torque_value' => $this->torque_value,
            'estimated_value_lkr' => $this->estimated_value_lkr,
            'specs' => $this->specs ?? [],
            'build_logs_count' => $this->whenCounted('buildLogs'),
            'service_records_count' => $this->whenCounted('serviceRecords'),
            'build_logs' => BuildLogResource::collection($this->whenLoaded('buildLogs')),
            'service_records' => ServiceRecordResource::collection($this->whenLoaded('serviceRecords')),
        ];
    }
}
