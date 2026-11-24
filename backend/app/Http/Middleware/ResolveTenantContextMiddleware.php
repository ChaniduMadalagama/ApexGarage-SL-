<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Tenancy\Support\TenantContext;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Symfony\Component\HttpFoundation\Response;

/**
 * Resolves the tenant for the request.
 *
 * SECURITY: the tenant is NEVER taken from client input. Authenticated users
 * get their own tenant; guests only ever see the configured default tenant.
 */
final class ResolveTenantContextMiddleware
{
    public function __construct(
        private readonly TenantContext $tenantContext,
    ) {}

    /**
     * @param  Closure(Request): Response  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $this->tenantContext->clear();

        $user = $request->user('sanctum') ?? $request->user();

        if ($user instanceof User && $user->tenant_id !== null) {
            $this->tenantContext->setTenantId($user->tenant_id);
        } else {
            $defaultId = $this->defaultTenantId();
            if ($defaultId !== null) {
                $this->tenantContext->setTenantId($defaultId);
            }
        }

        return $next($request);
    }

    private function defaultTenantId(): ?int
    {
        $slug = (string) config('apex.default_tenant_slug');

        $id = Cache::remember(
            'tenant:default_id:'.$slug,
            (int) config('apex.cache_ttl.default_tenant', 3600),
            static fn (): ?int => Tenant::query()->where('slug', $slug)->value('id'),
        );

        return is_numeric($id) ? (int) $id : null;
    }
}
