<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\Crew;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin Crew
 */
final class CrewResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'members_count' => $this->members_count,
            'focus' => $this->focus,
            'description' => $this->description,
            'location' => $this->location,
            'joined_by_me' => (bool) $this->resource->getAttribute('joined_by_me'),
        ];
    }
}
