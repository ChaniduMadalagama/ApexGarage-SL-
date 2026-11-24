<?php

declare(strict_types=1);

namespace App\Domains\Garage\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $id
 * @property int $vehicle_id
 * @property string $log_date
 * @property string $category
 * @property string $title
 * @property string $brand
 * @property int $cost_lkr
 * @property string $mechanic
 * @property string|null $notes
 * @property string|null $photo_label
 * @property string|null $photo_url
 */
class BuildLog extends Model
{
    protected $fillable = [
        'vehicle_id',
        'log_date',
        'category',
        'title',
        'brand',
        'cost_lkr',
        'mechanic',
        'notes',
        'photo_label',
        'photo_url',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'cost_lkr' => 'integer',
        ];
    }

    /**
     * @return BelongsTo<Vehicle, $this>
     */
    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }
}
