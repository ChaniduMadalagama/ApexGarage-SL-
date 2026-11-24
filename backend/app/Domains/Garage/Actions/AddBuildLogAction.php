<?php

declare(strict_types=1);

namespace App\Domains\Garage\Actions;

use App\Domains\Community\Models\CommunityPost;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Garage\DTOs\CreateBuildLogData;
use App\Domains\Garage\Models\BuildLog;
use App\Domains\Garage\Models\Vehicle;
use Illuminate\Support\Facades\DB;

final class AddBuildLogAction
{
    public function execute(CreateBuildLogData $data): BuildLog
    {
        return DB::transaction(function () use ($data): BuildLog {
            $vehicle = Vehicle::query()->findOrFail($data->vehicleId);

            $log = BuildLog::query()->create([
                'vehicle_id' => $vehicle->id,
                'log_date' => now()->format('M j, Y'),
                'category' => $data->category,
                'title' => $data->title,
                'brand' => $data->brand,
                'cost_lkr' => $data->costLkr,
                'mechanic' => $data->mechanic,
                'notes' => $data->notes,
                'photo_label' => $data->photoLabel,
                'photo_url' => $data->photoUrl,
            ]);

            if ($data->shareToFeed) {
                CommunityPost::query()->create([
                    'tenant_id' => $vehicle->tenant_id,
                    'user_id' => $vehicle->user_id,
                    'vehicle_id' => $vehicle->id,
                    'vehicle_title' => $vehicle->title,
                    'mod_title' => $data->title,
                    'workshop' => $data->mechanic,
                    'illustration' => $vehicle->illustration,
                    'watermark' => $vehicle->watermark,
                    'photo_url' => $data->photoUrl,
                    'tags' => array_values(array_filter([$data->category, $data->brand])),
                    'likes_count' => 0,
                    'comments_count' => 0,
                ]);
            }

            event(new DomainStateChanged(
                domain: 'garage',
                action: 'build_log.added',
                tenantId: $vehicle->tenant_id,
            ));

            return $log;
        });
    }
}
