<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Domains\Garage\Models\Vehicle;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Vehicle>
 */
class VehicleFactory extends Factory
{
    protected $model = Vehicle::class;

    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'category' => 'Car',
            'brand' => 'Honda',
            'title' => 'Civic Type R FD2',
            'subtitle' => 'K20A Naturally Aspirated · Colombo',
            'watermark' => 'FD2R',
            'illustration' => 'fd2',
            'stage_badge' => 'Stage 2 NA',
            'status' => 'Dyno Verified',
            'status_tone' => 'emerald',
            'year' => '2008',
            'chassis' => 'ABA-FD2',
            'engine_code' => 'K20A',
            'engine' => '2.0L DOHC i-VTEC',
            'current_mileage' => 64350,
            'next_service_mileage' => 65000,
            'power_value' => '262',
            'power_unit' => 'WHP',
            'torque_value' => '234 Nm',
            'estimated_value_lkr' => 14500000,
            'specs' => [
                ['label' => 'Hondata FlashPro'],
                ['label' => 'Toda A3 Cams'],
            ],
        ];
    }
}
