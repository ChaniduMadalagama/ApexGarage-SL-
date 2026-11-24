<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

final class StoreVehicleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    protected function prepareForValidation(): void
    {
        if (is_string($this->input('chassis'))) {
            $this->merge([
                'chassis' => strtoupper(trim((string) $this->input('chassis'))),
            ]);
        }
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'category' => ['required', 'string', 'in:Car,Bike'],
            'brand' => ['required', 'string', 'max:80'],
            'title' => ['required', 'string', 'max:160'],
            'subtitle' => ['nullable', 'string', 'max:190'],
            'watermark' => ['nullable', 'string', 'max:16'],
            'illustration' => ['nullable', 'string', 'max:40'],
            'photo_url' => ['nullable', 'string', 'max:500'],
            'stage_badge' => ['nullable', 'string', 'max:60'],
            'status' => ['nullable', 'string', 'max:60'],
            'status_tone' => ['nullable', 'string', 'in:emerald,amber'],
            'year' => ['required', 'string', 'max:8'],
            'chassis' => ['required', 'string', 'max:40'],
            'engine_code' => ['nullable', 'string', 'max:40'],
            'engine' => ['required', 'string', 'max:120'],
            'current_mileage' => ['required', 'integer', 'min:0'],
            'next_service_mileage' => ['required', 'integer', 'min:0'],
            'power_value' => ['required', 'string', 'max:20'],
            'power_unit' => ['required', 'string', 'max:12'],
            'torque_value' => ['nullable', 'string', 'max:30'],
            'estimated_value_lkr' => ['required', 'integer', 'min:0'],
            'specs' => ['nullable', 'array'],
        ];
    }
}
