<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Workshops\Models\WorkshopBooking;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin WorkshopBooking
 */
final class BookingResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'booking_ref' => $this->booking_ref,
            'status' => $this->status,
            'service' => $this->service,
            'slot' => $this->slot_date,
            'vehicle' => $this->vehicle,
            'estimate_lkr' => $this->estimate_lkr,
        ];
    }
}
