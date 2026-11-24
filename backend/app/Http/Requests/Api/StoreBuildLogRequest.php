<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class StoreBuildLogRequest extends FormRequest
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
        /** @var list<string> $categories */
        $categories = config('apex.build_log_categories', ['Engine', 'Brakes', 'Exhaust', 'Suspension', 'Service', 'Other']);

        return [
            'title' => ['required', 'string', 'max:160'],
            'category' => ['required', 'string', Rule::in($categories)],
            'brand' => ['nullable', 'string', 'max:100'],
            'cost_lkr' => ['required', 'integer', 'min:0', 'max:50000000'],
            'mechanic' => ['nullable', 'string', 'max:120'],
            'workshop' => ['nullable', 'string', 'max:120'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'photo_label' => ['nullable', 'string', 'max:500'],
            'photo_url' => ['nullable', 'string', 'max:500'],
            'receipt_url' => ['nullable', 'string', 'max:500'],
            'share_to_feed' => ['nullable', 'boolean'],
        ];
    }
}
