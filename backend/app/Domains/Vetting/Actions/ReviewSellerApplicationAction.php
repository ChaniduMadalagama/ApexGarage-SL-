<?php

declare(strict_types=1);

namespace App\Domains\Vetting\Actions;

use App\Domains\Dashboard\Events\DomainStateChanged;
use App\Domains\Vetting\Models\SellerApplication;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;

final class ReviewSellerApplicationAction
{
    public function execute(
        SellerApplication $application,
        string $status,
        int $reviewerId,
        ?string $rejectionReason = null,
    ): SellerApplication {
        return DB::transaction(function () use ($application, $status, $reviewerId, $rejectionReason): SellerApplication {
            $application->update([
                'status' => $status,
                'reviewed_by' => $reviewerId,
                'reviewed_at' => now(),
                'rejection_reason' => $status === 'Rejected' ? $rejectionReason : null,
            ]);

            if ($status === 'Verified' && $application->user !== null) {
                $role = Role::findOrCreate('workshop-partner', 'web');
                $application->user->assignRole($role);
            }

            event(new DomainStateChanged(
                domain: 'vetting',
                action: 'seller_application.'.strtolower($status),
                tenantId: $application->tenant_id,
            ));

            return $application->fresh() ?? $application;
        });
    }
}
