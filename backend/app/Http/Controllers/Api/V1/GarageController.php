<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Garage\Actions\AddBuildLogAction;
use App\Domains\Garage\Actions\LogServiceRecordAction;
use App\Domains\Garage\Actions\RegisterVehicleAction;
use App\Domains\Garage\DTOs\CreateBuildLogData;
use App\Domains\Garage\DTOs\CreateServiceRecordData;
use App\Domains\Garage\DTOs\CreateVehicleData;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Tenancy\Support\TenantContext;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreBuildLogRequest;
use App\Http\Requests\Api\StoreServiceRecordRequest;
use App\Http\Requests\Api\StoreVehicleRequest;
use App\Http\Resources\BuildLogResource;
use App\Http\Resources\ServiceRecordResource;
use App\Http\Resources\VehicleResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

class GarageController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        $perPage = min(
            max(1, (int) $request->integer('per_page', (int) config('apex.pagination.default', 20))),
            (int) config('apex.pagination.max', 50)
        );

        $vehicles = Vehicle::query()
            ->with(['buildLogs', 'serviceRecords'])
            ->where('user_id', $user->id)
            ->latest('id')
            ->paginate($perPage);

        return response()->json([
            'vehicles' => VehicleResource::collection($vehicles->items()),
            'meta' => [
                'current_page' => $vehicles->currentPage(),
                'last_page' => $vehicles->lastPage(),
                'per_page' => $vehicles->perPage(),
                'total' => $vehicles->total(),
            ],
        ]);
    }

    public function show(Vehicle $vehicle): JsonResponse
    {
        Gate::authorize('view', $vehicle);
        $vehicle->load(['buildLogs', 'serviceRecords']);

        return response()->json([
            'vehicle' => new VehicleResource($vehicle),
        ]);
    }

    public function store(
        StoreVehicleRequest $request,
        RegisterVehicleAction $registerVehicleAction,
        TenantContext $tenantContext,
    ): JsonResponse {
        $user = $request->user();
        abort_if($user === null, 401);

        $data = CreateVehicleData::fromValidated(
            validated: $request->validated(),
            userId: (int) $user->id,
            tenantId: $tenantContext->getTenantId(),
        );

        $vehicle = $registerVehicleAction->execute($data);
        $vehicle->load(['buildLogs', 'serviceRecords']);

        if ($user->active_vehicle_id === null) {
            $user->update(['active_vehicle_id' => $vehicle->id]);
        }

        return response()->json([
            'vehicle' => new VehicleResource($vehicle),
        ], 201);
    }

    public function storeBuildLog(
        StoreBuildLogRequest $request,
        Vehicle $vehicle,
        AddBuildLogAction $addBuildLogAction,
    ): JsonResponse {
        Gate::authorize('update', $vehicle);

        /** @var array<string, mixed> $v */
        $v = $request->validated();

        $log = $addBuildLogAction->execute(new CreateBuildLogData(
            vehicleId: (int) $vehicle->id,
            category: (string) $v['category'],
            title: (string) $v['title'],
            brand: (string) ($v['brand'] ?? 'Custom'),
            costLkr: (int) $v['cost_lkr'],
            mechanic: (string) ($v['mechanic'] ?? $v['workshop'] ?? 'Independent Workshop'),
            notes: isset($v['notes']) ? (string) $v['notes'] : null,
            photoLabel: isset($v['photo_label']) ? (string) $v['photo_label'] : (isset($v['receipt_url']) ? (string) $v['receipt_url'] : null),
            photoUrl: isset($v['photo_url']) ? (string) $v['photo_url'] : null,
            shareToFeed: (bool) ($v['share_to_feed'] ?? true),
        ));

        return response()->json([
            'build_log' => new BuildLogResource($log),
        ], 201);
    }

    public function storeServiceRecord(
        StoreServiceRecordRequest $request,
        Vehicle $vehicle,
        LogServiceRecordAction $logServiceAction,
    ): JsonResponse {
        Gate::authorize('update', $vehicle);

        /** @var array<string, mixed> $v */
        $v = $request->validated();
        $odometer = (int) $v['odometer_km'];
        $nextKm = (int) ($v['next_service_km'] ?? $v['next_service_mileage'] ?? ($odometer + 5000));

        /** @var list<string> $partsChanged */
        $partsChanged = is_array($v['parts_changed'] ?? null) ? array_values($v['parts_changed']) : [];

        $record = $logServiceAction->execute(new CreateServiceRecordData(
            vehicleId: (int) $vehicle->id,
            title: (string) ($v['title'] ?? $v['service_type'] ?? 'Scheduled Service'),
            serviceDate: (string) ($v['service_date'] ?? now()->format('d M Y')),
            odometerKm: $odometer,
            workshop: (string) ($v['workshop'] ?? $v['workshop_name'] ?? 'Apex Dyno Lab Colombo'),
            partsChanged: $partsChanged,
            costLkr: (int) $v['cost_lkr'],
            nextServiceKm: $nextKm,
            nextServiceDate: (string) ($v['next_service_date'] ?? now()->addMonths(6)->format('d M Y')),
            notes: isset($v['notes']) ? (string) $v['notes'] : null,
            receiptLabel: isset($v['receipt_label']) ? (string) $v['receipt_label'] : (isset($v['receipt_url']) ? (string) $v['receipt_url'] : null),
        ));

        return response()->json([
            'service_record' => new ServiceRecordResource($record),
        ], 201);
    }
}
