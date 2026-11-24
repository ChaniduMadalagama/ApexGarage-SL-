<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\CrewLivePresence;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Garage\Models\Vehicle;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class UpdateCrewLivePresenceAction
{
    public function execute(
        User $user,
        bool $isRiding,
        float $latitude,
        float $longitude,
        ?int $vehicleId = null,
        ?string $statusNote = null,
    ): CrewLivePresence {
        return DB::transaction(function () use ($user, $isRiding, $latitude, $longitude, $vehicleId, $statusNote): CrewLivePresence {
            $resolvedVehicleId = null;
            if ($vehicleId !== null) {
                $vehicle = Vehicle::query()
                    ->where('id', $vehicleId)
                    ->where('user_id', $user->id)
                    ->first();
                $resolvedVehicleId = $vehicle?->id;
            } elseif ($user->active_vehicle_id !== null) {
                $resolvedVehicleId = $user->active_vehicle_id;
            }

            $presence = CrewLivePresence::query()->updateOrCreate(
                ['user_id' => $user->id],
                [
                    'tenant_id' => $user->tenant_id,
                    'vehicle_id' => $resolvedVehicleId,
                    'is_riding' => $isRiding,
                    'latitude' => $latitude,
                    'longitude' => $longitude,
                    'status_note' => $statusNote !== null && trim($statusNote) !== '' ? trim($statusNote) : null,
                    'last_seen_at' => now(),
                ]
            );

            event(new DomainStateChanged(
                domain: 'community',
                action: $isRiding ? 'crew.live_started' : 'crew.live_stopped',
                tenantId: $user->tenant_id,
            ));

            return $presence->load(['user', 'vehicle']);
        });
    }
}
