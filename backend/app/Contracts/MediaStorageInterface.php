<?php

declare(strict_types=1);

namespace App\Contracts;

interface MediaStorageInterface
{
    public function storeContent(string $directory, string $filename, string $contents): string;

    public function url(string $path): string;

    public function delete(string $path): bool;
}
