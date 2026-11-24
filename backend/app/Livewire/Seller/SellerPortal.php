<?php

declare(strict_types=1);

namespace App\Livewire\Seller;

use App\Domains\Marketplace\Actions\ModeratePartListingAction;
use App\Domains\Marketplace\Actions\PublishPartListingAction;
use App\Domains\Marketplace\Actions\ReplyBuyerInquiryAction;
use App\Domains\Marketplace\DTOs\CreatePartListingData;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Tenancy\Models\Tenant;
use App\Domains\Workshops\Actions\ManageWorkshopBookingAction;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

#[Layout('components.layouts.app')]
final class SellerPortal extends Component
{
    #[Url]
    public string $sellerTab = 'dashboard'; // 'dashboard' | 'inventory' | 'inquiries' | 'workshop' | 'verification'

    // Toast Notification System
    public ?string $toastTitle = null;

    public ?string $toastMessage = null;

    public string $toastType = 'success';

    // Add Part Modal
    public bool $showAddPartModal = false;

    public string $newPartTitle = '';

    public string $newPartBrand = 'Honda';

    public string $newPartFitment = 'Civic FD2 / K20A';

    public string $newPartCondition = 'JDM Recond';

    public string $newPartPrice = '125000';

    public string $newPartStock = '2';

    // Edit Part Modal
    public bool $showPartDetailsModal = false;

    public ?int $inspectingPartId = null;

    public string $editPartPrice = '';

    public string $editPartStock = '';

    // Buyer Chat State
    public int $activeInquiryId = 0;

    public string $sellerReplyText = '';

    // Storefront Profile Fields
    public string $sellerShopPhone = '';

    public string $sellerShopAddress = '';

    public string $sellerCourierOption = 'Colombo Store Pickup + Islandwide PromptX Courier';

    public string $sellerSpecialty = '';

    public function mount(): void
    {
        /** @var User|null $user */
        $user = Auth::user();
        if ($user === null) {
            return;
        }

        $app = $user->sellerApplication;
        $this->sellerShopPhone = $app->phone ?? ($user->mobile_number ?? '+94 11 250 8899');
        $this->sellerShopAddress = $app->location ?? $user->city;
        $this->sellerSpecialty = $app->specialty ?? 'JDM & Performance Parts';

        if ($app !== null && $app->status !== 'Verified') {
            $this->sellerTab = 'verification';
        }
    }

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

    public function setSellerTab(string $tab): void
    {
        $this->sellerTab = $tab;
    }

    public function setActiveInquiry(int $id): void
    {
        $this->activeInquiryId = $id;
        $this->sellerTab = 'inquiries';
    }

    public function addSellerPart(PublishPartListingAction $publishAction): void
    {
        /** @var User|null $user */
        $user = Auth::user();
        if ($user === null) {
            return;
        }

        $app = $user->sellerApplication;
        if ($app !== null && $app->status !== 'Verified') {
            $this->notify('Verification Required', 'Your shop BR must be verified by Super Admin before publishing parts.', 'warning');
            $this->showAddPartModal = false;

            return;
        }

        $validated = $this->validate([
            'newPartTitle' => ['required', 'string', 'max:160'],
            'newPartBrand' => ['required', 'string', 'max:80'],
            'newPartFitment' => ['required', 'string', 'max:160'],
            'newPartCondition' => ['required', 'string', 'max:60'],
            'newPartPrice' => ['required', 'numeric', 'min:100'],
            'newPartStock' => ['required', 'integer', 'min:1'],
        ]);

        $sku = 'AG-'.strtoupper(substr($validated['newPartBrand'], 0, 3)).'-'.random_int(100, 999);
        $shopName = $app->business_name ?? $user->name;
        $location = $app->location ?? $user->city;

        $publishAction->execute(new CreatePartListingData(
            userId: $user->id,
            tenantId: $user->tenant_id,
            brand: $validated['newPartBrand'],
            title: $validated['newPartTitle'],
            subtitle: $validated['newPartFitment'],
            watermark: strtoupper(substr($validated['newPartBrand'], 0, 4)),
            illustration: 'turbo',
            priceLkr: (int) $validated['newPartPrice'],
            condition: $validated['newPartCondition'],
            trustBadges: ['Verified Seller', 'Hologram Inspected'],
            sellerName: $shopName,
            location: $location,
            rating: '4.95',
            isVerified: true,
            specs: [['label' => $validated['newPartFitment']]],
            description: $validated['newPartTitle'].' listed directly via Merchant Hub.',
            status: 'Pending Review',
            sku: $sku,
            fitment: $validated['newPartFitment'],
            stock: (int) $validated['newPartStock'],
            sellerId: 'seller_'.$user->id,
        ));

        $this->reset(['newPartTitle', 'newPartFitment']);
        $this->showAddPartModal = false;
        $this->notify('Part Listed', "{$validated['newPartTitle']} ({$sku}) submitted for Super Admin moderation.", 'info');
    }

    public function inspectPart(int $id): void
    {
        $userId = (int) Auth::id();
        $listing = PartListing::query()->where('user_id', $userId)->find($id);
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
        $userId = (int) Auth::id();
        if ($this->inspectingPartId !== null) {
            $listing = PartListing::query()->where('user_id', $userId)->find($this->inspectingPartId);
            if ($listing !== null) {
                $moderateAction->updateInventory($listing, (int) $this->editPartPrice, (int) $this->editPartStock);
                $this->notify('Listing Updated', "{$listing->title} price and stock saved.", 'success');
                $this->closePartModal();
            }
        }
    }

    public function sendSellerReply(ReplyBuyerInquiryAction $replyAction): void
    {
        if (trim($this->sellerReplyText) === '') {
            return;
        }

        $userId = (int) Auth::id();
        $inquiry = BuyerInquiry::query()->where('seller_user_id', $userId)->find($this->activeInquiryId);
        if ($inquiry !== null) {
            $replyAction->execute($inquiry, 'seller', $this->sellerReplyText, 'Replied', $userId);
            $this->notify('Message Sent', "Your response was delivered to {$inquiry->buyer_name}.", 'success');
        }

        $this->sellerReplyText = '';
    }

    public function simulateInboundBuyerMessage(ReplyBuyerInquiryAction $replyAction): void
    {
        $userId = (int) Auth::id();
        $inquiry = BuyerInquiry::query()->where('seller_user_id', $userId)->find($this->activeInquiryId);
        if ($inquiry !== null) {
            $sampleBuyerReplies = [
                'Can you do LKR '.number_format(max(10000, $inquiry->offer_lkr - 5000)).' if I collect from your garage today?',
                'Does this fit the facelift FD2 bumper or need custom bracket modification?',
                'Can you courier this to Kandy via PromptX? I will transfer the cash upfront.',
                'Is this the genuine Japanese version with the original security hologram?',
            ];

            $picked = $sampleBuyerReplies[array_rand($sampleBuyerReplies)];
            $replyAction->execute($inquiry, 'buyer', $picked, 'Offer Received');
            $this->notify('Incoming Buyer Offer', "{$inquiry->buyer_name} sent a new negotiation message!", 'info');
        }
    }

    public function confirmWorkshopSlot(int $id, ManageWorkshopBookingAction $bookingAction): void
    {
        $userId = (int) Auth::id();
        $booking = WorkshopBooking::query()->where('seller_user_id', $userId)->find($id);
        if ($booking !== null) {
            $bookingAction->transitionStatus($booking, 'Confirmed');
            $this->notify('Bay Confirmed', "Workshop bay booked for {$booking->customer_name} ({$booking->vehicle}).", 'success');
        }
    }

    public function completeWorkshopBooking(int $id, ManageWorkshopBookingAction $bookingAction): void
    {
        $userId = (int) Auth::id();
        $booking = WorkshopBooking::query()->where('seller_user_id', $userId)->find($id);
        if ($booking !== null) {
            $bookingAction->transitionStatus($booking, 'Completed');
            $this->notify('Service Completed', "Service completed for {$booking->customer_name}.", 'success');
        }
    }

    public function updateSellerProfile(): void
    {
        $validated = $this->validate([
            'sellerShopPhone' => ['required', 'string', 'max:40'],
            'sellerShopAddress' => ['required', 'string', 'max:180'],
            'sellerCourierOption' => ['required', 'string', 'max:180'],
            'sellerSpecialty' => ['required', 'string', 'max:180'],
        ]);

        /** @var User|null $user */
        $user = Auth::user();
        if ($user !== null && $user->sellerApplication !== null) {
            $user->sellerApplication->update([
                'phone' => $validated['sellerShopPhone'],
                'location' => $validated['sellerShopAddress'],
                'specialty' => $validated['sellerSpecialty'],
            ]);
        }

        $this->notify('Storefront Updated', 'Business contacts, location, and specialty saved to database.', 'success');
    }

    public function render(): View
    {
        /** @var User $user */
        $user = Auth::user();
        $tenant = Tenant::query()->first();
        $application = $user->sellerApplication;
        $isVerifiedMerchant = $application === null || $application->status === 'Verified';

        $sellerListings = PartListing::query()
            ->where('user_id', $user->id)
            ->latest('id')
            ->get();

        $inquiries = BuyerInquiry::query()
            ->with('messages')
            ->where('seller_user_id', $user->id)
            ->latest('id')
            ->get();

        $bookings = WorkshopBooking::query()
            ->where('seller_user_id', $user->id)
            ->latest('id')
            ->get();

        $firstInquiry = $inquiries->first();
        if ($this->activeInquiryId === 0 && $firstInquiry !== null) {
            $this->activeInquiryId = (int) $firstInquiry->id;
        }

        $activeInquiry = $inquiries->firstWhere('id', $this->activeInquiryId) ?? $firstInquiry;

        $inspectingPart = $this->inspectingPartId !== null
            ? $sellerListings->firstWhere('id', $this->inspectingPartId)
            : null;

        return view('livewire.seller.seller-portal', [
            'currentUser' => $user,
            'tenant' => $tenant,
            'application' => $application,
            'isVerifiedMerchant' => $isVerifiedMerchant,
            'sellerListings' => $sellerListings,
            'inquiries' => $inquiries,
            'activeInquiry' => $activeInquiry,
            'bookings' => $bookings,
            'inspectingPart' => $inspectingPart,
        ]);
    }
}
