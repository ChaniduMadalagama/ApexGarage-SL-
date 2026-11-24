<?php

declare(strict_types=1);

namespace App\Domains\Garage\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Garage\DTOs\CreateServiceRecordData;
use App\Domains\Garage\Jobs\ProcessServiceReceiptOcrJob;
use App\Domains\Garage\Models\ServiceRecord;
use App\Domains\Garage\Models\Vehicle;
use Illuminate\Support\Facades\DB;

final class LogServiceRecordAction
{
    public function execute(CreateServiceRecordData $data): ServiceRecord
    {
        return DB::transaction(function () use ($data): ServiceRecord {
            $vehicle = Vehicle::query()->findOrFail($data->vehicleId);

            $record = ServiceRecord::query()->create([
                'vehicle_id' => $vehicle->id,
                'title' => $data->title,
                'service_date' => $data->serviceDate,
                'odometer_km' => $data->odometerKm,
                'workshop' => $data->workshop,
                'parts_changed' => $data->partsChanged,
                'cost_lkr' => $data->costLkr,
                'next_service_km' => $data->nextServiceKm,
                'next_service_date' => $data->nextServiceDate,
                'notes' => $data->notes,
                'receipt_label' => $data->receiptLabel,
            ]);

            $newMileage = max($vehicle->current_mileage, $data->odometerKm);
            $isUrgent = ($data->nextServiceKm - $newMileage) <= 1000;

            $vehicle->update([
                'current_mileage' => $newMileage,
                'next_service_mileage' => $data->nextServiceKm,
                'status' => $isUrgent ? 'Due Soon' : 'Health OK',
                'status_tone' => $isUrgent ? 'amber' : 'emerald',
            ]);

            ProcessServiceReceiptOcrJob::dispatch($record->id);

            event(new DomainStateChanged(
                domain: 'garage',
                action: 'service_record.logged',
                tenantId: $vehicle->tenant_id,
            ));

            return $record;
        });
    }
}
