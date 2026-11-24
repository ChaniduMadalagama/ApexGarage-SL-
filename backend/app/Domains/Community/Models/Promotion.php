<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property string $partner
 * @property string $code
 * @property string $title
 * @property string $description
 * @property array<int, string>|null $participating_workshops
 * @property bool $is_active
 * @property Carbon|null $starts_at
 * @property Carbon|null $ends_at
 */
class Promotion extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'partner',
        'code',
        'title',
        'description',
        'participating_workshops',
        'is_active',
        'starts_at',
        'ends_at',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'participating_workshops' => 'array',
            'is_active' => 'boolean',
            'starts_at' => 'datetime',
            'ends_at' => 'datetime',
        ];
    }
}
