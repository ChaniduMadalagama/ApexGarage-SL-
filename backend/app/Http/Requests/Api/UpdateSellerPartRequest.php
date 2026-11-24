<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

final class UpdateSellerPartRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'price_lkr' => ['required', 'integer', 'min:100', 'max:50000000'],
            'stock' => ['required', 'integer', 'min:0', 'max:9999'],
            'title' => ['sometimes', 'string', 'max:160'],
            'fitment' => ['sometimes', 'string', 'max:160'],
            'description' => ['sometimes', 'string', 'max:2000'],
        ];
    }
}
