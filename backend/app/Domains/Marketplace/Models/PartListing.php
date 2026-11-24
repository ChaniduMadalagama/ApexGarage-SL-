<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int $user_id
 * @property string|null $seller_id
 * @property string|null $sku
 * @property string $brand
 * @property string $title
 * @property string $subtitle
 * @property string|null $fitment
 * @property string $watermark
 * @property string $illustration
 * @property int $price_lkr
 * @property int $stock
 * @property string $condition
 * @property array<int, string>|null $trust_badges
 * @property string $seller_name
 * @property string $location
 * @property string $rating
 * @property bool $is_verified
 * @property array<int, array<string, mixed>>|null $specs
 * @property string $description
 * @property string $status
 * @property int $views_count
 * @property int $inquiries_count
 */
class PartListing extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'user_id',
        'seller_id',
        'sku',
        'brand',
        'title',
        'subtitle',
        'fitment',
        'watermark',
        'illustration',
        'photo_url',
        'price_lkr',
        'stock',
        'condition',
        'trust_badges',
        'seller_name',
        'location',
        'rating',
        'is_verified',
        'specs',
        'description',
        'status',
        'views_count',
        'inquiries_count',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'price_lkr' => 'integer',
            'stock' => 'integer',
            'views_count' => 'integer',
            'inquiries_count' => 'integer',
            'trust_badges' => 'array',
            'is_verified' => 'boolean',
            'specs' => 'array',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function seller(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * @return BelongsToMany<User, $this>
     */
    public function savers(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'saved_parts')->withTimestamps();
    }
}
