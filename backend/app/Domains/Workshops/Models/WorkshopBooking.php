<?php

declare(strict_types=1);

namespace App\Domains\Workshops\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int|null $seller_user_id
 * @property string $customer_name
 * @property string $vehicle
 * @property string $service
 * @property string $slot_date
 * @property int $estimate_lkr
 * @property string $status
 */
class WorkshopBooking extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'seller_user_id',
        'workshop_id',
        'user_id',
        'booking_ref',
        'customer_name',
        'vehicle',
        'service',
        'slot_date',
        'estimate_lkr',
        'status',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'estimate_lkr' => 'integer',
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
     * @return BelongsTo<Workshop, $this>
     */
    public function workshop(): BelongsTo
    {
        return $this->belongsTo(Workshop::class);
    }
}
