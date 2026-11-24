<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\MeetEvent;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class SetMeetRsvpAction
{
    /**
     * Idempotent and race-safe: the pivot has a UNIQUE(meet_event_id, user_id)
     * index and the counter only moves when the pivot row really changes.
     */
    public function execute(User $user, MeetEvent $meet, bool $attending): int
    {
        return DB::transaction(function () use ($user, $meet, $attending): int {
            if ($attending) {
                $changes = $meet->attendees()->syncWithoutDetaching([$user->id]);
                if ($changes['attached'] !== []) {
                    MeetEvent::query()->whereKey($meet->id)->increment('going_count');
                }
            } elseif ($meet->attendees()->detach($user->id) > 0) {
                MeetEvent::query()->whereKey($meet->id)->where('going_count', '>', 0)->decrement('going_count');
            }

            return (int) MeetEvent::query()->whereKey($meet->id)->value('going_count');
        });
    }
}
