<?php

declare(strict_types=1);

namespace App\Services\Storage;

use App\Contracts\MediaStorageInterface;
use Illuminate\Support\Facades\Storage;

final class DiskMediaStorageService implements MediaStorageInterface
{
    public function __construct(
        private readonly string $disk = 'public',
    ) {}

    public function storeContent(string $directory, string $filename, string $contents): string
    {
        $path = trim($directory, '/').'/'.ltrim($filename, '/');
        Storage::disk($this->disk)->put($path, $contents);

        return $path;
    }

    public function url(string $path): string
    {
        return Storage::disk($this->disk)->url($path);
    }

    public function delete(string $path): bool
    {
        return Storage::disk($this->disk)->delete($path);
    }
}
