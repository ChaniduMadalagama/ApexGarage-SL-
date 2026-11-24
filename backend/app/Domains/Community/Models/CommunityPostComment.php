<?php

declare(strict_types=1);

namespace App\Domains\Community\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property int $community_post_id
 * @property int $user_id
 * @property string $body
 * @property Carbon|null $created_at
 * @property-read CommunityPost $post
 * @property-read User $author
 */
class CommunityPostComment extends Model
{
    protected $fillable = [
        'community_post_id',
        'user_id',
        'body',
    ];

    /**
     * @return BelongsTo<CommunityPost, $this>
     */
    public function post(): BelongsTo
    {
        return $this->belongsTo(CommunityPost::class, 'community_post_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
