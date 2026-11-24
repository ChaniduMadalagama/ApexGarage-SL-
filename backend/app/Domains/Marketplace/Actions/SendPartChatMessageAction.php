<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Marketplace\Models\InquiryMessage;
use App\Domains\Marketplace\Models\PartListing;
use App\Models\User;

final class SendPartChatMessageAction
{
    public function __construct(
        private readonly OpenPartInquiryAction $openInquiry,
        private readonly ReplyBuyerInquiryAction $reply,
    ) {}

    public function execute(User $buyer, PartListing $part, string $text): InquiryMessage
    {
        ['inquiry' => $inquiry, 'created' => $created] = $this->openInquiry->execute($buyer, $part, 'New Inquiry');

        return $this->reply->execute(
            inquiry: $inquiry,
            from: 'buyer',
            text: $text,
            newStatus: $created ? 'New Inquiry' : ($inquiry->status === 'Reserved (Pickup)' ? $inquiry->status : 'Offer Received'),
            senderUserId: $buyer->id,
        );
    }
}
