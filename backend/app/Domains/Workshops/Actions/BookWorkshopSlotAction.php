<?php

declare(strict_types=1);

namespace App\Domains\Workshops\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Workshops\Models\Workshop;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Domains\Workshops\Services\WorkshopSlotService;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

final class BookWorkshopSlotAction
{
    public function __construct(
        private readonly WorkshopSlotService $slots,
    ) {}

    public function execute(User $user, Workshop $workshop, string $serviceKey, string $slot, ?int $vehicleId): WorkshopBooking
    {
        $service = collect($this->slots->services())->firstWhere('key', $serviceKey);
        if ($service === null) {
            throw ValidationException::withMessages(['service_type' => ['Unknown service type.']]);
        }

        $vehicleLabel = 'Not specified';
        if ($vehicleId !== null) {
            $vehicle = Vehicle::query()->where('user_id', $user->id)->find($vehicleId);
            if ($vehicle === null) {
                throw ValidationException::withMessages(['vehicle_id' => ['Vehicle not found in your garage.']]);
            }
            $vehicleLabel = $vehicle->title;
        }

        return DB::transaction(function () use ($user, $workshop, $service, $slot, $vehicleLabel): WorkshopBooking {
            // Serialise bookings per workshop so two users cannot take the same slot.
            Workshop::query()->whereKey($workshop->id)->lockForUpdate()->first();

            $available = collect($this->slots->slotsFor($workshop))
                ->contains(fn (array $s): bool => $s['slot'] === $slot && $s['available']);

            if (! $available) {
                throw ValidationException::withMessages(['slot' => ['That time slot is no longer available.']]);
            }

            $booking = WorkshopBooking::query()->create([
                'tenant_id' => $workshop->tenant_id,
                'seller_user_id' => $workshop->owner_user_id,
                'workshop_id' => $workshop->id,
                'user_id' => $user->id,
                'booking_ref' => $this->generateReference(),
                'customer_name' => $user->name,
                'vehicle' => $vehicleLabel,
                'service' => $service['label'].' · '.$workshop->name,
                'slot_date' => $slot,
                'estimate_lkr' => (int) $service['price_lkr'],
                'status' => 'Pending',
            ]);

            event(new DomainStateChanged(
                domain: 'workshops',
                action: 'booking.requested',
                tenantId: $workshop->tenant_id,
            ));

            return $booking;
        });
    }

    private function generateReference(): string
    {
        do {
            $ref = 'APX-BK-'.random_int(10000, 99999);
        } while (WorkshopBooking::query()->where('booking_ref', $ref)->exists());

        return $ref;
    }
}
