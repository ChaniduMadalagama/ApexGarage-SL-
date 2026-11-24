<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin User
 */
final class UserResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $isPlaceholderEmail = str_ends_with($this->email, '@users.apexgarage.invalid');

        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $isPlaceholderEmail ? null : $this->email,
            'mobile_number' => $this->mobile_number,
            'handle' => $this->handle,
            'crew' => $this->crew,
            'city' => $this->city,
            'is_pro' => $this->is_pro,
            'onboarding_completed' => $this->onboarding_completed,
            'cultures' => $this->cultures ?? [],
            'active_vehicle_id' => $this->active_vehicle_id,
            'roles' => $this->getRoleNames()->values()->all(),
            'is_seller' => $this->hasRole('workshop-partner'),
            'is_admin' => $this->hasRole('super-admin'),
        ];
    }
}
