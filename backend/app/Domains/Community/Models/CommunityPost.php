<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property int $user_id
 * @property int|null $vehicle_id
 * @property string $vehicle_title
 * @property string $mod_title
 * @property string|null $workshop
 * @property string $illustration
 * @property string $watermark
 * @property string|null $photo_url
 * @property array<int, string>|null $tags
 * @property int $likes_count
 * @property int $comments_count
 * @property Carbon|null $created_at
 */
class CommunityPost extends Model
{
    use BelongsToTenant;

    protected $fillable = [
        'tenant_id',
        'user_id',
        'vehicle_id',
        'vehicle_title',
        'mod_title',
        'workshop',
        'illustration',
        'watermark',
        'photo_url',
        'tags',
        'likes_count',
        'comments_count',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'tags' => 'array',
            'likes_count' => 'integer',
            'comments_count' => 'integer',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * @return BelongsToMany<User, $this>
     */
    public function likers(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'community_post_likes')->withTimestamps();
    }

    /**
     * @return HasMany<CommunityPostComment, $this>
     */
    public function comments(): HasMany
    {
        return $this->hasMany(CommunityPostComment::class, 'community_post_id');
    }
}
