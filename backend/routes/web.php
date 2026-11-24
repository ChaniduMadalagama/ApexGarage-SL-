<?php

declare(strict_types=1);

use App\Livewire\Admin\AdminPortal;
use App\Livewire\Auth\LoginGate;
use App\Livewire\Seller\SellerPortal;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

Route::get('/', function (): RedirectResponse {
    if (! Auth::check()) {
        return redirect()->route('login');
    }

    /** @var User $user */
    $user = Auth::user();

    if ($user->hasRole('super-admin')) {
        return redirect()->route('admin.portal');
    }

    if ($user->hasRole('workshop-partner')) {
        return redirect()->route('seller.portal');
    }

    return redirect()->route('login');
})->name('home');

Route::get('/login', LoginGate::class)->name('login');

Route::middleware(['auth', 'role:super-admin'])->group(function (): void {
    Route::get('/admin', AdminPortal::class)->name('admin.portal');
});

Route::middleware(['auth', 'role:workshop-partner'])->group(function (): void {
    Route::get('/seller', SellerPortal::class)->name('seller.portal');
});

Route::post('/logout', function (Request $request): RedirectResponse {
    Auth::logout();
    $request->session()->invalidate();
    $request->session()->regenerateToken();

    return redirect()->route('login');
})->middleware('auth')->name('logout');
