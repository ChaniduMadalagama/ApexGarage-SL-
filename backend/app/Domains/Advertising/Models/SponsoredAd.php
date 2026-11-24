<?php

declare(strict_types=1);

namespace App\Domains\Advertising\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property string $sponsor
 * @property string $headline
 * @property string $placement
 * @property string $impressions
 * @property string $clicks
 * @property string $ctr
 * @property int $revenue_lkr
 * @property bool $is_active
 */
class SponsoredAd extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'sponsor',
        'headline',
        'placement',
        'impressions',
        'clicks',
        'ctr',
        'revenue_lkr',
        'is_active',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'revenue_lkr' => 'integer',
            'is_active' => 'boolean',
        ];
    }
}
