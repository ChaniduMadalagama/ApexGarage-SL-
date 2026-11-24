<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Community\Actions\HostMeetAction;
use App\Domains\Community\Actions\SetMeetRsvpAction;
use App\Domains\Community\Models\MeetEvent;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreMeetRequest;
use App\Http\Requests\Api\ToggleBoolRequest;
use App\Http\Resources\MeetResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MeetController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = auth('sanctum')->user();
        $userId = $user instanceof User ? $user->id : null;
        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $meets = MeetEvent::query()
            ->when($userId !== null, function ($q) use ($userId): void {
                $q->withExists(['attendees as is_attending' => fn ($rq) => $rq->where('user_id', $userId)]);
            })
            ->orderBy('id')
            ->paginate($perPage);

        return response()->json([
            'meets' => MeetResource::collection($meets->items()),
            'meta' => [
                'current_page' => $meets->currentPage(),
                'last_page' => $meets->lastPage(),
                'per_page' => $meets->perPage(),
                'total' => $meets->total(),
            ],
        ]);
    }

    public function store(StoreMeetRequest $request, HostMeetAction $hostMeetAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var array{title: string, location: string, event_date: string, description?: string|null, latitude?: float|int|string|null, longitude?: float|int|string|null} $v */
        $v = $request->validated();

        $meet = $hostMeetAction->execute(
            host: $user,
            title: $v['title'],
            location: $v['location'],
            eventDate: $v['event_date'],
            description: $v['description'] ?? null,
            latitude: isset($v['latitude']) ? (float) $v['latitude'] : null,
            longitude: isset($v['longitude']) ? (float) $v['longitude'] : null,
        );

        $meet->setAttribute('is_attending', true);

        return response()->json([
            'meet' => new MeetResource($meet),
        ], 201);
    }

    public function rsvp(ToggleBoolRequest $request, MeetEvent $meet, SetMeetRsvpAction $rsvpAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $attending = (bool) $request->validated('value');
        $goingCount = $rsvpAction->execute($user, $meet, $attending);

        return response()->json([
            'meet_id' => $meet->id,
            'is_attending' => $attending,
            'going_count' => $goingCount,
        ]);
    }
}
