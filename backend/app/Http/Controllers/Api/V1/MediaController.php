<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Contracts\MediaStorageInterface;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\UploadMediaRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Str;

class MediaController extends Controller
{
    public function store(UploadMediaRequest $request, MediaStorageInterface $storage): JsonResponse
    {
        $user = $request->user();
        abort_if($user === null, 401);

        /** @var UploadedFile $file */
        $file = $request->file('file');
        $folder = (string) ($request->validated('folder') ?? 'receipts');
        $ext = strtolower($file->guessExtension() ?: $file->getClientOriginalExtension() ?: 'bin');

        $directory = "{$folder}/{$user->id}";
        $filename = Str::uuid()->toString().".{$ext}";
        $contents = file_get_contents($file->getRealPath());
        abort_if($contents === false, 422, 'Unable to read uploaded file.');

        $storedPath = $storage->storeContent($directory, $filename, $contents);

        return response()->json([
            'path' => $storedPath,
            'url' => $storage->url($storedPath),
        ], 201);
    }
}
