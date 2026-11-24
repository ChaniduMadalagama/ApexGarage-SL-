<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Marketplace\Actions\OpenPartInquiryAction;
use App\Domains\Marketplace\Actions\PublishPartListingAction;
use App\Domains\Marketplace\Actions\ReservePartAction;
use App\Domains\Marketplace\Actions\SendPartChatMessageAction;
use App\Domains\Marketplace\Actions\SetPartSavedAction;
use App\Domains\Marketplace\DTOs\CreatePartListingData;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Tenancy\Support\TenantContext;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ReservePartRequest;
use App\Http\Requests\Api\SendChatMessageRequest;
use App\Http\Requests\Api\StorePartListingRequest;
use App\Http\Requests\Api\ToggleBoolRequest;
use App\Http\Resources\ChatMessageResource;
use App\Http\Resources\PartResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;

class MarketplaceController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = auth('sanctum')->user();
        $userId = $user instanceof User ? $user->id : null;
        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $query = PartListing::query()
            ->where('status', 'Approved')
            ->when($userId !== null, function ($q) use ($userId): void {
                $q->withExists(['savers as is_saved' => fn ($sq) => $sq->where('user_id', $userId)]);
            });

        $search = trim((string) $request->query('q', ''));
        if ($search !== '') {
            $like = '%'.addcslashes($search, '%_\\').'%';
            $query->where(function ($q) use ($like): void {
                $q->where('title', 'like', $like)
                    ->orWhere('brand', 'like', $like)
                    ->orWhere('subtitle', 'like', $like)
                    ->orWhere('fitment', 'like', $like)
                    ->orWhere('location', 'like', $like);
            });
        }

        $brand = trim((string) $request->query('brand', ''));
        if ($brand !== '' && strcasecmp($brand, 'All') !== 0) {
            $query->where('brand', $brand);
        }

        $condition = trim((string) $request->query('condition', ''));
        if ($condition !== '' && strcasecmp($condition, 'All') !== 0) {
            $query->where('condition', $condition);
        }

        if ($request->filled('min_price')) {
            $query->where('price_lkr', '>=', max(0, (int) $request->query('min_price')));
        }

        if ($request->filled('max_price')) {
            $query->where('price_lkr', '<=', max(0, (int) $request->query('max_price')));
        }

        if ($request->boolean('saved') && $user instanceof User) {
            $query->whereHas('savers', fn ($sq) => $sq->where('user_id', $user->id));
        }

        match ($request->query('sort', 'newest')) {
            'price_asc' => $query->orderBy('price_lkr', 'asc'),
            'price_desc' => $query->orderBy('price_lkr', 'desc'),
            'popular' => $query->orderBy('views_count', 'desc'),
            default => $query->latest('id'),
        };

        $parts = $query->paginate($perPage);

        return response()->json([
            'parts' => PartResource::collection($parts->items()),
            'meta' => [
                'current_page' => $parts->currentPage(),
                'last_page' => $parts->lastPage(),
                'per_page' => $parts->perPage(),
                'total' => $parts->total(),
            ],
        ]);
    }

    public function histogram(TenantContext $tenantContext): JsonResponse
    {
        $tenantId = $tenantContext->getTenantId() ?? 0;

        /** @var array{buckets: list<array{label: string, min: int, max: int|null, count: int}>, max_price: int} $data */
        $data = Cache::remember(
            "apex:parts:histogram:{$tenantId}",
            (int) config('apex.cache_ttl.histogram', 120),
            function (): array {
                $prices = PartListing::query()
                    ->where('status', 'Approved')
                    ->pluck('price_lkr')
                    ->map(fn ($p): int => (int) $p)
                    ->all();

                $ranges = [
                    ['label' => '< 50k', 'min' => 0, 'max' => 49999],
                    ['label' => '50k-150k', 'min' => 50000, 'max' => 149999],
                    ['label' => '150k-300k', 'min' => 150000, 'max' => 299999],
                    ['label' => '300k-500k', 'min' => 300000, 'max' => 499999],
                    ['label' => '500k+', 'min' => 500000, 'max' => null],
                ];

                $buckets = [];
                foreach ($ranges as $range) {
                    $count = 0;
                    foreach ($prices as $price) {
                        if ($price >= $range['min'] && ($range['max'] === null || $price <= $range['max'])) {
                            $count++;
                        }
                    }
                    $buckets[] = [
                        'label' => $range['label'],
                        'min' => $range['min'],
                        'max' => $range['max'],
                        'count' => $count,
                    ];
                }

                return [
                    'buckets' => $buckets,
                    'max_price' => $prices === [] ? 500000 : max($prices),
                ];
            }
        );

        return response()->json($data);
    }

    public function show(PartListing $part): JsonResponse
    {
        $user = auth('sanctum')->user();
        abort_if(
            $part->status !== 'Approved' && (! ($user instanceof User) || $part->user_id !== $user->id),
            404
        );

        if ($user instanceof User) {
            $part->loadExists(['savers as is_saved' => fn ($sq) => $sq->where('user_id', $user->id)]);
        }

        return response()->json([
            'part' => new PartResource($part),
        ]);
    }

    public function store(
        StorePartListingRequest $request,
        PublishPartListingAction $createPartAction,
        TenantContext $tenantContext,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var array<string, mixed> $validated */
        $validated = $request->validated();

        /** @var array<int, string> $trustBadges */
        $trustBadges = is_array($validated['trust_badges'] ?? null)
            ? array_values($validated['trust_badges'])
            : ['Verified Seller', 'Islandwide Delivery'];

        /** @var array<int, array<string, mixed>> $specs */
        $specs = is_array($validated['specs'] ?? null) ? array_values($validated['specs']) : [];

        $part = $createPartAction->execute(new CreatePartListingData(
            userId: (int) $user->id,
            tenantId: $tenantContext->getTenantId(),
            brand: (string) $validated['brand'],
            title: (string) $validated['title'],
            subtitle: (string) $validated['subtitle'],
            watermark: (string) $validated['watermark'],
            illustration: (string) $validated['illustration'],
            priceLkr: (int) $validated['price_lkr'],
            condition: (string) $validated['condition'],
            trustBadges: $trustBadges,
            sellerName: $user->name,
            location: (string) $validated['location'],
            rating: '5.0',
            isVerified: false,
            specs: $specs,
            description: (string) $validated['description'],
            status: 'Pending Review',
            sku: isset($validated['sku']) ? (string) $validated['sku'] : 'AG-'.strtoupper(Str::random(6)),
            fitment: isset($validated['fitment']) ? (string) $validated['fitment'] : (string) $validated['subtitle'],
            stock: isset($validated['stock']) ? (int) $validated['stock'] : 1,
            sellerId: "seller_{$user->id}",
            photoUrl: isset($validated['photo_url']) ? (string) $validated['photo_url'] : null,
        ));

        return response()->json([
            'part' => new PartResource($part),
        ], 201);
    }

    public function save(ToggleBoolRequest $request, PartListing $part, SetPartSavedAction $setSavedAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $saved = $setSavedAction->execute($user, $part, (bool) $request->validated('value'));

        return response()->json([
            'part_id' => $part->id,
            'is_saved' => $saved,
        ]);
    }

    public function reserve(ReservePartRequest $request, PartListing $part, ReservePartAction $reserveAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var string|null $message */
        $message = $request->validated('message');
        $inquiry = $reserveAction->execute($user, $part, $message);

        return response()->json([
            'inquiry_id' => $inquiry->id,
            'status' => $inquiry->status,
            'part_id' => $part->id,
        ], 201);
    }

    public function chatIndex(Request $request, PartListing $part, OpenPartInquiryAction $openInquiryAction): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $result = $openInquiryAction->execute($user, $part, 'New Inquiry');
        $messages = $result['inquiry']->messages()->orderBy('id')->get();

        return response()->json([
            'inquiry_id' => $result['inquiry']->id,
            'status' => $result['inquiry']->status,
            'messages' => ChatMessageResource::collection($messages),
        ]);
    }

    public function chatStore(
        SendChatMessageRequest $request,
        PartListing $part,
        SendPartChatMessageAction $sendChatAction,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var string $text */
        $text = $request->validated('text');
        $message = $sendChatAction->execute($user, $part, $text);

        return response()->json([
            'message' => new ChatMessageResource($message),
        ], 201);
    }
}
