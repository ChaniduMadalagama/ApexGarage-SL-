<?php

declare(strict_types=1);

namespace App\Domains\Marketplace\Actions;

use App\Domains\Marketplace\Models\PartListing;
use App\Models\User;

final class SetPartSavedAction
{
    /**
     * Idempotent: repeated calls with the same state are no-ops.
     */
    public function execute(User $user, PartListing $part, bool $saved): bool
    {
        if ($saved) {
            $user->savedParts()->syncWithoutDetaching([$part->id]);
        } else {
            $user->savedParts()->detach($part->id);
        }

        return $saved;
    }
}
