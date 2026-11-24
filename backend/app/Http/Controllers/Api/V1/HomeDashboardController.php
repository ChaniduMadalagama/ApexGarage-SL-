<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Community\Models\CommunityPost;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Community\Models\Promotion;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Tenancy\Support\TenantContext;
use App\Http\Controllers\Controller;
use App\Http\Resources\FeedPostResource;
use App\Http\Resources\MeetResource;
use App\Http\Resources\PartResource;
use App\Http\Resources\PromotionResource;
use App\Http\Resources\SponsoredAdResource;
use App\Http\Resources\VehicleResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class HomeDashboardController extends Controller
{
    public function index(Request $request, TenantContext $tenantContext): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $activeVehicle = Vehicle::query()
            ->with(['buildLogs', 'serviceRecords'])
            ->where('user_id', $user->id)
            ->when(
                $user->active_vehicle_id !== null,
                fn ($q) => $q->orderByRaw('CASE WHEN id = ? THEN 0 ELSE 1 END', [$user->active_vehicle_id])
            )
            ->latest('id')
            ->first();

        $nextMeet = MeetEvent::query()
            ->withExists(['attendees as is_attending' => fn ($q) => $q->where('user_id', $user->id)])
            ->orderBy('id')
            ->first();

        $recommendedParts = PartListing::query()
            ->withExists(['savers as is_saved' => fn ($q) => $q->where('user_id', $user->id)])
            ->where('status', 'Approved')
            ->latest('views_count')
            ->limit(4)
            ->get();

        $tenantId = $tenantContext->getTenantId() ?? 0;
        /** @var Promotion|null $promotion */
        $promotion = Cache::remember(
            "apex:promo:active:{$tenantId}",
            (int) config('apex.cache_ttl.promotion', 300),
            fn (): ?Promotion => Promotion::query()
                ->where('is_active', true)
                ->latest('id')
                ->first()
        );

        $feedPosts = CommunityPost::query()
            ->with('author')
            ->withExists(['likers as is_liked' => fn ($q) => $q->where('user_id', $user->id)])
            ->latest('id')
            ->limit(10)
            ->get();

        $sponsoredAds = SponsoredAd::query()
            ->where('is_active', true)
            ->latest('id')
            ->limit(5)
            ->get();

        return response()->json([
            'active_vehicle' => $activeVehicle !== null ? new VehicleResource($activeVehicle) : null,
            'next_meet' => $nextMeet !== null ? new MeetResource($nextMeet) : null,
            'recommended_parts' => PartResource::collection($recommendedParts),
            'active_promotion' => $promotion !== null ? new PromotionResource($promotion) : null,
            'sponsored_ads' => SponsoredAdResource::collection($sponsoredAds),
            'feed_posts' => FeedPostResource::collection($feedPosts),
        ]);
    }
}
