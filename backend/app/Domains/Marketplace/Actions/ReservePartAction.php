<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Models\User;

final class ReservePartAction
{
    public function __construct(
        private readonly OpenPartInquiryAction $openInquiry,
        private readonly ReplyBuyerInquiryAction $reply,
    ) {}

    public function execute(User $buyer, PartListing $part, ?string $message): BuyerInquiry
    {
        ['inquiry' => $inquiry] = $this->openInquiry->execute($buyer, $part, 'Reserved (Pickup)');

        $body = $message !== null && trim($message) !== ''
            ? trim($message)
            : "Reservation request: I would like to reserve \"{$part->title}\" for pickup.";

        $this->reply->execute($inquiry, 'buyer', $body, 'Reserved (Pickup)', $buyer->id);

        return $inquiry->fresh() ?? $inquiry;
    }
}
