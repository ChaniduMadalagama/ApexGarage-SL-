<?php

declare(strict_types=1);

namespace App\Domains\Garage\DTOs;

final readonly class CreateServiceRecordData
{
    /**
     * @param  array<int, string>  $partsChanged
     */
    public function __construct(
        public int $vehicleId,
        public string $title,
        public string $serviceDate,
        public int $odometerKm,
        public string $workshop,
        public array $partsChanged,
        public int $costLkr,
        public int $nextServiceKm,
        public string $nextServiceDate,
        public ?string $notes = null,
        public ?string $receiptLabel = null,
    ) {}
}
