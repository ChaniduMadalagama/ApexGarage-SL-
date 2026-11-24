<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Models\User;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Finds (or opens) the single inquiry thread between a buyer and a listing.
 * Backed by a UNIQUE(buyer_user_id, part_listing_id) index so concurrent
 * requests can never create duplicate threads.
 */
final class OpenPartInquiryAction
{
    /**
     * @return array{inquiry: BuyerInquiry, created: bool}
     */
    public function execute(User $buyer, PartListing $part, string $initialStatus): array
    {
        if ($part->status !== 'Approved') {
            throw ValidationException::withMessages(['part' => ['This listing is not available.']]);
        }

        if ($part->user_id === $buyer->id) {
            throw ValidationException::withMessages(['part' => ['You cannot message or reserve your own listing.']]);
        }

        $keys = ['buyer_user_id' => $buyer->id, 'part_listing_id' => $part->id];

        $existing = BuyerInquiry::query()->where($keys)->first();
        if ($existing !== null) {
            return ['inquiry' => $existing, 'created' => false];
        }

        $vehicleLabel = $buyer->active_vehicle_id !== null
            ? Vehicle::query()->whereKey($buyer->active_vehicle_id)->value('title')
            : null;

        try {
            $inquiry = DB::transaction(function () use ($buyer, $part, $keys, $initialStatus, $vehicleLabel): BuyerInquiry {
                $inquiry = BuyerInquiry::query()->create($keys + [
                    'tenant_id' => $part->tenant_id,
                    'seller_user_id' => $part->user_id,
                    'seller_id' => (string) $part->seller_id,
                    'buyer_name' => $buyer->name,
                    'vehicle' => is_string($vehicleLabel) && $vehicleLabel !== '' ? $vehicleLabel : 'Not specified',
                    'part_title' => $part->title,
                    'offer_lkr' => $part->price_lkr,
                    'status' => $initialStatus,
                    'time_label' => 'Just now',
                ]);

                PartListing::query()->whereKey($part->id)->increment('inquiries_count');

                return $inquiry;
            });
        } catch (UniqueConstraintViolationException) {
            $inquiry = BuyerInquiry::query()->where($keys)->firstOrFail();

            return ['inquiry' => $inquiry, 'created' => false];
        }

        return ['inquiry' => $inquiry, 'created' => true];
    }
}
