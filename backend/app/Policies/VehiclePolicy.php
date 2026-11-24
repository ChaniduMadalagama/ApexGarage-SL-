<?php

declare(strict_types=1);

namespace App\Policies;

use App\Domains\Garage\Models\Vehicle;
use App\Models\User;

final class VehiclePolicy
{
    public function view(User $user, Vehicle $vehicle): bool
    {
        return $vehicle->user_id === $user->id;
    }

    public function update(User $user, Vehicle $vehicle): bool
    {
        return $vehicle->user_id === $user->id;
    }
}
