<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('meet_events', function (Blueprint $table): void {
            $table->decimal('latitude', 10, 7)->nullable()->after('pin_label');
            $table->decimal('longitude', 10, 7)->nullable()->after('latitude');
        });

        Schema::create('crew_live_presences', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->foreignId('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $table->foreignId('vehicle_id')->nullable()->constrained('vehicles')->nullOnDelete();
            $table->boolean('is_riding')->default(true);
            $table->decimal('latitude', 10, 7);
            $table->decimal('longitude', 10, 7);
            $table->string('status_note', 140)->nullable();
            $table->timestamp('last_seen_at')->index();
            $table->timestamps();

            $table->index(['tenant_id', 'is_riding', 'last_seen_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('crew_live_presences');

        Schema::table('meet_events', function (Blueprint $table): void {
            $table->dropColumn(['latitude', 'longitude']);
        });
    }
};
