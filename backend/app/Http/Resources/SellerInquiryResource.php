<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Marketplace\Models\BuyerInquiry;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin BuyerInquiry
 */
final class SellerInquiryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'buyer_name' => $this->buyer_name,
            'part_title' => $this->part_title,
            'vehicle' => $this->vehicle,
            'offer_lkr' => (int) $this->offer_lkr,
            'status' => $this->status,
            'time_label' => $this->time_label,
            'messages' => ChatMessageResource::collection($this->whenLoaded('messages')),
        ];
    }
}
