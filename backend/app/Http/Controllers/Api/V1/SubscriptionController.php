<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Subscriptions\Actions\ActivateIdeaBizSubscriptionAction;
use App\Domains\Subscriptions\DTOs\SubscribeIdeaBizData;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreIdeaBizSubscriptionRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;

final class SubscriptionController extends Controller
{
    public function store(StoreIdeaBizSubscriptionRequest $request, ActivateIdeaBizSubscriptionAction $action): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        /** @var array<string, mixed> $validated */
        $validated = $request->validated();

        $subscription = $action->execute(new SubscribeIdeaBizData(
            userId: $user->id,
            tenantId: $user->tenant_id,
            mobileNumber: (string) $validated['mobile_number'],
            planCode: (string) ($validated['plan_code'] ?? 'APEX_PRO_DAILY'),
            dailyRateLkr: 5,
        ));

        return response()->json([
            'status' => 'success',
            'data' => $subscription,
        ], 201);
    }
}
