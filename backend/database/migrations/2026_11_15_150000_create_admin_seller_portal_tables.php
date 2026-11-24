<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('part_listings', function (Blueprint $table): void {
            $table->string('seller_id', 64)->default('seller_jdm')->after('user_id')->index();
            $table->string('sku', 64)->nullable()->after('seller_id')->index();
            $table->string('fitment', 160)->nullable()->after('subtitle');
            $table->unsignedInteger('stock')->default(1)->after('price_lkr');
            $table->unsignedInteger('views_count')->default(0)->after('status');
            $table->unsignedInteger('inquiries_count')->default(0)->after('views_count');
        });

        Schema::create('seller_applications', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('business_name', 140);
            $table->string('owner_name', 120);
            $table->string('type', 100);
            $table->string('br_number', 80)->index();
            $table->string('location', 120)->index();
            $table->string('phone', 32);
            $table->string('submitted_time_label', 60)->default('Just now');
            $table->string('status', 32)->default('Pending')->index();
            $table->json('documents')->nullable();
            $table->string('specialty', 190);
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });

        Schema::create('sponsored_ads', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('sponsor', 140);
            $table->string('headline', 190);
            $table->string('placement', 100);
            $table->string('impressions', 40)->default('0');
            $table->string('clicks', 40)->default('0');
            $table->string('ctr', 20)->default('0%');
            $table->unsignedBigInteger('revenue_lkr')->default(0);
            $table->boolean('is_active')->default(true)->index();
            $table->timestamps();

            $table->index(['tenant_id', 'is_active', 'created_at']);
        });

        Schema::create('buyer_inquiries', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('seller_id', 64)->default('seller_jdm')->index();
            $table->string('buyer_name', 120);
            $table->string('vehicle', 140);
            $table->string('part_title', 160);
            $table->unsignedBigInteger('offer_lkr')->default(0);
            $table->string('status', 40)->default('New Inquiry')->index();
            $table->string('time_label', 40)->default('Just now');
            $table->json('messages')->nullable();
            $table->timestamps();

            $table->index(['tenant_id', 'seller_id', 'created_at']);
        });

        Schema::create('workshop_bookings', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('customer_name', 120);
            $table->string('vehicle', 140);
            $table->string('service', 190);
            $table->string('slot_date', 60);
            $table->unsignedBigInteger('estimate_lkr')->default(0);
            $table->string('status', 40)->default('Pending')->index();
            $table->timestamps();

            $table->index(['tenant_id', 'status', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workshop_bookings');
        Schema::dropIfExists('buyer_inquiries');
        Schema::dropIfExists('sponsored_ads');
        Schema::dropIfExists('seller_applications');

        Schema::table('part_listings', function (Blueprint $table): void {
            $table->dropColumn(['seller_id', 'sku', 'fitment', 'stock', 'views_count', 'inquiries_count']);
        });
    }
};
