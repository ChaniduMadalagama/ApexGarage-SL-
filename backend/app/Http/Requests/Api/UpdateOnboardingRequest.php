<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class UpdateOnboardingRequest extends FormRequest
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
        /** @var list<string> $allowedCultures */
        $allowedCultures = config('apex.cultures', ['JDM Cars', 'Superbikes', 'Track & Drift']);

        return [
            'cultures' => ['required', 'array', 'min:1', 'max:10'],
            'cultures.*' => ['required', 'string', Rule::in($allowedCultures)],
            'onboarding_completed' => ['sometimes', 'boolean'],
        ];
    }
}
