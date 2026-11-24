<?php

declare(strict_types=1);

namespace App\Domains\Workshops\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Workshops\Models\WorkshopBooking;
use Illuminate\Support\Facades\DB;

final class ManageWorkshopBookingAction
{
    public function transitionStatus(WorkshopBooking $booking, string $status): WorkshopBooking
    {
        return DB::transaction(function () use ($booking, $status): WorkshopBooking {
            $booking->update(['status' => $status]);

            event(new DomainStateChanged(
                domain: 'workshops',
                action: 'booking.'.strtolower($status),
                tenantId: $booking->tenant_id,
            ));

            return $booking->fresh() ?? $booking;
        });
    }
}
