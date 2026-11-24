<?php

declare(strict_types=1);

namespace App\Contracts;

interface DashboardMetricsServiceInterface
{
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
    public function getOverviewMetrics(?int $tenantId = null): array;

    public function invalidateMetricsCache(?int $tenantId = null): void;
}
