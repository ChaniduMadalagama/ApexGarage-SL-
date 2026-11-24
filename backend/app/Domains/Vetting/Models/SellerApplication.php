<?php

declare(strict_types=1);

namespace App\Domains\Vetting\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int|null $user_id
 * @property string $business_name
 * @property string $owner_name
 * @property string $type
 * @property string $br_number
 * @property string $location
 * @property string $phone
 * @property string $submitted_time_label
 * @property string $status
 * @property int|null $reviewed_by
 * @property Carbon|null $reviewed_at
 * @property string|null $rejection_reason
 * @property array<int, string>|null $documents
 * @property string $specialty
 */
class SellerApplication extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'user_id',
        'business_name',
        'owner_name',
        'type',
        'br_number',
        'location',
        'phone',
        'submitted_time_label',
        'status',
        'reviewed_by',
        'reviewed_at',
        'rejection_reason',
        'documents',
        'specialty',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'documents' => 'array',
            'reviewed_at' => 'datetime',
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
     * @return BelongsTo<User, $this>
     */
    public function reviewer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reviewed_by');
    }
}
