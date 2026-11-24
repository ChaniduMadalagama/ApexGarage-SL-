<?php

declare(strict_types=1);

namespace App\Domains\Workshops\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property string $name
 * @property string $location
 * @property string $specialty
 * @property string $rating
 * @property int $reviews_count
 * @property string $base_price
 * @property array<int, string>|null $tags
 * @property string $availability
 * @property bool $is_verified
 */
class Workshop extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'owner_user_id',
        'name',
        'location',
        'specialty',
        'rating',
        'reviews_count',
        'base_price',
        'tags',
        'availability',
        'is_verified',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'reviews_count' => 'integer',
            'tags' => 'array',
            'is_verified' => 'boolean',
        ];
    }
}
