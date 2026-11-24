<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\InquiryMessage;
use Illuminate\Support\Facades\DB;

final class ReplyBuyerInquiryAction
{
    public function execute(
        BuyerInquiry $inquiry,
        string $from,
        string $text,
        string $newStatus,
        ?int $senderUserId = null,
    ): InquiryMessage {
        return DB::transaction(function () use ($inquiry, $from, $text, $newStatus, $senderUserId): InquiryMessage {
            $message = InquiryMessage::query()->create([
                'buyer_inquiry_id' => $inquiry->id,
                'sender_type' => $from === 'seller' ? 'seller' : 'buyer',
                'sender_user_id' => $senderUserId,
                'body' => trim($text),
            ]);

            $inquiry->update([
                'status' => $newStatus,
                'time_label' => 'Just now',
            ]);

            event(new DomainStateChanged(
                domain: 'marketplace',
                action: 'buyer_inquiry.message_sent',
                tenantId: $inquiry->tenant_id,
            ));

            return $message;
        });
    }
}
