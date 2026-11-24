<?php

declare(strict_types=1);

use App\Domains\Tenancy\Support\TenantContext;

it('manages tenant context state accurately', function (): void {
    $context = new TenantContext;
    expect($context->hasTenant())->toBeFalse();

    $context->setTenantId(42);
    expect($context->hasTenant())->toBeTrue()
        ->and($context->getTenantId())->toBe(42);

    $context->clear();
    expect($context->hasTenant())->toBeFalse();
});
