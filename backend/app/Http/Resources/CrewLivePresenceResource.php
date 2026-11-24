<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domains\Community\Models\CrewLivePresence;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Str;

/**
 * Callers must eager load `user` and `vehicle`.
 *
 * @mixin CrewLivePresence
 */
final class CrewLivePresenceResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $vehicle = $this->relationLoaded('vehicle') ? $this->vehicle : null;

        return [
            'user_id' => $this->user_id,
            'name' => $this->user->name,
            'handle' => $this->user->handle,
            'avatar' => Str::upper(Str::substr($this->user->name, 0, 2)),
            'crew_name' => $this->user->crew ?? 'ApexGarage SL',
            'is_riding' => $this->is_riding,
            'is_me' => $request->user('sanctum')?->getAuthIdentifier() === $this->user_id,
            'vehicle_id' => $this->vehicle_id,
            'vehicle_title' => $vehicle->title ?? 'Enthusiast Build',
            'vehicle_category' => $vehicle->category ?? 'Car',
            'vehicle_brand' => $vehicle->brand ?? 'JDM',
            'stage_badge' => $vehicle->stage_badge ?? 'Online',
            'latitude' => (float) $this->latitude,
            'longitude' => (float) $this->longitude,
            'status_note' => $this->status_note,
            'last_seen_ago' => $this->last_seen_at->diffForHumans(short: true),
        ];
    }
}
