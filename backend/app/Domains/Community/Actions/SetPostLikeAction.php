<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\CommunityPost;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class SetPostLikeAction
{
    public function execute(User $user, CommunityPost $post, bool $liked): int
    {
        return DB::transaction(function () use ($user, $post, $liked): int {
            if ($liked) {
                $changes = $post->likers()->syncWithoutDetaching([$user->id]);
                if ($changes['attached'] !== []) {
                    CommunityPost::query()->whereKey($post->id)->increment('likes_count');
                }
            } elseif ($post->likers()->detach($user->id) > 0) {
                CommunityPost::query()->whereKey($post->id)->where('likes_count', '>', 0)->decrement('likes_count');
            }

            return (int) CommunityPost::query()->whereKey($post->id)->value('likes_count');
        });
    }
}
