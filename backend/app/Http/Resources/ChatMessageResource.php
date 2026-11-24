<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Marketplace\Models\InquiryMessage;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Rendered from the BUYER's perspective: buyer messages are "me".
 *
 * @mixin InquiryMessage
 */
final class ChatMessageResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'from' => $this->sender_type === 'buyer' ? 'me' : 'seller',
            'text' => $this->body,
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
