<?php

declare(strict_types=1);

namespace App\Livewire\Admin;

use App\Contracts\DashboardMetricsServiceInterface;
use App\Domains\Advertising\Actions\ManageSponsoredAdAction;
use App\Domains\Advertising\DTOs\CreateSponsoredAdData;
use App\Domains\Advertising\Models\SponsoredAd;
use App\Domains\Community\Models\MeetEvent;
use App\Domains\Garage\Models\Vehicle;
use App\Domains\Marketplace\Actions\ModeratePartListingAction;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Subscriptions\Actions\ActivateIdeaBizSubscriptionAction;
use App\Domains\Subscriptions\DTOs\SubscribeIdeaBizData;
use App\Domains\Subscriptions\Models\Subscription;
use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Vetting\Actions\ReviewSellerApplicationAction;
use App\Domains\Vetting\Models\SellerApplication;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

#[Layout('components.layouts.app')]
final class AdminPortal extends Component
{
    #[Url]
    public string $adminTab = 'overview'; // 'overview' | 'vetting' | 'marketplace' | 'ideabiz' | 'ads' | 'community'

    public string $adminSearch = '';

    public string $listingStatusFilter = 'All';

    // Toast Notification System
    public ?string $toastTitle = null;

    public ?string $toastMessage = null;

    public string $toastType = 'success';

    // Document Inspection Modal
    public bool $showDocModal = false;

    public ?int $inspectingApplicationId = null;

    public string $rejectionReason = '';

    // Part Details & Edit Modal
    public bool $showPartDetailsModal = false;

    public ?int $inspectingPartId = null;

    public string $editPartPrice = '';

    public string $editPartStock = '';

    // Sponsored Ad Creation Modal
    public bool $showCreateAdModal = false;

    public string $newAdSponsor = '';

    public string $newAdHeadline = '';

    public string $newAdPlacement = 'Mobile Home Hero Carousel';

    public string $newAdRevenue = '65000';

    public function notify(string $title, string $message, string $type = 'success'): void
    {
        $this->toastTitle = $title;
        $this->toastMessage = $message;
        $this->toastType = $type;
    }

    public function dismissToast(): void
    {
        $this->toastTitle = null;
        $this->toastMessage = null;
    }

    public function logout(): void
    {
        Auth::logout();
        request()->session()->invalidate();
        request()->session()->regenerateToken();

        $this->redirectRoute('login');
    }

    public function setAdminTab(string $tab): void
    {
        $this->adminTab = $tab;
    }

    public function setListingStatusFilter(string $status): void
    {
        $this->listingStatusFilter = $status;
    }

    public function inspectApplication(int $id): void
    {
        $this->inspectingApplicationId = $id;
        $this->rejectionReason = '';
        $this->showDocModal = true;
    }

    public function closeDocModal(): void
    {
        $this->showDocModal = false;
        $this->inspectingApplicationId = null;
        $this->rejectionReason = '';
    }

    public function approveFromModal(ReviewSellerApplicationAction $reviewAction): void
    {
        if ($this->inspectingApplicationId !== null) {
            $this->verifyApplication($this->inspectingApplicationId, 'Verified', $reviewAction);
            $this->closeDocModal();
        }
    }

    public function rejectFromModal(ReviewSellerApplicationAction $reviewAction): void
    {
        if ($this->inspectingApplicationId !== null) {
            $reason = trim($this->rejectionReason) !== '' ? trim($this->rejectionReason) : 'BR documentation requires resubmission.';
            $this->verifyApplication($this->inspectingApplicationId, 'Rejected', $reviewAction, $reason);
            $this->closeDocModal();
        }
    }

    public function verifyApplication(
        int $id,
        string $newStatus,
        ReviewSellerApplicationAction $reviewAction,
        ?string $reason = null,
    ): void {
        $app = SellerApplication::query()->find($id);
        $reviewerId = (int) Auth::id();

        if ($app !== null && $reviewerId > 0) {
            $reviewAction->execute($app, $newStatus, $reviewerId, $reason);
            if ($newStatus === 'Verified') {
                $this->notify('Merchant Verified', "{$app->business_name} granted Verified Seller & Workshop badge.", 'success');
            } else {
                $this->notify('Application Rejected', "{$app->business_name} application marked as rejected.", 'warning');
            }
        }
    }

    public function moderateListing(int $id, string $newStatus, ModeratePartListingAction $moderateAction): void
    {
        $listing = PartListing::query()->find($id);
        if ($listing !== null) {
            $moderateAction->updateStatus($listing, $newStatus);
            if ($newStatus === 'Approved') {
                $this->notify('Listing Approved', "{$listing->title} is now active on the mobile marketplace.", 'success');
            } else {
                $this->notify('Listing Moderated', "{$listing->title} marked as {$newStatus}.", 'warning');
            }
        }
    }

    public function inspectPart(int $id): void
    {
        $listing = PartListing::query()->find($id);
        if ($listing !== null) {
            $this->inspectingPartId = $id;
            $this->editPartPrice = (string) $listing->price_lkr;
            $this->editPartStock = (string) $listing->stock;
            $this->showPartDetailsModal = true;
        }
    }

    public function closePartModal(): void
    {
        $this->showPartDetailsModal = false;
        $this->inspectingPartId = null;
    }

    public function savePartEdits(ModeratePartListingAction $moderateAction): void
    {
        if ($this->inspectingPartId !== null) {
            $listing = PartListing::query()->find($this->inspectingPartId);
            if ($listing !== null) {
                $moderateAction->updateInventory($listing, (int) $this->editPartPrice, (int) $this->editPartStock);
                $this->notify('Listing Updated', "{$listing->title} price and stock saved successfully.", 'success');
                $this->closePartModal();
            }
        }
    }

    public function toggleAd(int $id, ManageSponsoredAdAction $adAction): void
    {
        $ad = SponsoredAd::query()->find($id);
        if ($ad !== null) {
            $updated = $adAction->toggle($ad);
            $statusLabel = $updated->is_active ? 'activated in mobile feed' : 'paused';
            $this->notify('Ad Campaign Toggled', "{$updated->sponsor} campaign is now {$statusLabel}.", $updated->is_active ? 'success' : 'info');
        }
    }

    public function openCreateAdModal(): void
    {
        $this->newAdSponsor = '';
        $this->newAdHeadline = '';
        $this->newAdPlacement = 'Mobile Home Hero Carousel';
        $this->newAdRevenue = '65000';
        $this->showCreateAdModal = true;
    }

    public function closeCreateAdModal(): void
    {
        $this->showCreateAdModal = false;
    }

    public function createSponsoredAd(ManageSponsoredAdAction $adAction): void
    {
        $validated = $this->validate([
            'newAdSponsor' => ['required', 'string', 'max:140'],
            'newAdHeadline' => ['required', 'string', 'max:190'],
            'newAdPlacement' => ['required', 'string', 'max:100'],
            'newAdRevenue' => ['required', 'numeric', 'min:5000'],
        ]);

        $tenant = Tenant::query()->first();

        $adAction->create(new CreateSponsoredAdData(
            tenantId: $tenant?->id,
            sponsor: $validated['newAdSponsor'],
            headline: $validated['newAdHeadline'],
            placement: $validated['newAdPlacement'],
            revenueLkr: (int) $validated['newAdRevenue'],
        ));

        $this->showCreateAdModal = false;
        $this->notify('Campaign Created', "Sponsored slot for {$validated['newAdSponsor']} launched in mobile app.", 'success');
    }

    public function simulateIdeaBizBilling(
        ActivateIdeaBizSubscriptionAction $subscribeAction,
        DashboardMetricsServiceInterface $metricsService,
    ): void {
        $tenant = Tenant::query()->first();
        $user = Auth::user() ?? User::query()->first();
        if ($user === null) {
            return;
        }

        $randomPhone = '+9477'.random_int(2000000, 9999999);
        $subscription = $subscribeAction->execute(new SubscribeIdeaBizData(
            userId: (int) $user->id,
            tenantId: $tenant?->id,
            mobileNumber: $randomPhone,
            planCode: 'PRO_MONTHLY',
        ));

        $metricsService->invalidateMetricsCache();
        $this->notify('IdeaBiz Webhook Executed', "Charged {$randomPhone} via Telco Gateway. Ref: {$subscription->reference_id}. MRR updated.", 'success');
    }

    public function refreshTelemetry(DashboardMetricsServiceInterface $metricsService): void
    {
        $metricsService->invalidateMetricsCache();
        $this->notify('Redis Cache Purged', 'Real-time database analytics reloaded.', 'info');
    }

    public function render(DashboardMetricsServiceInterface $metricsService): View
    {
        $tenant = Tenant::query()->first();
        $metrics = $metricsService->getOverviewMetrics($tenant?->id);

        $applications = SellerApplication::query()->latest('id')->get();
        $pendingApplicationsCount = $applications->where('status', 'Pending')->count();

        $listingsQuery = PartListing::query()->latest('id');
        if ($this->listingStatusFilter !== 'All') {
            $listingsQuery->where('status', $this->listingStatusFilter);
        }
        if (trim($this->adminSearch) !== '') {
            $term = '%'.trim($this->adminSearch).'%';
            $listingsQuery->where(function ($q) use ($term): void {
                $q->where('title', 'like', $term)
                    ->orWhere('brand', 'like', $term)
                    ->orWhere('seller_name', 'like', $term)
                    ->orWhere('fitment', 'like', $term);
            });
        }
        $listings = $listingsQuery->get();

        $ads = SponsoredAd::query()->latest('id')->get();
        $transactions = Subscription::query()->latest('id')->get();

        $inspectingApp = $this->inspectingApplicationId !== null
            ? $applications->firstWhere('id', $this->inspectingApplicationId)
            : null;

        $inspectingPart = $this->inspectingPartId !== null
            ? PartListing::query()->find($this->inspectingPartId)
            : null;

        /** @var Collection<int, Vehicle> $vehicles */
        $vehicles = Vehicle::query()->with(['owner', 'buildLogs', 'serviceRecords'])->latest('id')->get();
        /** @var Collection<int, MeetEvent> $meets */
        $meets = MeetEvent::query()->latest('id')->get();

        $revenueSeries = [
            ['month' => 'Jun', 'ideabiz' => 68000, 'ads' => 45000],
            ['month' => 'Jul', 'ideabiz' => 94000, 'ads' => 60000],
            ['month' => 'Aug', 'ideabiz' => 128000, 'ads' => 85000],
            ['month' => 'Sep', 'ideabiz' => 164000, 'ads' => 110000],
            ['month' => 'Oct', 'ideabiz' => 212000, 'ads' => 135000],
            ['month' => 'Nov', 'ideabiz' => 268500, 'ads' => 150000],
        ];

        return view('livewire.admin.admin-portal', [
            'currentUser' => Auth::user(),
            'tenant' => $tenant,
            'metrics' => $metrics,
            'applications' => $applications,
            'pendingApplicationsCount' => $pendingApplicationsCount,
            'inspectingApp' => $inspectingApp,
            'inspectingPart' => $inspectingPart,
            'listings' => $listings,
            'ads' => $ads,
            'transactions' => $transactions,
            'vehicles' => $vehicles,
            'meets' => $meets,
            'revenueSeries' => $revenueSeries,
        ]);
    }
}
