<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Workshops\Actions\BookWorkshopSlotAction;
use App\Domains\Workshops\Models\Workshop;
use App\Domains\Workshops\Services\WorkshopSlotService;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\BookWorkshopRequest;
use App\Http\Resources\BookingResource;
use App\Http\Resources\MechanicResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MechanicController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $query = Workshop::query()->orderByDesc('is_verified')->orderBy('id');

        $search = trim((string) $request->query('q', ''));
        if ($search !== '') {
            $like = '%'.addcslashes($search, '%_\\').'%';
            $query->where(function ($q) use ($like): void {
                $q->where('name', 'like', $like)
                    ->orWhere('location', 'like', $like)
                    ->orWhere('specialty', 'like', $like);
            });
        }

        $workshops = $query->paginate($perPage);

        return response()->json([
            'mechanics' => MechanicResource::collection($workshops->items()),
            'meta' => [
                'current_page' => $workshops->currentPage(),
                'last_page' => $workshops->lastPage(),
                'per_page' => $workshops->perPage(),
                'total' => $workshops->total(),
            ],
        ]);
    }

    public function slots(Workshop $workshop, WorkshopSlotService $slotService): JsonResponse
    {
        return response()->json([
            'workshop_id' => $workshop->id,
            'services' => $slotService->services(),
            'slots' => $slotService->slotsFor($workshop),
        ]);
    }

    public function book(
        BookWorkshopRequest $request,
        Workshop $workshop,
        BookWorkshopSlotAction $bookAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var array{service_key: string, slot: string, vehicle_id?: int|null} $validated */
        $validated = $request->validated();

        $booking = $bookAction->execute(
            user: $user,
            workshop: $workshop,
            serviceKey: $validated['service_key'],
            slot: $validated['slot'],
            vehicleId: isset($validated['vehicle_id']) ? (int) $validated['vehicle_id'] : null,
        );

        $booking->load('workshop');

        return response()->json([
            'booking' => new BookingResource($booking),
        ], 201);
    }
}
