<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\CommunityPost;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Str;

/**
 * Callers must eager load `author`.
 *
 * @mixin CommunityPost
 */
final class FeedPostResource extends JsonResource
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
            'crew' => $this->author->crew,
            'time_ago' => $this->created_at?->diffForHumans(short: true),
            'vehicle_title' => $this->vehicle_title,
            'mod_title' => $this->mod_title,
            'workshop' => $this->workshop,
            'illustration' => $this->illustration,
            'watermark' => $this->watermark,
            'photo_url' => $this->photo_url,
            'tags' => $this->tags ?? [],
            'likes_count' => $this->likes_count,
            'comments_count' => $this->comments_count,
            'liked_by_me' => (bool) $this->resource->getAttribute('liked_by_me'),
        ];
    }
}
