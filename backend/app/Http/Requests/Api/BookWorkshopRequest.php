<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class BookWorkshopRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /**
     * @return array<string, array<int, mixed>>
     */
    public function rules(): array
    {
        /** @var list<array{key: string, label: string, price_lkr: int}> $services */
        $services = config('apex.workshop_services', []);
        $serviceKeys = array_column($services, 'key');

        return [
            'service_key' => ['required', 'string', Rule::in($serviceKeys)],
            'slot' => ['required', 'string', 'max:60'],
            'vehicle_id' => ['nullable', 'integer', 'min:1'],
        ];
    }
}
