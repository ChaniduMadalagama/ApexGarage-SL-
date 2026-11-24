<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property string $name
 * @property string $focus
 * @property string $description
 * @property string $location
 * @property int $members_count
 */
class Crew extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'name',
        'focus',
        'description',
        'location',
        'members_count',
    ];

    /**
     * @return BelongsToMany<User, $this>
     */
    public function members(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'crew_members')->withTimestamps();
    }
}
