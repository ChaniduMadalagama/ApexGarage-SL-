<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Domains\Marketplace\Actions\ModeratePartListingAction;
use App\Domains\Marketplace\Actions\ReplyBuyerInquiryAction;
use App\Domains\Marketplace\Models\BuyerInquiry;
use App\Domains\Marketplace\Models\PartListing;
use App\Domains\Vetting\Models\SellerApplication;
use App\Domains\Workshops\Actions\ManageWorkshopBookingAction;
use App\Domains\Workshops\Models\WorkshopBooking;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ReplyInquiryRequest;
use App\Http\Requests\Api\UpdateSellerBookingRequest;
use App\Http\Requests\Api\UpdateSellerPartRequest;
use App\Http\Requests\Api\UpdateSellerProfileRequest;
use App\Http\Resources\BookingResource;
use App\Http\Resources\ChatMessageResource;
use App\Http\Resources\PartResource;
use App\Http\Resources\SellerInquiryResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class SellerController extends Controller
{
    public function dashboard(Request $request): JsonResponse
    {
        $user = $this->authorizeSeller($request);

        $application = SellerApplication::query()
            ->where('user_id', $user->id)
            ->latest('id')
            ->first();

        $parts = PartListing::query()
            ->where('user_id', $user->id)
            ->latest('id')
            ->get();

        $inquiries = BuyerInquiry::query()
            ->where('seller_user_id', $user->id)
            ->with(['messages' => fn ($q) => $q->orderBy('id')])
            ->latest('id')
            ->get();

        $bookings = WorkshopBooking::query()
            ->where('seller_user_id', $user->id)
            ->latest('id')
            ->get();

        return response()->json([
            'shop' => $this->formatShop($user, $application),
            'stats' => [
                'listings_count' => $parts->count(),
                'approved_count' => $parts->where('status', 'Approved')->count(),
                'pending_count' => $parts->where('status', 'Pending Review')->count(),
                'total_views' => (int) $parts->sum('views_count'),
                'inquiries_count' => $inquiries->count(),
                'open_inquiries_count' => $inquiries->whereIn('status', ['New Inquiry', 'Reserved (Pickup)'])->count(),
                'bookings_count' => $bookings->count(),
                'pending_bookings_count' => $bookings->where('status', 'Pending')->count(),
            ],
            'parts' => PartResource::collection($parts),
            'inquiries' => SellerInquiryResource::collection($inquiries),
            'bookings' => BookingResource::collection($bookings),
        ]);
    }

    public function updatePart(
        UpdateSellerPartRequest $request,
        PartListing $part,
        ModeratePartListingAction $moderateAction,
    ): JsonResponse {
        $user = $this->authorizeSeller($request);
        abort_unless($part->user_id === $user->id, 403, 'You do not own this listing.');

        $validated = $request->validated();

        $updated = $moderateAction->updateInventory(
            listing: $part,
            priceLkr: (int) $validated['price_lkr'],
            stock: (int) $validated['stock'],
        );

        $extraFields = array_filter([
            'title' => $validated['title'] ?? null,
            'fitment' => $validated['fitment'] ?? null,
            'description' => $validated['description'] ?? null,
        ], static fn (?string $v): bool => $v !== null);

        if ($extraFields !== []) {
            $updated->update($extraFields);
            $updated = $updated->fresh() ?? $updated;
        }

        return response()->json([
            'data' => new PartResource($updated),
        ]);
    }

    public function replyInquiry(
        ReplyInquiryRequest $request,
        BuyerInquiry $inquiry,
        ReplyBuyerInquiryAction $replyAction,
    ): JsonResponse {
        $user = $this->authorizeSeller($request);
        abort_unless($inquiry->seller_user_id === $user->id, 403, 'You do not own this inquiry.');

        $validated = $request->validated();
        $newStatus = (string) ($validated['status'] ?? 'Replied');

        $message = $replyAction->execute(
            inquiry: $inquiry,
            from: 'seller',
            text: (string) $validated['message'],
            newStatus: $newStatus,
            senderUserId: $user->id,
        );

        return response()->json([
            'message' => new ChatMessageResource($message),
            'inquiry_status' => $newStatus,
        ], 201);
    }

    public function updateBooking(
        UpdateSellerBookingRequest $request,
        WorkshopBooking $booking,
        ManageWorkshopBookingAction $bookingAction,
    ): JsonResponse {
        $user = $this->authorizeSeller($request);
        abort_unless($booking->seller_user_id === $user->id, 403, 'You do not own this booking.');

        $updated = $bookingAction->transitionStatus(
            booking: $booking,
            status: (string) $request->validated('status'),
        );

        return response()->json([
            'data' => new BookingResource($updated),
        ]);
    }

    public function updateProfile(UpdateSellerProfileRequest $request): JsonResponse
    {
        $user = $this->authorizeSeller($request);
        $validated = $request->validated();

        $application = DB::transaction(function () use ($user, $validated): SellerApplication {
            $application = SellerApplication::query()
                ->where('user_id', $user->id)
                ->latest('id')
                ->first();

            if ($application !== null) {
                $application->update([
                    'business_name' => (string) $validated['business_name'],
                    'location' => (string) $validated['location'],
                    'phone' => (string) $validated['phone'],
                    'specialty' => (string) $validated['specialty'],
                ]);
                $application = $application->fresh() ?? $application;
            } else {
                $application = SellerApplication::query()->create([
                    'tenant_id' => $user->tenant_id,
                    'user_id' => $user->id,
                    'business_name' => (string) $validated['business_name'],
                    'owner_name' => $user->name,
                    'type' => 'Verified Merchant',
                    'br_number' => 'BR-'.$user->id,
                    'location' => (string) $validated['location'],
                    'phone' => (string) $validated['phone'],
                    'submitted_time_label' => 'Verified Partner',
                    'status' => 'Verified',
                    'documents' => [],
                    'specialty' => (string) $validated['specialty'],
                ]);
            }

            $user->update(['city' => (string) $validated['location']]);

            return $application;
        });

        return response()->json([
            'shop' => $this->formatShop($user->fresh() ?? $user, $application),
        ]);
    }

    private function authorizeSeller(Request $request): User
    {
        /** @var User $user */
        $user = $request->user();
        abort_unless($user->hasRole('workshop-partner'), 403, 'Shop owner account required.');

        return $user;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatShop(User $user, ?SellerApplication $application): array
    {
        return [
            'business_name' => $application->business_name ?? $user->name,
            'owner_name' => $application->owner_name ?? $user->name,
            'type' => $application->type ?? 'Verified Merchant',
            'br_number' => $application->br_number ?? 'Registered',
            'location' => $application->location ?? $user->city,
            'phone' => $application->phone ?? $user->mobile_number,
            'status' => $application->status ?? 'Pending',
            'specialty' => $application->specialty ?? 'Performance Parts & Tuning',
            'documents' => $application->documents ?? [],
        ];
    }
}
