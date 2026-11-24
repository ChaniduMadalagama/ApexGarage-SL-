<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\CommunityPostComment;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Str;

/**
 * Callers must eager load `author`.
 *
 * @mixin CommunityPostComment
 */
final class FeedCommentResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'author' => $this->author->name,
            'handle' => $this->author->handle,
            'avatar' => Str::upper(Str::substr($this->author->name, 0, 2)),
            'body' => $this->body,
            'time_ago' => $this->created_at?->diffForHumans(short: true) ?? 'Now',
        ];
    }
}
