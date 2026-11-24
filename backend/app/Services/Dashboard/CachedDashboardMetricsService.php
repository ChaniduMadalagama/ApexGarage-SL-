<?php

declare(strict_types=1);

namespace App\Services\Dashboard;

use App\Contracts\DashboardMetricsServiceInterface;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Subscriptions\Models\Subscription;
use App\Domains\Workshops\Models\Workshop;
use Illuminate\Support\Facades\Cache;

final class CachedDashboardMetricsService implements DashboardMetricsServiceInterface
{
    private const CACHE_TTL_SECONDS = 900;

    /**
     * @return array{
     *     total_vehicles: int,
     *     total_garages_value_lkr: int,
     *     active_marketplace_parts: int,
     *     verified_workshops: int,
     *     upcoming_meets: int,
     *     active_pro_subscriptions: int,
     *     daily_recurring_revenue_lkr: int,
     *     category_breakdown: array<string, int>
     * }
     */
    public function getOverviewMetrics(?int $tenantId = null): array
    {
        $cacheKey = $this->cacheKey($tenantId);

        /** @var array{
         *     total_vehicles: int,
         *     total_garages_value_lkr: int,
         *     active_marketplace_parts: int,
         *     verified_workshops: int,
         *     upcoming_meets: int,
         *     active_pro_subscriptions: int,
         *     daily_recurring_revenue_lkr: int,
         *     category_breakdown: array<string, int>
         * } $metrics
         */
        $metrics = Cache::remember($cacheKey, self::CACHE_TTL_SECONDS, function (): array {
            $totalVehicles = Vehicle::query()->count();
            $totalGarageValue = (int) Vehicle::query()->sum('estimated_value_lkr');
            $carCount = Vehicle::query()->where('category', 'Car')->count();
            $bikeCount = Vehicle::query()->where('category', 'Bike')->count();

            $activeParts = PartListing::query()->where('status', 'active')->count();
            $verifiedWorkshops = Workshop::query()->where('is_verified', true)->count();
            $upcomingMeets = MeetEvent::query()->where('status', 'upcoming')->count();

            $activeSubscriptionsQuery = Subscription::query()->where('status', 'active');
            $activeSubscriptions = (clone $activeSubscriptionsQuery)->count();
            $dailyRevenueLkr = (int) (clone $activeSubscriptionsQuery)->sum('daily_rate_lkr');

            return [
                'total_vehicles' => $totalVehicles,
                'total_garages_value_lkr' => $totalGarageValue,
                'active_marketplace_parts' => $activeParts,
                'verified_workshops' => $verifiedWorkshops,
                'upcoming_meets' => $upcomingMeets,
                'active_pro_subscriptions' => $activeSubscriptions,
                'daily_recurring_revenue_lkr' => $dailyRevenueLkr,
                'category_breakdown' => [
                    'Car' => $carCount,
                    'Bike' => $bikeCount,
                ],
            ];
        });

        return $metrics;
    }

    public function invalidateMetricsCache(?int $tenantId = null): void
    {
        Cache::forget($this->cacheKey($tenantId));
        Cache::forget($this->cacheKey(null));
    }

    private function cacheKey(?int $tenantId): string
    {
        return sprintf('apexgarage:dashboard:metrics:tenant:%s', $tenantId ?? 'global');
    }
}
