<?php

declare(strict_types=1);

namespace App\Domains\Garage\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Database\Factories\VehicleFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int $user_id
 * @property string $category
 * @property string $brand
 * @property string $title
 * @property string $subtitle
 * @property string $watermark
 * @property string $illustration
 * @property string $stage_badge
 * @property string $status
 * @property string $status_tone
 * @property string $year
 * @property string $chassis
 * @property string $engine_code
 * @property string $engine
 * @property int $current_mileage
 * @property int $next_service_mileage
 * @property string $power_value
 * @property string $power_unit
 * @property string $torque_value
 * @property int $estimated_value_lkr
 * @property array<int, array<string, mixed>>|null $specs
 */
class Vehicle extends Model
{
    use BelongsToTenant;

    /** @use HasFactory<VehicleFactory> */
    use HasFactory;

    protected $fillable = [
        'tenant_id',
        'user_id',
        'category',
        'brand',
        'title',
        'subtitle',
        'watermark',
        'illustration',
        'photo_url',
        'stage_badge',
        'status',
        'status_tone',
        'year',
        'chassis',
        'engine_code',
        'engine',
        'current_mileage',
        'next_service_mileage',
        'power_value',
        'power_unit',
        'torque_value',
        'estimated_value_lkr',
        'specs',
    ];

    protected static function newFactory(): VehicleFactory
    {
        return VehicleFactory::new();
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'current_mileage' => 'integer',
            'next_service_mileage' => 'integer',
            'estimated_value_lkr' => 'integer',
            'specs' => 'array',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * @return HasMany<BuildLog, $this>
     */
    public function buildLogs(): HasMany
    {
        return $this->hasMany(BuildLog::class);
    }

    /**
     * @return HasMany<ServiceRecord, $this>
     */
    public function serviceRecords(): HasMany
    {
        return $this->hasMany(ServiceRecord::class);
    }

    /**
     * @return HasOne<ServiceRecord, $this>
     */
    public function latestServiceRecord(): HasOne
    {
        return $this->hasOne(ServiceRecord::class)->latestOfMany();
    }
}
