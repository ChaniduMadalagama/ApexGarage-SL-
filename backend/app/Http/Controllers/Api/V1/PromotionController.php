<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Community\Models\Promotion;
use App\Domains\Tenancy\Support\TenantContext;
use App\Http\Controllers\Controller;
use App\Http\Resources\PromotionResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class PromotionController extends Controller
{
    public function active(TenantContext $tenantContext): JsonResponse
    {
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

        return response()->json([
            'promotion' => $promotion !== null ? new PromotionResource($promotion) : null,
        ]);
    }
}
