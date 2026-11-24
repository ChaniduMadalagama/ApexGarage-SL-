<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

final class StorePartListingRequest extends FormRequest
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
            'brand' => ['required', 'string', 'max:80'],
            'title' => ['required', 'string', 'max:160'],
            'subtitle' => ['required', 'string', 'max:190'],
            'fitment' => ['nullable', 'string', 'max:190'],
            'sku' => ['nullable', 'string', 'max:60'],
            'stock' => ['nullable', 'integer', 'min:1', 'max:999'],
            'watermark' => ['required', 'string', 'max:16'],
            'illustration' => ['required', 'string', 'max:40'],
            'photo_url' => ['nullable', 'string', 'max:500'],
            'price_lkr' => ['required', 'integer', 'min:100'],
            'condition' => ['required', 'string', 'max:60'],
            'trust_badges' => ['nullable', 'array'],
            'location' => ['required', 'string', 'max:120'],
            'description' => ['required', 'string', 'max:2000'],
            'specs' => ['nullable', 'array'],
        ];
    }
}
