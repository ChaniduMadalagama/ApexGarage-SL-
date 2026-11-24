<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

final class StoreServiceRecordRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'title' => ['nullable', 'string', 'max:160'],
            'service_type' => ['nullable', 'string', 'max:160'],
            'service_date' => ['nullable', 'string', 'max:60'],
            'workshop' => ['nullable', 'string', 'max:160'],
            'workshop_name' => ['nullable', 'string', 'max:160'],
            'odometer_km' => ['required', 'integer', 'min:0', 'max:2000000'],
            'next_service_km' => ['nullable', 'integer', 'min:0', 'max:2000000'],
            'next_service_mileage' => ['nullable', 'integer', 'min:0', 'max:2000000'],
            'next_service_date' => ['nullable', 'string', 'max:60'],
            'parts_changed' => ['nullable', 'array'],
            'parts_changed.*' => ['string', 'max:120'],
            'cost_lkr' => ['required', 'integer', 'min:0', 'max:50000000'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'receipt_label' => ['nullable', 'string', 'max:500'],
            'receipt_url' => ['nullable', 'string', 'max:500'],
        ];
    }
}
