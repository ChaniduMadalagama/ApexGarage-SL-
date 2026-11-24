<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Auth\Actions\IssueSanctumTokenAction;
use App\Domains\Auth\Actions\RegisterUserAction;
use App\Domains\Auth\DTOs\AuthenticateUserData;
use App\Domains\Auth\DTOs\RegisterUserData;
use App\Domains\Tenancy\Support\TenantContext;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\RegisterRequest;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function register(
        RegisterRequest $request,
        RegisterUserAction $registerAction,
        TenantContext $tenantContext,
    ): JsonResponse {
        /** @var array{name: string, email: string, mobile_number?: string|null, password: string, cultures?: list<string>, device_name?: string} $v */
        $v = $request->validated();

        $data = new RegisterUserData(
            tenantId: $tenantContext->getTenantId(),
            name: $v['name'],
            email: $v['email'],
            mobileNumber: $v['mobile_number'] ?? null,
            password: $v['password'],
            cultures: $v['cultures'] ?? [],
            deviceName: $v['device_name'] ?? 'apexgarage-mobile',
        );

        $result = $registerAction->execute($data);

        return response()->json([
            'token' => $result['token'],
            'user' => new UserResource($result['user']),
        ], 201);
    }

    public function login(LoginRequest $request, IssueSanctumTokenAction $issueTokenAction): JsonResponse
    {
        /** @var array{identifier: string, password: string, device_name?: string} $v */
        $v = $request->validated();

        $data = new AuthenticateUserData(
            identifier: $v['identifier'],
            password: $v['password'],
            deviceName: $v['device_name'] ?? 'apexgarage-mobile',
        );

        $result = $issueTokenAction->execute($data);

        return response()->json([
            'token' => $result['token'],
            'user' => new UserResource($result['user']),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $user = $request->user();
        if ($user !== null) {
            $user->currentAccessToken()->delete();
        }

        return response()->json(['message' => 'Logged out successfully.']);
    }

    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $user->load('roles');

        return response()->json([
            'user' => new UserResource($user),
        ]);
    }
}
