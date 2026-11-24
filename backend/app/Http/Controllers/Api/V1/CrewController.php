<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Community\Actions\CreateCrewAction;
use App\Domains\Community\Actions\SetCrewMembershipAction;
use App\Domains\Community\Actions\UpdateCrewLivePresenceAction;
use App\Domains\Community\Models\Crew;
use App\Domains\Community\Models\CrewLivePresence;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreCrewRequest;
use App\Http\Requests\Api\ToggleBoolRequest;
use App\Http\Requests\Api\UpdateCrewLiveRequest;
use App\Http\Resources\CrewLivePresenceResource;
use App\Http\Resources\CrewResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CrewController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = auth('sanctum')->user();
        $userId = $user instanceof User ? $user->id : null;
        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $crews = Crew::query()
            ->when($userId !== null, function ($q) use ($userId): void {
                $q->withExists(['members as joined_by_me' => fn ($mq) => $mq->where('user_id', $userId)]);
            })
            ->orderBy('id')
            ->paginate($perPage);

        return response()->json([
            'crews' => CrewResource::collection($crews->items()),
            'meta' => [
                'current_page' => $crews->currentPage(),
                'last_page' => $crews->lastPage(),
                'per_page' => $crews->perPage(),
                'total' => $crews->total(),
            ],
        ]);
    }

    public function membership(
        ToggleBoolRequest $request,
        Crew $crew,
        SetCrewMembershipAction $membershipAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        $joined = (bool) $request->validated('value');
        $membersCount = $membershipAction->execute($user, $crew, $joined);

        return response()->json([
            'crew_id' => $crew->id,
            'is_joined' => $joined,
            'members_count' => $membersCount,
        ]);
    }

    public function store(StoreCrewRequest $request, CreateCrewAction $createCrewAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var array{name: string, focus: string, location: string, description?: string|null} $v */
        $v = $request->validated();

        $crew = $createCrewAction->execute(
            creator: $user,
            name: $v['name'],
            focus: $v['focus'],
            location: $v['location'],
            description: $v['description'] ?? null,
        );

        $crew->setAttribute('joined_by_me', true);

        return response()->json([
            'crew' => new CrewResource($crew),
        ], 201);
    }

    public function liveIndex(Request $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $crewIds = DB::table('crew_members')
            ->where('user_id', $user->id)
            ->pluck('crew_id');

        $crewMemberIds = $crewIds->isEmpty()
            ? collect([$user->id])
            : DB::table('crew_members')
                ->whereIn('crew_id', $crewIds)
                ->pluck('user_id')
                ->push($user->id)
                ->unique()
                ->values();

        $presences = CrewLivePresence::query()
            ->with(['user', 'vehicle'])
            ->whereIn('user_id', $crewMemberIds)
            ->where('is_riding', true)
            ->where('last_seen_at', '>=', now()->subHours(12))
            ->latest('last_seen_at')
            ->get();

        return response()->json([
            'riders' => CrewLivePresenceResource::collection($presences),
        ]);
    }

    public function liveUpdate(
        UpdateCrewLiveRequest $request,
        UpdateCrewLivePresenceAction $presenceAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        $v = $request->validated();

        $presence = $presenceAction->execute(
            user: $user,
            isRiding: (bool) $v['is_riding'],
            latitude: (float) $v['latitude'],
            longitude: (float) $v['longitude'],
            vehicleId: isset($v['vehicle_id']) ? (int) $v['vehicle_id'] : null,
            statusNote: isset($v['status_note']) ? (string) $v['status_note'] : null,
        );

        return response()->json([
            'rider' => new CrewLivePresenceResource($presence),
        ]);
    }
}
