<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\MeetEvent;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class HostMeetAction
{
    public function execute(
        User $host,
        string $title,
        string $location,
        string $eventDate,
        ?string $description,
        ?float $latitude = null,
        ?float $longitude = null,
    ): MeetEvent {
        return DB::transaction(function () use ($host, $title, $location, $eventDate, $description, $latitude, $longitude): MeetEvent {
            // Deterministic pin placement derived from the venue name when coordinates are omitted.
            $hash = crc32(Str::lower($location));
            $top = 0.22 + (($hash % 60) / 100);
            $left = 0.18 + ((intdiv($hash, 60) % 60) / 100);

            $resolvedLat = $latitude ?? round(6.85 + (($hash % 30) / 100), 6);
            $resolvedLng = $longitude ?? round(79.82 + ((intdiv($hash, 30) % 30) / 100), 6);

            $meet = MeetEvent::query()->create([
                'tenant_id' => $host->tenant_id,
                'host_user_id' => $host->id,
                'pin_id' => 'pin-'.Str::lower(Str::random(8)),
                'title' => $title,
                'event_date' => $eventDate,
                'location' => $location,
                'host' => $host->crew ?? $host->name,
                'going_count' => 1,
                'pin_top_ratio' => round($top, 2),
                'pin_left_ratio' => round($left, 2),
                'pin_label' => Str::limit(Str::before($location, ','), 24, ''),
                'latitude' => $resolvedLat,
                'longitude' => $resolvedLng,
                'description' => $description,
                'status' => 'upcoming',
            ]);

            $meet->attendees()->attach($host->id);

            event(new DomainStateChanged(
                domain: 'community',
                action: 'meet.hosted',
                tenantId: $meet->tenant_id,
            ));

            return $meet;
        });
    }
}
