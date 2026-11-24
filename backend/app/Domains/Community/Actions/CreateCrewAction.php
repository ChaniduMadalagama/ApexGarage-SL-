<?php

declare(strict_types=1);

namespace App\Domains\Community\Actions;

use App\Domains\Community\Models\Crew;
use App\Domains\Tenancy\Support\TenantContext;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class CreateCrewAction
{
    public function execute(
        User $creator,
        string $name,
        string $focus,
        string $location,
        ?string $description = null,
    ): Crew {
        return DB::transaction(function () use ($creator, $name, $focus, $location, $description): Crew {
            $crew = Crew::query()->create([
                'tenant_id' => $creator->tenant_id ?? app(TenantContext::class)->getTenantId(),
                'name' => trim($name),
                'focus' => trim($focus),
                'location' => trim($location),
                'description' => $description !== null && trim($description) !== ''
                    ? trim($description)
                    : "Enthusiast crew focused on {$focus} in {$location}.",
                'members_count' => 1,
            ]);

            $crew->members()->syncWithoutDetaching([$creator->id]);

            return $crew;
        });
    }
}
