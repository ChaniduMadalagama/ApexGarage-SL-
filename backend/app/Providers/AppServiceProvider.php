<?php

declare(strict_types=1);

namespace App\Providers;

use App\Contracts\DashboardMetricsServiceInterface;
use App\Contracts\MediaStorageInterface;
use App\Contracts\TelcoBillingGatewayInterface;
use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Dashboard\Listeners\InvalidateDashboardCacheListener;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Tenancy\Support\TenantContext;
use App\Policies\VehiclePolicy;
use App\Services\Billing\IdeaBizBillingGateway;
use App\Services\Dashboard\CachedDashboardMetricsService;
use App\Services\Storage\DiskMediaStorageService;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->singleton(TenantContext::class, fn (): TenantContext => new TenantContext);

        $this->app->bind(MediaStorageInterface::class, fn (): MediaStorageInterface => new DiskMediaStorageService(
            disk: (string) config('apex.media_disk', 'public'),
        ));

        $this->app->bind(TelcoBillingGatewayInterface::class, IdeaBizBillingGateway::class);
        $this->app->bind(DashboardMetricsServiceInterface::class, CachedDashboardMetricsService::class);
    }

    public function boot(): void
    {
        Model::preventLazyLoading(! $this->app->isProduction());

        Gate::policy(Vehicle::class, VehiclePolicy::class);

        Event::listen(
            DomainStateChanged::class,
            InvalidateDashboardCacheListener::class,
        );

        $userOrIp = static fn (Request $request): string => (string) ($request->user()?->getAuthIdentifier() ?? $request->ip());

        RateLimiter::for('api', fn (Request $request): Limit => Limit::perMinute(120)->by($userOrIp($request)));

        // Brute-force protection: per identifier AND per IP.
        RateLimiter::for('auth', fn (Request $request): array => [
            Limit::perMinute(5)->by('login:'.mb_strtolower((string) $request->input('identifier')).'|'.$request->ip()),
            Limit::perMinute(20)->by('login-ip:'.$request->ip()),
        ]);

        RateLimiter::for('register', fn (Request $request): array => [
            Limit::perMinute(5)->by('register:'.$request->ip()),
            Limit::perHour(20)->by('register-hour:'.$request->ip()),
        ]);

        RateLimiter::for('chat', fn (Request $request): Limit => Limit::perMinute(30)->by('chat:'.$userOrIp($request)));
        RateLimiter::for('uploads', fn (Request $request): Limit => Limit::perMinute(20)->by('upload:'.$userOrIp($request)));
        RateLimiter::for('writes', fn (Request $request): Limit => Limit::perMinute(30)->by('write:'.$userOrIp($request)));
        RateLimiter::for('meet-host', fn (Request $request): Limit => Limit::perHour(5)->by('meet:'.$userOrIp($request)));
    }
}
