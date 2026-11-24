<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\MeetEvent;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin MeetEvent
 */
final class MeetResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'pin_id' => $this->pin_id,
            'title' => $this->title,
            'date' => $this->event_date,
            'location' => $this->location,
            'host' => $this->host,
            'going_count' => $this->going_count,
            'pin_top_ratio' => $this->pin_top_ratio,
            'pin_left_ratio' => $this->pin_left_ratio,
            'pin_label' => $this->pin_label,
            'latitude' => (float) ($this->latitude ?? 6.9271),
            'longitude' => (float) ($this->longitude ?? 79.8612),
            'description' => $this->description,
            'rsvp_by_me' => (bool) $this->resource->getAttribute('rsvp_by_me'),
        ];
    }
}
