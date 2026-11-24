<div class="min-h-screen w-full bg-[#E4E9E7] text-[#111827] font-sans antialiased flex flex-col">
    <x-toast :title="$toastTitle" :message="$toastMessage" :type="$toastType" />

    <!-- Authenticated Merchant Top Bar -->
    <header class="bg-white/95 backdrop-blur-md border-b border-[#D8E0DC] px-4 sm:px-6 py-2.5 flex flex-wrap items-center justify-between gap-3 sticky top-0 z-40">
        <div class="flex items-center gap-2.5">
            <div class="w-8 h-8 rounded-xl bg-[#009A5E] text-white flex items-center justify-center font-black text-xs shadow-xs">
                AG
            </div>
            <div>
                <span class="text-sm font-extrabold tracking-tight text-[#111827]">
                    Apex<span class="text-[#009A5E]">Garage</span> <span class="text-[#6B7280] font-semibold">· Merchant Hub</span>
                </span>
                <span class="hidden sm:inline-block ml-2 px-2 py-0.5 rounded-full bg-[#E6F6EF] text-[#009A5E] text-[10px] font-bold">
                    {{ $application?->business_name ?? $currentUser->name }}
                </span>
            </div>
        </div>

        <div class="flex items-center gap-3">
            <div class="hidden sm:flex items-center gap-2 px-3 py-1 rounded-full bg-[#F7F8FA] border border-[#ECEEF0] text-xs">
                <span class="w-2 h-2 rounded-full {{ $isVerifiedMerchant ? 'bg-[#009A5E]' : 'bg-amber-500' }}"></span>
                <span class="font-bold text-[#111827]">{{ $currentUser->name }}</span>
                <span class="text-[#6B7280]">({{ $currentUser->email }})</span>
            </div>
            <button
                type="button"
                wire:click="logout"
                class="px-3.5 py-1.5 rounded-full bg-rose-50 hover:bg-rose-100 text-rose-600 text-xs font-bold cursor-pointer transition"
            >
                🚪 Sign Out
            </button>
        </div>
    </header>

    <div class="flex-1 max-w-[1380px] w-full mx-auto p-4 md:p-6 grid grid-cols-1 lg:grid-cols-12 gap-5">
        <!-- Seller Sidebar -->
        <aside class="lg:col-span-3 bg-white rounded-[24px] border border-[#ECEEF0] p-4 flex flex-col justify-between shadow-[0_4px_12px_rgba(0,0,0,0.03)] h-fit">
            <div class="space-y-4">
                <div class="px-2 pt-1 pb-3 border-b border-[#F3F4F6]">
                    @if ($isVerifiedMerchant)
                        <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] border border-[#10B981] text-[#047857] text-[10.5px] font-bold">
                            ✓ VERIFIED MERCHANT
                        </span>
                    @elseif ($application?->status === 'Rejected')
                        <span class="px-2.5 py-0.5 rounded-full bg-rose-50 border border-rose-300 text-rose-700 text-[10.5px] font-bold">
                            ✕ APPLICATION REJECTED
                        </span>
                    @else
                        <span class="px-2.5 py-0.5 rounded-full bg-amber-50 border border-amber-300 text-amber-700 text-[10.5px] font-bold">
                            ⏳ PENDING BR VERIFICATION
                        </span>
                    @endif
                    <h2 class="text-base font-extrabold text-[#111827] mt-1.5">{{ $application?->business_name ?? $currentUser->name }}</h2>
                    <p class="text-xs text-[#6B7280]">
                        {{ $application?->location ?? $currentUser->city }} · BR {{ $application?->br_number ?? 'Registered' }}
                    </p>
                </div>

                <nav class="space-y-1">
                    @php
                        $sellerNav = [
                            ['id' => 'dashboard', 'label' => 'Storefront Overview', 'icon' => '🏪'],
                            ['id' => 'inventory', 'label' => 'Parts Inventory', 'icon' => '📦', 'badge' => $sellerListings->count()],
                            ['id' => 'inquiries', 'label' => 'Buyer Inquiries & Orders', 'icon' => '💬', 'badge' => $inquiries->count()],
                            ['id' => 'workshop', 'label' => 'Workshop & Dyno Slots', 'icon' => '🔧', 'badge' => $bookings->count()],
                            ['id' => 'verification', 'label' => 'BR & Trust Profile', 'icon' => '📄'],
                        ];
                    @endphp

                    @foreach ($sellerNav as $item)
                        <button
                            type="button"
                            wire:click="setSellerTab('{{ $item['id'] }}')"
                            class="w-full px-3.5 py-2.5 rounded-[14px] text-xs font-semibold flex items-center justify-between transition cursor-pointer {{ $sellerTab === $item['id'] ? 'bg-[#ECFDF5] text-[#047857] border border-[#10B981]/50' : 'text-[#4B5563] hover:bg-[#F7F8FA] hover:text-[#111827]' }}"
                        >
                            <span class="flex items-center gap-2">
                                <span>{{ $item['icon'] }}</span>
                                <span>{{ $item['label'] }}</span>
                            </span>
                            @if (isset($item['badge']) && $item['badge'] > 0)
                                <span class="px-2 py-0.5 rounded-full bg-[#009A5E] text-white text-[10.5px] font-bold">
                                    {{ $item['badge'] }}
                                </span>
                            @endif
                        </button>
                    @endforeach
                </nav>
            </div>

            <div class="pt-4 mt-6 border-t border-[#F3F4F6] space-y-2">
                <div class="px-3 py-2 rounded-[12px] bg-[#F7F8FA] text-[11px] text-[#6B7280]">
                    {{ $tenant?->name ?? 'ApexGarage SL' }} · Partner Portal
                </div>
                <button
                    type="button"
                    wire:click="logout"
                    class="w-full px-3.5 py-2 rounded-[12px] text-xs font-semibold text-rose-600 hover:bg-rose-50 flex items-center gap-2 cursor-pointer transition"
                >
                    <span>🚪</span>
                    <span>Sign Out</span>
                </button>
            </div>
        </aside>

        <!-- Main Seller Workspace -->
        <main class="lg:col-span-9 space-y-5">
            @if (! $isVerifiedMerchant)
                <div class="p-4 rounded-[20px] {{ $application?->status === 'Rejected' ? 'bg-rose-50 border border-rose-200 text-rose-800' : 'bg-amber-50 border border-amber-200 text-amber-800' }} flex flex-wrap items-center justify-between gap-3">
                    <div class="space-y-0.5">
                        <div class="text-xs font-extrabold uppercase tracking-wide">
                            {{ $application?->status === 'Rejected' ? 'Verification Rejected' : 'Awaiting Super Admin Verification' }}
                        </div>
                        <p class="text-xs">
                            @if ($application?->status === 'Rejected')
                                Reason: {{ $application->rejection_reason ?? 'Please update your BR details below.' }}
                            @else
                                Your Business Registration ({{ $application?->br_number }}) is currently under review. Publishing new parts is locked until approved.
                            @endif
                        </p>
                    </div>
                </div>
            @endif

            <!-- Top Status Header -->
            <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-4 px-5 flex flex-wrap items-center justify-between gap-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                <div>
                    <h1 class="text-lg font-extrabold text-[#111827]">
                        @if ($sellerTab === 'dashboard') Merchant Storefront Dashboard @endif
                        @if ($sellerTab === 'inventory') JDM Parts Stock &amp; Pricing Management @endif
                        @if ($sellerTab === 'inquiries') Live Buyer Inquiries &amp; Price Negotiation @endif
                        @if ($sellerTab === 'workshop') Workshop Bays &amp; Dyno Appointments @endif
                        @if ($sellerTab === 'verification') Merchant Trust Credentials &amp; Business Profile @endif
                    </h1>
                    <p class="text-xs text-[#6B7280]">
                        {{ $application?->business_name ?? $currentUser->name }} · BR {{ $application?->br_number ?? 'Verified' }}
                    </p>
                </div>

                @if ($isVerifiedMerchant)
                    <button
                        type="button"
                        wire:click="$set('showAddPartModal', true)"
                        class="px-4 py-2.5 rounded-[14px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold flex items-center gap-1.5 shadow-xs cursor-pointer transition"
                    >
                        <span>+ List New JDM Part</span>
                    </button>
                @endif
            </div>

            {{-- SELLER TAB 1: STOREFRONT OVERVIEW --}}
            @if ($sellerTab === 'dashboard')
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <span class="text-xs font-semibold text-[#6B7280]">Catalog Value</span>
                        <div class="text-2xl font-extrabold text-[#111827] mt-1">
                            LKR {{ number_format($sellerListings->sum(fn ($i) => $i->price_lkr * max(1, $i->stock))) }}
                        </div>
                        <span class="text-xs font-bold text-[#009A5E]">Live Storefront Valuation</span>
                    </div>

                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <span class="text-xs font-semibold text-[#6B7280]">Active JDM Listings</span>
                        <div class="text-2xl font-extrabold text-[#111827] mt-1">{{ $sellerListings->count() }} Items</div>
                        <span class="text-xs text-[#6B7280]">{{ $sellerListings->where('status', 'Approved')->count() }} Approved on Mobile</span>
                    </div>

                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <span class="text-xs font-semibold text-[#6B7280]">Open Buyer Inquiries</span>
                        <div class="text-2xl font-extrabold text-[#009A5E] mt-1">{{ $inquiries->count() }}</div>
                        <span class="text-xs text-[#6B7280]">Direct enthusiast negotiations</span>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-4">
                    <div class="lg:col-span-7 bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <h3 class="text-sm font-bold text-[#111827]">Storefront Inventory</h3>
                            <button type="button" wire:click="setSellerTab('inventory')" class="text-xs font-bold text-[#009A5E] hover:underline cursor-pointer">
                                Manage stock →
                            </button>
                        </div>
                        <div class="space-y-2.5">
                            @forelse ($sellerListings as $item)
                                <div class="p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] flex items-center justify-between gap-3">
                                    <div>
                                        <div class="text-xs font-bold text-[#111827]">{{ $item->title }}</div>
                                        <div class="text-[11px] text-[#6B7280]">{{ $item->fitment }} · Stock: {{ $item->stock }} · {{ $item->views_count }} views</div>
                                    </div>
                                    <div class="text-right flex items-center gap-2">
                                        <div>
                                            <div class="text-xs font-extrabold text-[#111827]">LKR {{ number_format($item->price_lkr) }}</div>
                                            <span class="text-[10.5px] font-bold text-[#009A5E]">{{ $item->status }}</span>
                                        </div>
                                        <button type="button" wire:click="inspectPart({{ $item->id }})" class="px-2 py-1 rounded-md bg-white border border-[#D1D5DB] text-[10px] font-bold text-[#374151] hover:bg-[#F3F4F6] cursor-pointer">
                                            Edit
                                        </button>
                                    </div>
                                </div>
                            @empty
                                <p class="text-xs text-[#6B7280] py-6 text-center">No parts listed yet. Click "+ List New JDM Part" to publish.</p>
                            @endforelse
                        </div>
                    </div>

                    <div class="lg:col-span-5 bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <h3 class="text-sm font-bold text-[#111827]">Recent Buyer Inquiries</h3>
                            <button type="button" wire:click="setSellerTab('inquiries')" class="text-xs font-bold text-[#009A5E] hover:underline cursor-pointer">
                                Open chat →
                            </button>
                        </div>
                        <div class="space-y-2.5">
                            @forelse ($inquiries as $inq)
                                <div wire:click="setActiveInquiry({{ $inq->id }})" class="p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] space-y-1 cursor-pointer hover:border-[#10B981] transition">
                                    <div class="flex items-center justify-between">
                                        <span class="text-xs font-bold text-[#111827]">{{ $inq->buyer_name }}</span>
                                        <span class="px-2 py-0.5 rounded-full bg-[#ECFDF5] text-[#047857] text-[10px] font-bold">{{ $inq->status }}</span>
                                    </div>
                                    <div class="text-[11.5px] text-[#009A5E] font-semibold">{{ $inq->part_title }}</div>
                                    <p class="text-[11px] text-[#6B7280] truncate">
                                        {{ is_array($inq->messages) && count($inq->messages) > 0 ? $inq->messages[count($inq->messages) - 1]['text'] : 'New buyer message' }}
                                    </p>
                                </div>
                            @empty
                                <p class="text-xs text-[#6B7280] py-6 text-center">No buyer inquiries yet.</p>
                            @endforelse
                        </div>
                    </div>
                </div>
            @endif

            {{-- SELLER TAB 2: INVENTORY TABLE --}}
            @if ($sellerTab === 'inventory')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 shadow-[0_4px_12px_rgba(0,0,0,0.03)] space-y-4">
                    <div class="flex items-center justify-between">
                        <h3 class="text-sm font-bold text-[#111827]">Storefront Parts Catalog</h3>
                        @if ($isVerifiedMerchant)
                            <button type="button" wire:click="$set('showAddPartModal', true)" class="px-3.5 py-1.5 rounded-full bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-2xs">
                                + Add JDM Part
                            </button>
                        @endif
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="border-b border-[#ECEEF0] text-[11.5px] font-bold text-[#6B7280] uppercase">
                                    <th class="py-3 px-2">SKU</th>
                                    <th class="py-3 px-2">Part &amp; Chassis Fitment</th>
                                    <th class="py-3 px-2">Condition</th>
                                    <th class="py-3 px-2">Stock</th>
                                    <th class="py-3 px-2">Price (LKR)</th>
                                    <th class="py-3 px-2">Admin Status</th>
                                    <th class="py-3 px-2 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-[#F3F4F6] text-xs">
                                @forelse ($sellerListings as $item)
                                    <tr>
                                        <td class="py-3 px-2 font-mono text-xs text-[#6B7280]">{{ $item->sku }}</td>
                                        <td class="py-3 px-2">
                                            <div class="font-bold text-[#111827]">{{ $item->title }}</div>
                                            <div class="text-[11px] text-[#6B7280]">{{ $item->fitment }}</div>
                                        </td>
                                        <td class="py-3 px-2">{{ $item->condition }}</td>
                                        <td class="py-3 px-2 font-bold">{{ $item->stock }} units</td>
                                        <td class="py-3 px-2 font-bold text-[#111827]">LKR {{ number_format($item->price_lkr) }}</td>
                                        <td class="py-3 px-2">
                                            <span class="px-2.5 py-0.5 rounded-full text-[11px] font-bold border {{ $item->status === 'Approved' ? 'bg-[#ECFDF5] border-[#10B981]/50 text-[#047857]' : 'bg-amber-50 border-amber-300 text-amber-700' }}">
                                                {{ $item->status }}
                                            </span>
                                        </td>
                                        <td class="py-3 px-2 text-right">
                                            <button type="button" wire:click="inspectPart({{ $item->id }})" class="px-2.5 py-1 rounded-lg bg-white border border-[#D1D5DB] hover:bg-[#F3F4F6] text-[#374151] font-semibold text-[11px] cursor-pointer">
                                                Edit
                                            </button>
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="7" class="py-8 text-center text-xs text-[#6B7280]">No parts in your inventory yet.</td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            @endif

            {{-- SELLER TAB 3: BUYER INQUIRIES & DIRECT CHAT --}}
            @if ($sellerTab === 'inquiries')
                @if ($activeInquiry)
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-4">
                        <div class="md:col-span-4 bg-white rounded-[24px] border border-[#ECEEF0] p-4 space-y-2.5 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                            <div class="text-xs font-bold text-[#6B7280] uppercase tracking-wide px-1">Enthusiast Inquiries</div>
                            @foreach ($inquiries as $inq)
                                <button type="button" wire:click="setActiveInquiry({{ $inq->id }})" class="w-full text-left p-3.5 rounded-[16px] border transition cursor-pointer {{ $activeInquiry->id === $inq->id ? 'bg-[#ECFDF5] border-[#10B981]' : 'bg-[#F7F8FA] border-[#ECEEF0]' }}">
                                    <div class="flex justify-between items-center">
                                        <span class="text-xs font-bold text-[#111827]">{{ $inq->buyer_name }}</span>
                                        <span class="text-[11px] text-[#6B7280]">{{ $inq->time_label }}</span>
                                    </div>
                                    <div class="text-[11.5px] font-semibold text-[#009A5E] mt-0.5">{{ $inq->part_title }}</div>
                                    <div class="text-[11px] text-[#6B7280] mt-0.5">Vehicle: {{ $inq->vehicle }}</div>
                                </button>
                            @endforeach
                        </div>

                        <div class="md:col-span-8 bg-white rounded-[24px] border border-[#ECEEF0] p-5 flex flex-col justify-between h-[460px] shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                            <div class="border-b border-[#F3F4F6] pb-3 flex items-center justify-between">
                                <div>
                                    <h4 class="text-sm font-bold text-[#111827]">{{ $activeInquiry->buyer_name }} · {{ $activeInquiry->vehicle }}</h4>
                                    <p class="text-xs text-[#009A5E] font-semibold">Item: {{ $activeInquiry->part_title }} (Offer: LKR {{ number_format($activeInquiry->offer_lkr) }})</p>
                                </div>
                                <div class="flex items-center gap-2">
                                    <button type="button" wire:click="simulateInboundBuyerMessage" class="px-2.5 py-1 rounded-full bg-[#F1F3F4] hover:bg-[#E4E9E7] text-[10.5px] font-bold text-[#374151] cursor-pointer">
                                        ⚡ Simulate Buyer Message
                                    </button>
                                    <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] text-[#047857] text-[11px] font-bold">{{ $activeInquiry->status }}</span>
                                </div>
                            </div>

                            <div class="flex-1 overflow-y-auto py-3 space-y-2.5">
                                @foreach ($activeInquiry->messages as $m)
                                    <div class="max-w-[78%] px-4 py-2.5 rounded-[16px] text-xs {{ $m->sender_type === 'seller' ? 'ml-auto bg-[#009A5E] text-white' : 'bg-[#F1F3F4] text-[#111827]' }}">
                                        <div class="text-[10px] font-bold opacity-80 mb-0.5">
                                            {{ $m->sender_type === 'seller' ? ($application?->business_name ?? $currentUser->name).' (You)' : $activeInquiry->buyer_name }}
                                        </div>
                                        {{ $m->body }}
                                    </div>
                                @endforeach
                            </div>

                            <form wire:submit="sendSellerReply" class="flex gap-2 pt-2 border-t border-[#F3F4F6]">
                                <input type="text" wire:model="sellerReplyText" placeholder="Reply to enthusiast about fitment, pickup, or courier..." class="flex-1 bg-[#F1F3F4] rounded-[12px] px-4 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#009A5E]" />
                                <button type="submit" class="px-4 py-2.5 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white font-bold text-xs flex items-center gap-1.5 cursor-pointer transition shadow-2xs">
                                    <span>Send ✈️</span>
                                </button>
                            </form>
                        </div>
                    </div>
                @else
                    <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-10 text-center text-xs text-[#6B7280]">
                        No buyer inquiries assigned to your storefront yet.
                    </div>
                @endif
            @endif

            {{-- SELLER TAB 4: WORKSHOP & DYNO BOOKINGS --}}
            @if ($sellerTab === 'workshop')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex items-center justify-between pb-2 border-b border-[#F3F4F6]">
                        <div>
                            <h3 class="text-sm font-bold text-[#111827]">Workshop Bay Appointments</h3>
                            <p class="text-xs text-[#6B7280]">Manage dyno runs, suspension setups, and scheduled maintenance.</p>
                        </div>
                        <span class="text-xs font-bold text-[#009A5E]">Bay 1 &amp; Bay 2 Active</span>
                    </div>

                    @forelse ($bookings as $bk)
                        <div class="p-4 rounded-[20px] bg-[#F7F8FA] border border-[#ECEEF0] flex flex-wrap items-center justify-between gap-4">
                            <div>
                                <div class="text-sm font-bold text-[#111827]">{{ $bk->service }}</div>
                                <div class="text-xs text-[#6B7280] mt-0.5">
                                    Owner: <strong>{{ $bk->customer_name }}</strong> · {{ $bk->vehicle }} · <span class="text-[#009A5E] font-semibold">{{ $bk->slot_date }}</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-3">
                                <span class="text-sm font-extrabold text-[#111827]">LKR {{ number_format($bk->estimate_lkr) }}</span>
                                @if ($bk->status === 'Confirmed')
                                    <span class="px-3 py-1.5 rounded-full bg-[#ECFDF5] border border-[#10B981] text-[#047857] text-xs font-bold">✓ Confirmed</span>
                                    <button type="button" wire:click="completeWorkshopBooking({{ $bk->id }})" class="px-3 py-1.5 rounded-[12px] bg-white border border-[#D1D5DB] text-[#374151] hover:bg-[#F3F4F6] text-xs font-semibold cursor-pointer">Complete Service</button>
                                @elseif ($bk->status === 'Completed')
                                    <span class="px-3 py-1.5 rounded-full bg-[#F3F4F6] text-[#374151] text-xs font-bold">✓ Completed</span>
                                @else
                                    <button type="button" wire:click="confirmWorkshopSlot({{ $bk->id }})" class="px-4 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-2xs">Confirm Bay</button>
                                @endif
                            </div>
                        </div>
                    @empty
                        <p class="text-xs text-[#6B7280] py-8 text-center">No workshop bay bookings scheduled.</p>
                    @endforelse
                </div>
            @endif

            {{-- SELLER TAB 5: VERIFICATION & TRUST CREDENTIALS --}}
            @if ($sellerTab === 'verification')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-6 space-y-6 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex items-center gap-3 pb-4 border-b border-[#F3F4F6]">
                        <div class="w-12 h-12 rounded-full bg-[#ECFDF5] border border-[#10B981] text-[#009A5E] flex items-center justify-center text-xl">🛡️</div>
                        <div>
                            <h3 class="text-base font-extrabold text-[#111827]">
                                Merchant Verification Status: {{ $application?->status ?? 'Verified' }}
                            </h3>
                            <p class="text-xs text-[#6B7280]">
                                BR Number: <span class="font-mono font-bold">{{ $application?->br_number ?? 'PV-00284910' }}</span> · Registered under {{ $application?->owner_name ?? $currentUser->name }}
                            </p>
                        </div>
                    </div>

                    <form wire:submit="updateSellerProfile" class="space-y-4">
                        <h4 class="text-xs font-bold text-[#111827] uppercase tracking-wide">Storefront Contact &amp; Dispatch Channels</h4>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Direct Sales Phone</label>
                                <input type="text" wire:model="sellerShopPhone" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#009A5E]" />
                            </div>
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Specialty &amp; Focus</label>
                                <input type="text" wire:model="sellerSpecialty" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#009A5E]" />
                            </div>
                        </div>

                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Store / Garage Physical Address</label>
                            <input type="text" wire:model="sellerShopAddress" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#009A5E]" />
                        </div>

                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Islandwide Courier &amp; Fulfillment</label>
                            <input type="text" wire:model="sellerCourierOption" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#009A5E]" />
                        </div>

                        <button type="submit" class="px-5 py-2.5 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-2xs">
                            Save Storefront Profile
                        </button>
                    </form>
                </div>
            @endif
        </main>
    </div>

    {{-- MODAL: LIST NEW JDM PART --}}
    @if ($showAddPartModal)
        <div class="fixed inset-0 z-50 bg-black/45 backdrop-blur-xs flex items-center justify-center p-4">
            <form wire:submit="addSellerPart" class="w-full max-w-[480px] bg-white rounded-[28px] p-6 space-y-3.5 shadow-2xl">
                <div class="flex items-center justify-between pb-2 border-b border-[#F3F4F6]">
                    <div>
                        <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] text-[#009A5E] text-[10px] font-extrabold uppercase">Marketplace Listing</span>
                        <h3 class="text-base font-extrabold text-[#111827] mt-0.5">Publish Part to Mobile Marketplace</h3>
                    </div>
                    <button type="button" wire:click="$set('showAddPartModal', false)" class="text-[#6B7280] hover:text-[#111827] text-lg font-bold p-1 cursor-pointer">✕</button>
                </div>

                <div>
                    <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Part Title</label>
                    <input type="text" required wire:model="newPartTitle" placeholder="e.g., Skunk2 Alpha Header K20A" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Brand</label>
                        <select wire:model="newPartBrand" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:outline-none">
                            <option>Honda</option>
                            <option>HKS</option>
                            <option>Spoon</option>
                            <option>Tein</option>
                            <option>Akrapovic</option>
                            <option>Nissan</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Condition</label>
                        <select wire:model="newPartCondition" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:outline-none">
                            <option>Brand New</option>
                            <option>JDM Recond</option>
                            <option>Used - Mint</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Chassis &amp; Engine Fitment</label>
                    <input type="text" required wire:model="newPartFitment" placeholder="e.g., Civic FD2 / K20A" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Price (LKR)</label>
                        <input type="number" required wire:model="newPartPrice" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                    </div>
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Stock Qty</label>
                        <input type="number" required wire:model="newPartStock" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                    </div>
                </div>

                <div class="pt-3 border-t border-[#F3F4F6] flex items-center justify-end gap-2.5">
                    <button type="button" wire:click="$set('showAddPartModal', false)" class="px-4 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs">Submit Listing for Moderation</button>
                </div>
            </form>
        </div>
    @endif

    {{-- MODAL: EDIT PART PRICE & STOCK --}}
    @if ($showPartDetailsModal && $inspectingPart)
        <div class="fixed inset-0 z-50 bg-black/45 backdrop-blur-xs flex items-center justify-center p-4">
            <form wire:submit="savePartEdits" class="w-full max-w-[460px] bg-white rounded-[28px] p-6 space-y-4 shadow-2xl">
                <div class="flex items-center justify-between pb-3 border-b border-[#F3F4F6]">
                    <div>
                        <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] text-[#009A5E] text-[10px] font-extrabold uppercase">{{ $inspectingPart->sku }}</span>
                        <h3 class="text-base font-extrabold text-[#111827] mt-0.5">{{ $inspectingPart->title }}</h3>
                    </div>
                    <button type="button" wire:click="closePartModal" class="text-[#6B7280] hover:text-[#111827] text-lg font-bold p-1 cursor-pointer">✕</button>
                </div>

                <div class="grid grid-cols-2 gap-3 text-xs">
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Price (LKR)</label>
                        <input type="number" required wire:model="editPartPrice" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                    </div>
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Available Units</label>
                        <input type="number" required wire:model="editPartStock" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                    </div>
                </div>

                <div class="pt-3 border-t border-[#F3F4F6] flex items-center justify-end gap-2.5">
                    <button type="button" wire:click="closePartModal" class="px-4 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs">Save Changes</button>
                </div>
            </form>
        </div>
    @endif
</div>
