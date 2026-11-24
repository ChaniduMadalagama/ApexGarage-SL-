<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('seller_applications', function (Blueprint $table): void {
            $table->foreignId('user_id')->nullable()->after('tenant_id')->constrained('users')->nullOnDelete();
            $table->foreignId('reviewed_by')->nullable()->after('status')->constrained('users')->nullOnDelete();
            $table->timestamp('reviewed_at')->nullable()->after('reviewed_by');
            $table->string('rejection_reason', 255)->nullable()->after('reviewed_at');
        });

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->foreignId('seller_user_id')->nullable()->after('tenant_id')->constrained('users')->nullOnDelete();
        });

        Schema::table('workshop_bookings', function (Blueprint $table): void {
            $table->foreignId('seller_user_id')->nullable()->after('tenant_id')->constrained('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('workshop_bookings', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('seller_user_id');
        });

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('seller_user_id');
        });

        Schema::table('seller_applications', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('reviewed_by');
            $table->dropConstrainedForeignId('user_id');
            $table->dropColumn(['reviewed_at', 'rejection_reason']);
        });
    }
};
