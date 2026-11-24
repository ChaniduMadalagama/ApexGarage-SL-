<?php

declare(strict_types=1);

namespace App\Domains\Garage\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Garage\DTOs\CreateVehicleData;
use App\Domains\Garage\Models\Vehicle;
use Illuminate\Support\Facades\DB;

final class RegisterVehicleAction
{
    public function execute(CreateVehicleData $data): Vehicle
    {
        return DB::transaction(function () use ($data): Vehicle {
            $vehicle = Vehicle::query()->create([
                'tenant_id' => $data->tenantId,
                'user_id' => $data->userId,
                'category' => $data->category,
                'brand' => $data->brand,
                'title' => $data->title,
                'subtitle' => $data->subtitle,
                'watermark' => $data->watermark,
                'illustration' => $data->illustration,
                'photo_url' => $data->photoUrl,
                'stage_badge' => $data->stageBadge,
                'status' => $data->status,
                'status_tone' => $data->statusTone,
                'year' => $data->year,
                'chassis' => $data->chassis,
                'engine_code' => $data->engineCode,
                'engine' => $data->engine,
                'current_mileage' => $data->currentMileage,
                'next_service_mileage' => $data->nextServiceMileage,
                'power_value' => $data->powerValue,
                'power_unit' => $data->powerUnit,
                'torque_value' => $data->torqueValue,
                'estimated_value_lkr' => $data->estimatedValueLkr,
                'specs' => $data->specs,
            ]);

            event(new DomainStateChanged(
                domain: 'garage',
                action: 'vehicle.registered',
                tenantId: $vehicle->tenant_id,
            ));

            return $vehicle;
        });
    }
}
