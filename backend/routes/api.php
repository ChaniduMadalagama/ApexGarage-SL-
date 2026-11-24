<?php

declare(strict_types=1);

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\CrewController;
use App\Http\Controllers\Api\V1\FeedController;
use App\Http\Controllers\Api\V1\GarageController;
use App\Http\Controllers\Api\V1\HomeDashboardController;
use App\Http\Controllers\Api\V1\MarketplaceController;
use App\Http\Controllers\Api\V1\MechanicController;
use App\Http\Controllers\Api\V1\MediaController;
use App\Http\Controllers\Api\V1\MeetController;
use App\Http\Controllers\Api\V1\PromotionController;
use App\Http\Controllers\Api\V1\SellerController;
use App\Http\Controllers\Api\V1\SubscriptionController;
use App\Http\Controllers\Api\V1\UserController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    // Public / Guest read endpoints (strictly scoped to default tenant)
    Route::middleware('throttle:api')->group(function (): void {
        Route::get('/marketplace/parts', [MarketplaceController::class, 'index'])->name('api.v1.parts.index');
        Route::get('/marketplace/parts/histogram', [MarketplaceController::class, 'histogram'])->name('api.v1.parts.histogram');
        Route::get('/marketplace/parts/{part}', [MarketplaceController::class, 'show'])->name('api.v1.parts.show');

        Route::get('/mechanics', [MechanicController::class, 'index'])->name('api.v1.mechanics.index');
        Route::get('/mechanics/{workshop}/slots', [MechanicController::class, 'slots'])->name('api.v1.mechanics.slots');

        Route::get('/meets', [MeetController::class, 'index'])->name('api.v1.meets.index');
        Route::get('/crews', [CrewController::class, 'index'])->name('api.v1.crews.index');
        Route::get('/feed', [FeedController::class, 'index'])->name('api.v1.feed.index');
        Route::get('/feed/{post}/comments', [FeedController::class, 'commentsIndex'])->name('api.v1.feed.comments.index');
        Route::get('/promotions/active', [PromotionController::class, 'active'])->name('api.v1.promotions.active');
    });

    // Authentication endpoints
    Route::middleware('throttle:auth')->group(function (): void {
        Route::post('/auth/login', [AuthController::class, 'login'])->name('api.v1.auth.login');
    });

    Route::middleware('throttle:register')->group(function (): void {
        Route::post('/auth/register', [AuthController::class, 'register'])->name('api.v1.auth.register');
    });

    // Authenticated Sanctum API endpoints
    Route::middleware(['auth:sanctum', 'throttle:api'])->group(function (): void {
        Route::post('/auth/logout', [AuthController::class, 'logout'])->name('api.v1.auth.logout');
        Route::get('/auth/me', [AuthController::class, 'me'])->name('api.v1.auth.me');

        // User Profile & Onboarding
        Route::get('/user/profile', [UserController::class, 'profile'])->name('api.v1.user.profile');
        Route::patch('/user/onboarding', [UserController::class, 'updateOnboarding'])->name('api.v1.user.onboarding');
        Route::patch('/user/active-vehicle', [UserController::class, 'setActiveVehicle'])->name('api.v1.user.active_vehicle');

        // Home Dashboard
        Route::get('/home', [HomeDashboardController::class, 'index'])->name('api.v1.home');

        // Digital Garage (strictly user-scoped + VehiclePolicy)
        Route::get('/vehicles', [GarageController::class, 'index'])->name('api.v1.vehicles.index');
        Route::get('/vehicles/{vehicle}', [GarageController::class, 'show'])->name('api.v1.vehicles.show');
        Route::post('/vehicles', [GarageController::class, 'store'])
            ->middleware('throttle:writes')
            ->name('api.v1.vehicles.store');
        Route::post('/vehicles/{vehicle}/build-logs', [GarageController::class, 'storeBuildLog'])
            ->middleware('throttle:writes')
            ->name('api.v1.vehicles.build_logs.store');
        Route::post('/vehicles/{vehicle}/service-records', [GarageController::class, 'storeServiceRecord'])
            ->middleware('throttle:writes')
            ->name('api.v1.vehicles.service_records.store');

        // Media Upload
        Route::post('/media/upload', [MediaController::class, 'store'])
            ->middleware('throttle:uploads')
            ->name('api.v1.media.upload');

        // Marketplace Actions & Seller Chat
        Route::post('/marketplace/parts', [MarketplaceController::class, 'store'])
            ->middleware('throttle:writes')
            ->name('api.v1.parts.store');
        Route::put('/marketplace/parts/{part}/save', [MarketplaceController::class, 'save'])
            ->middleware('throttle:writes')
            ->name('api.v1.parts.save');
        Route::post('/marketplace/parts/{part}/reserve', [MarketplaceController::class, 'reserve'])
            ->middleware('throttle:writes')
            ->name('api.v1.parts.reserve');
        Route::get('/marketplace/parts/{part}/chat', [MarketplaceController::class, 'chatIndex'])
            ->name('api.v1.parts.chat.index');
        Route::post('/marketplace/parts/{part}/chat', [MarketplaceController::class, 'chatStore'])
            ->middleware('throttle:chat')
            ->name('api.v1.parts.chat.store');

        // Mechanics & Workshop Booking
        Route::post('/mechanics/{workshop}/book', [MechanicController::class, 'book'])
            ->middleware('throttle:writes')
            ->name('api.v1.mechanics.book');

        // Meets, Crews & Feed Interactions
        Route::post('/meets', [MeetController::class, 'store'])
            ->middleware('throttle:meet-host')
            ->name('api.v1.meets.store');
        Route::put('/meets/{meet}/rsvp', [MeetController::class, 'rsvp'])
            ->middleware('throttle:writes')
            ->name('api.v1.meets.rsvp');
        Route::put('/crews/{crew}/membership', [CrewController::class, 'membership'])
            ->middleware('throttle:writes')
            ->name('api.v1.crews.membership');
        Route::post('/crews', [CrewController::class, 'store'])
            ->middleware('throttle:writes')
            ->name('api.v1.crews.store');
        Route::get('/crews/live', [CrewController::class, 'liveIndex'])
            ->name('api.v1.crews.live.index');
        Route::put('/crews/live', [CrewController::class, 'liveUpdate'])
            ->middleware('throttle:writes')
            ->name('api.v1.crews.live.update');
        Route::put('/feed/{post}/like', [FeedController::class, 'like'])
            ->middleware('throttle:writes')
            ->name('api.v1.feed.like');
        Route::post('/feed/{post}/comments', [FeedController::class, 'commentsStore'])
            ->middleware('throttle:chat')
            ->name('api.v1.feed.comments.store');

        // Shop Owner / Seller Mobile Endpoints
        Route::prefix('/seller')->group(function (): void {
            Route::get('/dashboard', [SellerController::class, 'dashboard'])->name('api.v1.seller.dashboard');
            Route::patch('/parts/{part}', [SellerController::class, 'updatePart'])
                ->middleware('throttle:writes')
                ->name('api.v1.seller.parts.update');
            Route::post('/inquiries/{inquiry}/reply', [SellerController::class, 'replyInquiry'])
                ->middleware('throttle:chat')
                ->name('api.v1.seller.inquiries.reply');
            Route::patch('/bookings/{booking}', [SellerController::class, 'updateBooking'])
                ->middleware('throttle:writes')
                ->name('api.v1.seller.bookings.update');
            Route::patch('/profile', [SellerController::class, 'updateProfile'])
                ->middleware('throttle:writes')
                ->name('api.v1.seller.profile.update');
        });

        // Legacy IdeaBiz endpoint (excluded from mobile wiring in this phase)
        Route::post('/subscriptions/ideabiz', [SubscriptionController::class, 'store'])->name('api.v1.subscriptions.store');
    });
});
