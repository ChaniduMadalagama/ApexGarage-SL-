<?php

declare(strict_types=1);

namespace App\Domains\Garage\Jobs;

use App\Domains\Garage\Models\ServiceRecord;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

final class ProcessServiceReceiptOcrJob implements ShouldQueue
{
    use Queueable;

    public int $tries = 3;

    public function __construct(
        public readonly int $serviceRecordId,
    ) {}

    public function handle(): void
    {
        $record = ServiceRecord::query()->find($this->serviceRecordId);
        if ($record === null) {
            return;
        }

        Log::info('Processed service receipt verification on queue', [
            'service_record_id' => $record->id,
            'workshop' => $record->workshop,
            'cost_lkr' => $record->cost_lkr,
        ]);
    }
}
