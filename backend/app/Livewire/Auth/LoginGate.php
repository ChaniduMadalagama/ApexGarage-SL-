<?php

declare(strict_types=1);

namespace App\Livewire\Auth;

use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Vetting\Actions\RegisterMerchantAction;
use App\Domains\Vetting\DTOs\RegisterMerchantData;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Validation\ValidationException;
use Livewire\Attributes\Layout;
use Livewire\Component;

#[Layout('components.layouts.app')]
final class LoginGate extends Component
{
    public string $loginRoleTab = 'admin'; // 'admin' | 'seller'

    public string $portalMode = 'login'; // 'login' | 'register'

    public string $email = '';

    public string $password = '';

    public bool $remember = false;

    // Merchant Registration Fields
    public string $regShopName = '';

    public string $regOwnerName = '';

    public string $regEmail = '';

    public string $regPassword = '';

    public string $regPhone = '+94 77 ';

    public string $regBrNumber = '';

    public string $regLocation = 'Colombo 05';

    public string $regShopType = 'JDM Parts Importer';

    public function mount(): void
    {
        if (Auth::check()) {
            /** @var User $user */
            $user = Auth::user();
            if ($user->hasRole('super-admin')) {
                $this->redirectRoute('admin.portal');

                return;
            }
            if ($user->hasRole('workshop-partner')) {
                $this->redirectRoute('seller.portal');

                return;
            }
        }
    }

    public function selectLoginTab(string $role): void
    {
        $this->loginRoleTab = $role;
        $this->portalMode = 'login';
        $this->resetValidation();
    }

    public function togglePortalMode(string $mode): void
    {
        $this->portalMode = $mode;
        $this->resetValidation();
    }

    public function fillDemoCredentials(string $role): void
    {
        $this->loginRoleTab = $role;
        $this->portalMode = 'login';
        $this->email = $role === 'admin' ? 'admin@apexgarage.lk' : 'sales@jdmdirect.lk';
        $this->password = 'password';
        $this->resetValidation();
    }

    /**
     * TODO(remove-for-prod): Quick-fill seeded test accounts for QA.
     */
    public function fillTestAccount(string $roleTab, string $email): void
    {
        $this->loginRoleTab = $roleTab;
        $this->portalMode = 'login';
        $this->email = $email;
        $this->password = 'password';
        $this->resetValidation();
    }

    public function authenticate(): void
    {
        $this->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $throttleKey = strtolower($this->email).'|'.request()->ip();

        if (RateLimiter::tooManyAttempts($throttleKey, 5)) {
            $seconds = RateLimiter::availableIn($throttleKey);
            throw ValidationException::withMessages([
                'email' => "Too many login attempts. Please try again in {$seconds} seconds.",
            ]);
        }

        if (! Auth::attempt(['email' => $this->email, 'password' => $this->password], $this->remember)) {
            RateLimiter::hit($throttleKey, 60);

            throw ValidationException::withMessages([
                'email' => 'Invalid email or password.',
            ]);
        }

        RateLimiter::clear($throttleKey);

        /** @var User $user */
        $user = Auth::user();

        if ($this->loginRoleTab === 'admin' && ! $user->hasRole('super-admin')) {
            Auth::logout();
            throw ValidationException::withMessages([
                'email' => 'This account does not have Super Admin privileges. Please use the Shop / Part Seller tab.',
            ]);
        }

        if ($this->loginRoleTab === 'seller' && ! $user->hasRole('workshop-partner')) {
            Auth::logout();
            throw ValidationException::withMessages([
                'email' => 'This account is not registered as a Merchant or Workshop Partner.',
            ]);
        }

        if (request()->hasSession()) {
            request()->session()->regenerate();
        }

        if ($user->hasRole('super-admin')) {
            $this->redirectRoute('admin.portal');

            return;
        }

        $this->redirectRoute('seller.portal');
    }

    public function registerMerchant(RegisterMerchantAction $registerAction): void
    {
        $validated = $this->validate([
            'regShopName' => ['required', 'string', 'max:120'],
            'regOwnerName' => ['required', 'string', 'max:120'],
            'regEmail' => ['required', 'email', 'max:160', 'unique:users,email'],
            'regPassword' => ['required', 'string', 'min:8'],
            'regPhone' => ['required', 'string', 'max:32'],
            'regBrNumber' => ['required', 'string', 'max:60'],
            'regLocation' => ['required', 'string', 'max:120'],
            'regShopType' => ['required', 'string', 'max:80'],
        ]);

        $tenant = Tenant::query()->first();

        $application = $registerAction->execute(new RegisterMerchantData(
            tenantId: $tenant?->id,
            shopName: $validated['regShopName'],
            ownerName: $validated['regOwnerName'],
            email: $validated['regEmail'],
            password: $validated['regPassword'],
            phone: $validated['regPhone'],
            brNumber: $validated['regBrNumber'],
            location: $validated['regLocation'],
            shopType: $validated['regShopType'],
        ));

        if ($application->user !== null) {
            Auth::login($application->user);
            if (request()->hasSession()) {
                request()->session()->regenerate();
            }
        }

        $this->redirectRoute('seller.portal');
    }

    public function render(): View
    {
        return view('livewire.auth.login-gate', [
            'tenant' => Tenant::query()->first(),
        ]);
    }
}
