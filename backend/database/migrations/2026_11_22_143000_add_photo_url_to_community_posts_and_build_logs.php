<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('build_logs', function (Blueprint $table): void {
            $table->string('photo_url', 500)->nullable()->after('photo_label');
        });

        Schema::table('community_posts', function (Blueprint $table): void {
            $table->string('photo_url', 500)->nullable()->after('watermark');
        });
    }

    public function down(): void
    {
        Schema::table('build_logs', function (Blueprint $table): void {
            $table->dropColumn('photo_url');
        });

        Schema::table('community_posts', function (Blueprint $table): void {
            $table->dropColumn('photo_url');
        });
    }
};
