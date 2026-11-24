<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int $buyer_inquiry_id
 * @property string $sender_type
 * @property int|null $sender_user_id
 * @property string $body
 * @property Carbon|null $created_at
 */
class InquiryMessage extends Model
{
    protected $fillable = [
        'buyer_inquiry_id',
        'sender_type',
        'sender_user_id',
        'body',
    ];

    /**
     * @return BelongsTo<BuyerInquiry, $this>
     */
    public function inquiry(): BelongsTo
    {
        return $this->belongsTo(BuyerInquiry::class, 'buyer_inquiry_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function sender(): BelongsTo
    {
        return $this->belongsTo(User::class, 'sender_user_id');
    }
}
