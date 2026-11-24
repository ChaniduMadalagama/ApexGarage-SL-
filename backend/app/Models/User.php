<?php

declare(strict_types=1);

namespace App\Models;

use App\Domains\Community\Models\Crew;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Subscriptions\Models\Subscription;
use App\Domains\Tenancy\Concerns\BelongsToTenant;
use App\Domains\Vetting\Models\SellerApplication;
use App\Domains\Workshops\Models\WorkshopBooking;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

/**
 * @property int $id
 * @property int|null $tenant_id
 * @property string $name
 * @property string $email
 * @property string|null $mobile_number
 * @property string|null $handle
 * @property string|null $crew
 * @property string $city
 * @property bool $is_pro
 * @property bool $onboarding_completed
 * @property array<int, string>|null $cultures
 * @property int|null $active_vehicle_id
 * @property string $password
 */
class User extends Authenticatable
{
    use BelongsToTenant;

    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, HasRoles, Notifiable;

    protected $fillable = [
        'tenant_id',
        'name',
        'email',
        'mobile_number',
        'handle',
        'crew',
        'city',
        'is_pro',
        'onboarding_completed',
        'cultures',
        'active_vehicle_id',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_pro' => 'boolean',
            'onboarding_completed' => 'boolean',
            'cultures' => 'array',
        ];
    }

    /**
     * @return BelongsToMany<PartListing, $this>
     */
    public function savedParts(): BelongsToMany
    {
        return $this->belongsToMany(PartListing::class, 'saved_parts')->withTimestamps();
    }

    /**
     * @return BelongsToMany<MeetEvent, $this>
     */
    public function meetRsvps(): BelongsToMany
    {
        return $this->belongsToMany(MeetEvent::class, 'meet_rsvps')->withTimestamps();
    }

    /**
     * @return HasMany<Vehicle, $this>
     */
    public function vehicles(): HasMany
    {
        return $this->hasMany(Vehicle::class);
    }

    /**
     * @return HasMany<PartListing, $this>
     */
    public function partListings(): HasMany
    {
        return $this->hasMany(PartListing::class);
    }

    /**
     * @return HasMany<Subscription, $this>
     */
    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    /**
     * @return HasOne<SellerApplication, $this>
     */
    public function sellerApplication(): HasOne
    {
        return $this->hasOne(SellerApplication::class, 'user_id')->latestOfMany();
    }

    /**
     * @return HasMany<WorkshopBooking, $this>
     */
    public function workshopBookings(): HasMany
    {
        return $this->hasMany(WorkshopBooking::class, 'user_id');
    }

    /**
     * @return BelongsToMany<Crew, $this>
     */
    public function crews(): BelongsToMany
    {
        return $this->belongsToMany(Crew::class, 'crew_members')->withTimestamps();
    }
}
