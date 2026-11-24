<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Domains\Garage\Models\Vehicle;
use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int $user_id
 * @property int|null $vehicle_id
 * @property bool $is_riding
 * @property float $latitude
 * @property float $longitude
 * @property string|null $status_note
 * @property Carbon $last_seen_at
 * @property-read User $user
 * @property-read Vehicle|null $vehicle
 */
class CrewLivePresence extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'user_id',
        'vehicle_id',
        'is_riding',
        'latitude',
        'longitude',
        'status_note',
        'last_seen_at',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'is_riding' => 'boolean',
            'latitude' => 'float',
            'longitude' => 'float',
            'last_seen_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * @return BelongsTo<Vehicle, $this>
     */
    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id');
    }
}
