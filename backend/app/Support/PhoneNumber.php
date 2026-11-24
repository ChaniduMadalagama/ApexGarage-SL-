<?php

declare(strict_types=1);

namespace App\Support;

final class PhoneNumber
{
    /**
     * Normalises Sri Lankan mobile numbers to E.164 (+94XXXXXXXXX).
     * Returns null when the value does not look like a mobile number.
     */
    public static function normalize(string $value): ?string
    {
        $digits = preg_replace('/[^\d+]/', '', trim($value)) ?? '';
        $digits = ltrim($digits, '+');

        if (str_starts_with($digits, '0094')) {
            $digits = substr($digits, 2);
        }
        if (str_starts_with($digits, '0') && strlen($digits) === 10) {
            $digits = '94'.substr($digits, 1);
        }
        if (strlen($digits) === 9) {
            $digits = '94'.$digits;
        }

        if (preg_match('/^94\d{9}$/', $digits) !== 1) {
            return null;
        }

        return '+'.$digits;
    }

    public static function looksLikeEmail(string $value): bool
    {
        return str_contains($value, '@');
    }
}
