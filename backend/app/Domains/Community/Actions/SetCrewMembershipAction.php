<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\Crew;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class SetCrewMembershipAction
{
    public function execute(User $user, Crew $crew, bool $joined): int
    {
        return DB::transaction(function () use ($user, $crew, $joined): int {
            if ($joined) {
                $changes = $crew->members()->syncWithoutDetaching([$user->id]);
                if ($changes['attached'] !== []) {
                    Crew::query()->whereKey($crew->id)->increment('members_count');
                }
            } elseif ($crew->members()->detach($user->id) > 0) {
                Crew::query()->whereKey($crew->id)->where('members_count', '>', 0)->decrement('members_count');
            }

            return (int) Crew::query()->whereKey($crew->id)->value('members_count');
        });
    }
}
