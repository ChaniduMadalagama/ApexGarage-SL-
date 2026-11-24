<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('community_post_comments', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('community_post_id')->constrained('community_posts')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->text('body');
            $table->timestamps();

            $table->index(['community_post_id', 'id']);
        });

        Schema::table('vehicles', function (Blueprint $table): void {
            $table->string('photo_url', 500)->nullable()->after('illustration');
        });

        Schema::table('part_listings', function (Blueprint $table): void {
            $table->string('photo_url', 500)->nullable()->after('illustration');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('community_post_comments');

        Schema::table('vehicles', function (Blueprint $table): void {
            $table->dropColumn('photo_url');
        });

        Schema::table('part_listings', function (Blueprint $table): void {
            $table->dropColumn('photo_url');
        });
    }
};
