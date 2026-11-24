<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int|null $host_user_id
 * @property string $pin_id
 * @property string $title
 * @property string $event_date
 * @property string $location
 * @property string $host
 * @property int $going_count
 * @property float $pin_top_ratio
 * @property float $pin_left_ratio
 * @property string $pin_label
 * @property float|null $latitude
 * @property float|null $longitude
 * @property string|null $description
 * @property string $status
 */
class MeetEvent extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'host_user_id',
        'pin_id',
        'title',
        'event_date',
        'location',
        'host',
        'going_count',
        'pin_top_ratio',
        'pin_left_ratio',
        'pin_label',
        'latitude',
        'longitude',
        'description',
        'status',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'going_count' => 'integer',
            'pin_top_ratio' => 'float',
            'pin_left_ratio' => 'float',
            'latitude' => 'float',
            'longitude' => 'float',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function hostUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'host_user_id');
    }

    /**
     * @return BelongsToMany<User, $this>
     */
    public function attendees(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'meet_rsvps')->withTimestamps();
    }
}
