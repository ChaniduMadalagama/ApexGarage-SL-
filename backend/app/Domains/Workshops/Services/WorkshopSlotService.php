<?php

declare(strict_types=1);

namespace App\Domains\Workshops\Services;

use App\Domains\Workshops\Models\Workshop;
use App\Domains\Workshops\Models\WorkshopBooking;
use Illuminate\Support\Carbon;

final class WorkshopSlotService
{
    /**
     * @return list<array{slot: string, available: bool}>
     */
    public function slotsFor(Workshop $workshop): array
    {
        $booked = WorkshopBooking::query()
            ->where('workshop_id', $workshop->id)
            ->whereIn('status', ['Pending', 'Confirmed'])
            ->pluck('slot_date')
            ->flip();

        $slots = [];
        $days = (int) config('apex.workshop_slot_days', 5);
        /** @var list<string> $times */
        $times = (array) config('apex.workshop_slot_times', []);

        for ($i = 1; $i <= $days; $i++) {
            $day = Carbon::now()->addDays($i)->format('D, d M');
            foreach ($times as $time) {
                $label = $day.' · '.$time;
                $slots[] = ['slot' => $label, 'available' => ! $booked->has($label)];
            }
        }

        return $slots;
    }

    /**
     * @return list<array{key: string, label: string, price_lkr: int}>
     */
    public function services(): array
    {
        /** @var list<array{key: string, label: string, price_lkr: int}> $services */
        $services = (array) config('apex.workshop_services', []);

        return $services;
    }
}
