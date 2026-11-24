<?php

declare(strict_types=1);

namespace App\Domains\Dashboard\Listeners;

use App\Contracts\DashboardMetricsServiceInterface;
use App\Domains\Dashboard\Events\DomainStateChanged;

final class InvalidateDashboardCacheListener
{
    public function __construct(
        private readonly DashboardMetricsServiceInterface $metricsService,
    ) {}

    public function handle(DomainStateChanged $event): void
    {
        $this->metricsService->invalidateMetricsCache($event->tenantId);
    }
}
