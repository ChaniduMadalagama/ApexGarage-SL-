<?php

declare(strict_types=1);

namespace App\Http\Requests\Api;

use App\Support\PhoneNumber;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

final class RegisterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $identifier = trim((string) $this->input('identifier', ''));
        $email = null;
        $mobile = null;

        if ($identifier !== '') {
            if (PhoneNumber::looksLikeEmail($identifier)) {
                $email = mb_strtolower($identifier);
            } else {
                $mobile = PhoneNumber::normalize($identifier);
                // Mobile-only sign ups get a reserved, non-routable placeholder email.
                $email = $mobile !== null ? 'm'.ltrim($mobile, '+').'@users.apexgarage.invalid' : null;
            }
        }

        $this->merge([
            'name' => trim((string) $this->input('name', '')),
            'email' => $email,
            'mobile_number' => $mobile,
            'identifier' => $identifier,
        ]);
    }

    /**
     * @return array<string, array<int, mixed>>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'min:2', 'max:80'],
            'identifier' => ['required', 'string', 'max:190'],
            'email' => ['required', 'email:rfc', 'max:190', Rule::unique('users', 'email')],
            'mobile_number' => ['nullable', 'string', 'max:32', Rule::unique('users', 'mobile_number')],
            'password' => ['required', 'string', 'max:200', Password::min(8)->letters()->numbers()],
            'cultures' => ['nullable', 'array', 'max:5'],
            'cultures.*' => ['string', Rule::in((array) config('apex.cultures'))],
            'device_name' => ['sometimes', 'string', 'max:100'],
        ];
    }

    public function messages(): array
    {
        return [
            'email.required' => 'Enter a valid Sri Lankan mobile number (e.g. 077 123 4567) or email address.',
            'email.unique' => 'An account with this identifier already exists.',
            'mobile_number.unique' => 'An account with this identifier already exists.',
        ];
    }

    public function deviceName(): string
    {
        return Str::limit((string) $this->input('device_name', 'apexgarage-mobile'), 100, '');
    }
}
