<?php

declare(strict_types=1);

namespace App\Domains\Garage\DTOs;

final readonly class CreateVehicleData
{
    /**
     * @param  array<int, array<string, mixed>>  $specs
     */
    public function __construct(
        public int $userId,
        public ?int $tenantId,
        public string $category,
        public string $brand,
        public string $title,
        public string $subtitle,
        public string $watermark,
        public string $illustration,
        public string $stageBadge,
        public string $status,
        public string $statusTone,
        public string $year,
        public string $chassis,
        public string $engineCode,
        public string $engine,
        public int $currentMileage,
        public int $nextServiceMileage,
        public string $powerValue,
        public string $powerUnit,
        public string $torqueValue,
        public int $estimatedValueLkr,
        public array $specs = [],
        public ?string $photoUrl = null,
    ) {}

    /**
     * @param  array<string, mixed>  $validated
     */
    public static function fromValidated(array $validated, int $userId, ?int $tenantId = null): self
    {
        /** @var array<int, array<string, mixed>> $specs */
        $specs = is_array($validated['specs'] ?? null) ? $validated['specs'] : [];

        return new self(
            userId: $userId,
            tenantId: $tenantId,
            category: (string) ($validated['category'] ?? 'Car'),
            brand: (string) $validated['brand'],
            title: (string) $validated['title'],
            subtitle: (string) ($validated['subtitle'] ?? 'Registered Build · Sri Lanka'),
            watermark: strtoupper((string) ($validated['watermark'] ?? substr((string) $validated['chassis'], 0, 5))),
            illustration: (string) ($validated['illustration'] ?? 'fd2'),
            stageBadge: (string) ($validated['stage_badge'] ?? 'Stage 1'),
            status: (string) ($validated['status'] ?? 'Verified Build'),
            statusTone: (string) ($validated['status_tone'] ?? 'emerald'),
            year: (string) ($validated['year'] ?? '2020'),
            chassis: (string) $validated['chassis'],
            engineCode: (string) ($validated['engine_code'] ?? ''),
            engine: (string) $validated['engine'],
            currentMileage: (int) ($validated['current_mileage'] ?? 0),
            nextServiceMileage: (int) ($validated['next_service_mileage'] ?? 5000),
            powerValue: (string) ($validated['power_value'] ?? '250'),
            powerUnit: (string) ($validated['power_unit'] ?? 'WHP'),
            torqueValue: (string) ($validated['torque_value'] ?? '300 Nm'),
            estimatedValueLkr: (int) ($validated['estimated_value_lkr'] ?? 0),
            specs: $specs,
            photoUrl: isset($validated['photo_url']) ? (string) $validated['photo_url'] : null,
        );
    }
}
