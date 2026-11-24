<?php

declare(strict_types=1);

namespace App\Domains\Dashboard\Events;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

final class DomainStateChanged
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public readonly string $domain,
        public readonly string $action,
        public readonly ?int $tenantId = null,
    ) {}
}
