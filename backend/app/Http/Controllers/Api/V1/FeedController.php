<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Community\Actions\AddFeedCommentAction;
use App\Domains\Community\Actions\SetPostLikeAction;
use App\Domains\Community\Models\CommunityPost;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreFeedCommentRequest;
use App\Http\Requests\Api\ToggleBoolRequest;
use App\Http\Resources\FeedCommentResource;
use App\Http\Resources\FeedPostResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FeedController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = auth('sanctum')->user();
        $userId = $user instanceof User ? $user->id : null;
        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $posts = CommunityPost::query()
            ->with('author')
            ->when($userId !== null, function ($q) use ($userId): void {
                $q->withExists(['likers as is_liked' => fn ($lq) => $lq->where('user_id', $userId)]);
            })
            ->latest('id')
            ->paginate($perPage);

        return response()->json([
            'feed_posts' => FeedPostResource::collection($posts->items()),
            'meta' => [
                'current_page' => $posts->currentPage(),
                'last_page' => $posts->lastPage(),
                'per_page' => $posts->perPage(),
                'total' => $posts->total(),
            ],
        ]);
    }

    public function like(
        ToggleBoolRequest $request,
        CommunityPost $post,
        SetPostLikeAction $likeAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        $liked = (bool) $request->validated('value');
        $likesCount = $likeAction->execute($user, $post, $liked);

        return response()->json([
            'post_id' => $post->id,
            'is_liked' => $liked,
            'likes_count' => $likesCount,
        ]);
    }

    public function commentsIndex(CommunityPost $post): JsonResponse
    {
        $comments = $post->comments()
            ->with('author')
            ->orderBy('id')
            ->limit(100)
            ->get();

        return response()->json([
            'comments' => FeedCommentResource::collection($comments),
            'comments_count' => $post->comments_count,
        ]);
    }

    public function commentsStore(
        StoreFeedCommentRequest $request,
        CommunityPost $post,
        AddFeedCommentAction $commentAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        $comment = $commentAction->execute($user, $post, (string) $request->validated('body'));

        return response()->json([
            'comment' => new FeedCommentResource($comment),
            'comments_count' => $post->fresh()->comments_count ?? ($post->comments_count + 1),
        ], 201);
    }
}
