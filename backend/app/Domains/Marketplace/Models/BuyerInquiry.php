<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int|null $seller_user_id
 * @property int|null $buyer_user_id
 * @property int|null $part_listing_id
 * @property string $seller_id
 * @property string $buyer_name
 * @property string $vehicle
 * @property string $part_title
 * @property int $offer_lkr
 * @property string $status
 * @property string $time_label
 */
class BuyerInquiry extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'seller_user_id',
        'buyer_user_id',
        'part_listing_id',
        'seller_id',
        'buyer_name',
        'vehicle',
        'part_title',
        'offer_lkr',
        'status',
        'time_label',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'offer_lkr' => 'integer',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function seller(): BelongsTo
    {
        return $this->belongsTo(User::class, 'seller_user_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function buyer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'buyer_user_id');
    }

    /**
     * @return BelongsTo<PartListing, $this>
     */
    public function part(): BelongsTo
    {
        return $this->belongsTo(PartListing::class, 'part_listing_id');
    }

    /**
     * @return HasMany<InquiryMessage, $this>
     */
    public function messages(): HasMany
    {
        return $this->hasMany(InquiryMessage::class)->orderBy('id');
    }

    /**
     * @return HasOne<InquiryMessage, $this>
     */
    public function latestMessage(): HasOne
    {
        return $this->hasOne(InquiryMessage::class)->latestOfMany();
    }
}
