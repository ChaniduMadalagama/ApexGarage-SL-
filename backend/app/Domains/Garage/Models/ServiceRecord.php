<?php

declare(strict_types=1);

namespace App\Domains\Garage\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $id
 * @property int $vehicle_id
 * @property string $title
 * @property string $service_date
 * @property int $odometer_km
 * @property string $workshop
 * @property array<int, string>|null $parts_changed
 * @property int $cost_lkr
 * @property int $next_service_km
 * @property string $next_service_date
 * @property string|null $notes
 * @property string|null $receipt_label
 */
class ServiceRecord extends Model
{
    protected $fillable = [
        'vehicle_id',
        'title',
        'service_date',
        'odometer_km',
        'workshop',
        'parts_changed',
        'cost_lkr',
        'next_service_km',
        'next_service_date',
        'notes',
        'receipt_label',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'odometer_km' => 'integer',
            'parts_changed' => 'array',
            'cost_lkr' => 'integer',
            'next_service_km' => 'integer',
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
