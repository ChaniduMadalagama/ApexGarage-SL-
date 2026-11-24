<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Garage\Models\Vehicle;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\SetActiveVehicleRequest;
use App\Http\Requests\Api\UpdateOnboardingRequest;
use App\Http\Resources\BookingResource;
use App\Http\Resources\PartResource;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

class UserController extends Controller
{
    public function profile(Request $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $user->load([
            'roles',
            'savedParts',
            'workshopBookings.workshop',
        ]);

        return response()->json([
            'user' => new UserResource($user),
            'saved_parts' => PartResource::collection($user->savedParts),
            'bookings' => BookingResource::collection($user->workshopBookings),
            'stats' => [
                'vehicles_count' => $user->vehicles()->count(),
                'saved_parts_count' => $user->savedParts->count(),
                'bookings_count' => $user->workshopBookings->count(),
                'crews_count' => $user->crews()->count(),
            ],
        ]);
    }

    public function updateOnboarding(UpdateOnboardingRequest $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var array{cultures: list<string>, onboarding_completed?: bool} $validated */
        $validated = $request->validated();

        $user->update([
            'cultures' => $validated['cultures'],
            'onboarding_completed' => $validated['onboarding_completed'] ?? true,
        ]);

        return response()->json([
            'user' => new UserResource($user->fresh('roles') ?? $user),
        ]);
    }

    public function setActiveVehicle(SetActiveVehicleRequest $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var int $vehicleId */
        $vehicleId = $request->validated('vehicle_id');
        $vehicle = Vehicle::query()->findOrFail($vehicleId);

        Gate::authorize('update', $vehicle);

        $user->update([
            'active_vehicle_id' => $vehicle->id,
        ]);

        return response()->json([
            'user' => new UserResource($user->fresh('roles') ?? $user),
            'active_vehicle_id' => $vehicle->id,
        ]);
    }
}
