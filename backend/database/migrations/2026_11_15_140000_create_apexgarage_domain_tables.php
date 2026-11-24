<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tenants', function (Blueprint $table): void {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('domain')->nullable()->index();
            $table->boolean('is_active')->default(true)->index();
            $table->json('settings')->nullable();
            $table->timestamps();
            $table->index('created_at');
        });

        Schema::table('users', function (Blueprint $table): void {
            $table->foreignId('tenant_id')->nullable()->after('id')->constrained('tenants')->nullOnDelete();
            $table->string('mobile_number', 32)->nullable()->after('email')->index();
            $table->string('handle', 64)->nullable()->after('mobile_number');
            $table->string('crew', 100)->nullable()->after('handle');
            $table->string('city', 80)->default('Colombo, LK')->after('crew');
            $table->boolean('is_pro')->default(false)->after('city')->index();
            $table->index(['tenant_id', 'created_at']);
        });

        Schema::create('vehicles', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('category', 20)->default('Car')->index();
            $table->string('brand', 80)->index();
            $table->string('title', 160);
            $table->string('subtitle', 190)->default('Registered Build · Sri Lanka');
            $table->string('watermark', 16);
            $table->string('illustration', 40)->default('fd2');
            $table->string('stage_badge', 60)->default('Active Build');
            $table->string('status', 60)->default('Verified Build')->index();
            $table->string('status_tone', 24)->default('emerald');
            $table->string('year', 8)->default('2020');
            $table->string('chassis', 40)->index();
            $table->string('engine_code', 40)->default('');
            $table->string('engine', 120);
            $table->unsignedInteger('current_mileage')->default(0);
            $table->unsignedInteger('next_service_mileage')->default(5000);
            $table->string('power_value', 24);
            $table->string('power_unit', 16)->default('WHP');
            $table->string('torque_value', 32)->default('250 Nm');
            $table->unsignedBigInteger('estimated_value_lkr')->default(0);
            $table->json('specs')->nullable();
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });

        Schema::create('build_logs', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('vehicle_id')->constrained('vehicles')->cascadeOnDelete();
            $table->string('log_date', 32);
            $table->string('category', 60)->index();
            $table->string('title', 160);
            $table->string('brand', 80);
            $table->unsignedBigInteger('cost_lkr')->default(0);
            $table->string('mechanic', 120);
            $table->text('notes')->nullable();
            $table->string('photo_label', 120)->nullable();
            $table->timestamps();

            $table->index('created_at');
        });

        Schema::create('service_records', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('vehicle_id')->constrained('vehicles')->cascadeOnDelete();
            $table->string('title', 160);
            $table->string('service_date', 32);
            $table->unsignedInteger('odometer_km');
            $table->string('workshop', 120);
            $table->json('parts_changed')->nullable();
            $table->unsignedBigInteger('cost_lkr')->default(0);
            $table->unsignedInteger('next_service_km')->index();
            $table->string('next_service_date', 32);
            $table->text('notes')->nullable();
            $table->string('receipt_label', 120)->nullable();
            $table->timestamps();

            $table->index('created_at');
        });

        Schema::create('part_listings', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('brand', 80)->index();
            $table->string('title', 160);
            $table->string('subtitle', 190);
            $table->string('watermark', 16);
            $table->string('illustration', 40)->default('turbo');
            $table->unsignedBigInteger('price_lkr')->index();
            $table->string('condition', 60);
            $table->json('trust_badges')->nullable();
            $table->string('seller_name', 120);
            $table->string('location', 120)->index();
            $table->string('rating', 12)->default('4.9');
            $table->boolean('is_verified')->default(true)->index();
            $table->json('specs')->nullable();
            $table->text('description');
            $table->string('status', 32)->default('active')->index();
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });

        Schema::create('workshops', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('name', 140);
            $table->string('location', 120)->index();
            $table->string('specialty', 160);
            $table->string('rating', 12)->default('4.9');
            $table->unsignedInteger('reviews_count')->default(0);
            $table->string('base_price', 60);
            $table->json('tags')->nullable();
            $table->string('availability', 80)->default('Open Today');
            $table->boolean('is_verified')->default(true)->index();
            $table->timestamps();

            $table->index(['tenant_id', 'is_verified', 'created_at']);
        });

        Schema::create('meet_events', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('pin_id', 32)->index();
            $table->string('title', 160);
            $table->string('event_date', 60);
            $table->string('location', 140);
            $table->string('host', 120);
            $table->unsignedInteger('going_count')->default(0);
            $table->decimal('pin_top_ratio', 5, 2)->default(0.45);
            $table->decimal('pin_left_ratio', 5, 2)->default(0.52);
            $table->string('pin_label', 60);
            $table->string('status', 32)->default('upcoming')->index();
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });

        Schema::create('subscriptions', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('plan_code', 60)->default('APEX_PRO_DAILY')->index();
            $table->string('carrier', 80);
            $table->string('mobile_number', 32)->index();
            $table->unsignedInteger('daily_rate_lkr')->default(5);
            $table->string('reference_id', 64)->unique();
            $table->string('status', 32)->default('active')->index();
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
        Schema::dropIfExists('meet_events');
        Schema::dropIfExists('workshops');
        Schema::dropIfExists('part_listings');
        Schema::dropIfExists('service_records');
        Schema::dropIfExists('build_logs');
        Schema::dropIfExists('vehicles');

        Schema::table('users', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('tenant_id');
            $table->dropColumn(['mobile_number', 'handle', 'crew', 'city', 'is_pro']);
        });

        Schema::dropIfExists('tenants');
    }
};
