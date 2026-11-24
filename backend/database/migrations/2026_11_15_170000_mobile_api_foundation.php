<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            $table->boolean('onboarding_completed')->default(false)->after('is_pro');
            $table->json('cultures')->nullable()->after('onboarding_completed');
            $table->foreignId('active_vehicle_id')->nullable()->after('cultures')->constrained('vehicles')->nullOnDelete();
            $table->unique('mobile_number');
        });

        Schema::table('vehicles', function (Blueprint $table): void {
            $table->index(['user_id', 'category']);
        });

        Schema::table('part_listings', function (Blueprint $table): void {
            $table->index(['status', 'price_lkr']);
            $table->index(['status', 'brand']);
            $table->index(['status', 'created_at']);
        });

        Schema::create('saved_parts', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('part_listing_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['user_id', 'part_listing_id']);
        });

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->foreignId('buyer_user_id')->nullable()->after('seller_user_id')->constrained('users')->nullOnDelete();
            $table->foreignId('part_listing_id')->nullable()->after('buyer_user_id')->constrained('part_listings')->nullOnDelete();
            $table->unique(['buyer_user_id', 'part_listing_id']);
        });

        Schema::create('inquiry_messages', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('buyer_inquiry_id')->constrained('buyer_inquiries')->cascadeOnDelete();
            $table->string('sender_type', 10); // buyer | seller
            $table->foreignId('sender_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->text('body');
            $table->timestamps();

            $table->index(['buyer_inquiry_id', 'id']);
        });

        // Move legacy JSON chat threads into the relational table.
        DB::table('buyer_inquiries')->whereNotNull('messages')->orderBy('id')->each(function (object $row): void {
            $messages = json_decode((string) $row->messages, true);
            if (! is_array($messages)) {
                return;
            }
            foreach ($messages as $message) {
                if (! is_array($message) || ! isset($message['text'])) {
                    continue;
                }
                DB::table('inquiry_messages')->insert([
                    'buyer_inquiry_id' => $row->id,
                    'sender_type' => ($message['from'] ?? 'buyer') === 'seller' ? 'seller' : 'buyer',
                    'sender_user_id' => null,
                    'body' => (string) $message['text'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        });

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->dropColumn('messages');
        });

        Schema::table('workshops', function (Blueprint $table): void {
            $table->foreignId('owner_user_id')->nullable()->after('tenant_id')->constrained('users')->nullOnDelete();
        });

        Schema::table('workshop_bookings', function (Blueprint $table): void {
            $table->foreignId('workshop_id')->nullable()->after('seller_user_id')->constrained('workshops')->nullOnDelete();
            $table->foreignId('user_id')->nullable()->after('workshop_id')->constrained('users')->nullOnDelete();
            $table->string('booking_ref', 24)->nullable()->unique()->after('user_id');
        });

        Schema::table('meet_events', function (Blueprint $table): void {
            $table->foreignId('host_user_id')->nullable()->after('tenant_id')->constrained('users')->nullOnDelete();
            $table->text('description')->nullable()->after('pin_label');
        });

        Schema::create('meet_rsvps', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('meet_event_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['meet_event_id', 'user_id']);
        });

        Schema::create('crews', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('name', 120);
            $table->string('focus', 80);
            $table->text('description');
            $table->string('location', 120);
            $table->unsignedInteger('members_count')->default(0);
            $table->timestamps();

            $table->index(['tenant_id', 'members_count']);
        });

        Schema::create('crew_members', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('crew_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['crew_id', 'user_id']);
        });

        Schema::create('community_posts', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('vehicle_id')->nullable()->constrained('vehicles')->nullOnDelete();
            $table->string('vehicle_title', 160);
            $table->string('mod_title', 190);
            $table->string('workshop', 120)->nullable();
            $table->string('illustration', 40)->default('fd2');
            $table->string('watermark', 16);
            $table->json('tags')->nullable();
            $table->unsignedInteger('likes_count')->default(0);
            $table->unsignedInteger('comments_count')->default(0);
            $table->timestamps();

            $table->index(['tenant_id', 'created_at']);
        });

        Schema::create('community_post_likes', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('community_post_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['community_post_id', 'user_id']);
        });

        Schema::create('promotions', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('tenant_id')->nullable()->constrained('tenants')->nullOnDelete();
            $table->string('partner', 80);
            $table->string('code', 40);
            $table->string('title', 160);
            $table->text('description');
            $table->json('participating_workshops')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamp('starts_at')->nullable();
            $table->timestamp('ends_at')->nullable();
            $table->timestamps();

            $table->index(['tenant_id', 'is_active']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('promotions');
        Schema::dropIfExists('community_post_likes');
        Schema::dropIfExists('community_posts');
        Schema::dropIfExists('crew_members');
        Schema::dropIfExists('crews');
        Schema::dropIfExists('meet_rsvps');

        Schema::table('meet_events', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('host_user_id');
            $table->dropColumn('description');
        });

        Schema::table('workshop_bookings', function (Blueprint $table): void {
            $table->dropColumn('booking_ref');
            $table->dropConstrainedForeignId('user_id');
            $table->dropConstrainedForeignId('workshop_id');
        });

        Schema::table('workshops', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('owner_user_id');
        });

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->json('messages')->nullable();
        });

        Schema::dropIfExists('inquiry_messages');

        Schema::table('buyer_inquiries', function (Blueprint $table): void {
            $table->dropUnique(['buyer_user_id', 'part_listing_id']);
            $table->dropConstrainedForeignId('part_listing_id');
            $table->dropConstrainedForeignId('buyer_user_id');
        });

        Schema::dropIfExists('saved_parts');

        Schema::table('part_listings', function (Blueprint $table): void {
            $table->dropIndex(['status', 'price_lkr']);
            $table->dropIndex(['status', 'brand']);
            $table->dropIndex(['status', 'created_at']);
        });

        Schema::table('vehicles', function (Blueprint $table): void {
            $table->dropIndex(['user_id', 'category']);
        });

        Schema::table('users', function (Blueprint $table): void {
            $table->dropUnique(['mobile_number']);
            $table->dropConstrainedForeignId('active_vehicle_id');
            $table->dropColumn(['onboarding_completed', 'cultures']);
        });
    }
};
