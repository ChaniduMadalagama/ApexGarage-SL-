<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\CommunityPost;
use App\Domains\Community\Models\CommunityPostComment;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class AddFeedCommentAction
{
    public function execute(User $user, CommunityPost $post, string $body): CommunityPostComment
    {
        return DB::transaction(function () use ($user, $post, $body): CommunityPostComment {
            $comment = CommunityPostComment::query()->create([
                'community_post_id' => $post->id,
                'user_id' => $user->id,
                'body' => trim($body),
            ]);

            $post->increment('comments_count');

            event(new DomainStateChanged(
                domain: 'community',
                action: 'feed_post.commented',
                tenantId: $post->tenant_id,
            ));

            return $comment->load('author');
        });
    }
}
