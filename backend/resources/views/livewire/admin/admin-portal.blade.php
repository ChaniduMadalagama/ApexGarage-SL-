<div class="min-h-screen w-full bg-[#E4E9E7] text-[#111827] font-sans antialiased flex flex-col">
    <x-toast :title="$toastTitle" :message="$toastMessage" :type="$toastType" />

    <!-- Authenticated Super Admin Top Bar -->
    <header class="bg-white/95 backdrop-blur-md border-b border-[#D8E0DC] px-4 sm:px-6 py-2.5 flex flex-wrap items-center justify-between gap-3 sticky top-0 z-40">
        <div class="flex items-center gap-2.5">
            <div class="w-8 h-8 rounded-xl bg-[#009A5E] text-white flex items-center justify-center font-black text-xs shadow-xs">
                AG
            </div>
            <div>
                <span class="text-sm font-extrabold tracking-tight text-[#111827]">
                    Apex<span class="text-[#009A5E]">Garage</span> <span class="text-[#6B7280] font-semibold">· Super Admin Console</span>
                </span>
                <span class="hidden sm:inline-block ml-2 px-2 py-0.5 rounded-full bg-[#E6F6EF] text-[#009A5E] text-[10px] font-bold">
                    {{ $tenant?->name ?? 'Colombo HQ' }}
                </span>
            </div>
        </div>

        <div class="flex items-center gap-3">
            <div class="hidden sm:flex items-center gap-2 px-3 py-1 rounded-full bg-[#F7F8FA] border border-[#ECEEF0] text-xs">
                <span class="w-2 h-2 rounded-full bg-[#009A5E]"></span>
                <span class="font-bold text-[#111827]">{{ $currentUser?->name ?? 'Administrator' }}</span>
                <span class="text-[#6B7280]">({{ $currentUser?->email }})</span>
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
        <!-- Left Sidebar Navigation -->
        <aside class="lg:col-span-3 bg-white rounded-[24px] border border-[#ECEEF0] p-4 flex flex-col justify-between shadow-[0_4px_12px_rgba(0,0,0,0.03)] h-fit">
            <div class="space-y-4">
                <div class="px-2 pt-1 pb-3 border-b border-[#F3F4F6]">
                    <span class="px-2 py-0.5 rounded-full bg-[#ECFDF5] border border-[#10B981]/50 text-[#047857] text-[10px] font-bold">
                        SUPER ADMIN · RBAC
                    </span>
                    <h2 class="text-base font-extrabold text-[#111827] mt-1">Platform Control</h2>
                </div>

                <nav class="space-y-1">
                    @php
                        $adminNav = [
                            ['id' => 'overview', 'label' => 'Executive Overview', 'icon' => '📊'],
                            ['id' => 'vetting', 'label' => 'Seller & Shop Vetting', 'icon' => '🛡️', 'badge' => $pendingApplicationsCount],
                            ['id' => 'marketplace', 'label' => 'Parts Moderation', 'icon' => '🛍️'],
                            ['id' => 'ideabiz', 'label' => 'Dialog IdeaBiz Billing', 'icon' => '📱'],
                            ['id' => 'ads', 'label' => 'Sponsored Ad Slots', 'icon' => '📢'],
                            ['id' => 'community', 'label' => 'Crews, Meets & Logs', 'icon' => '🧭'],
                        ];
                    @endphp

                    @foreach ($adminNav as $item)
                        <button
                            type="button"
                            wire:click="setAdminTab('{{ $item['id'] }}')"
                            class="w-full px-3.5 py-2.5 rounded-[14px] text-xs font-semibold flex items-center justify-between transition cursor-pointer {{ $adminTab === $item['id'] ? 'bg-[#ECFDF5] text-[#047857] border border-[#10B981]/50' : 'text-[#4B5563] hover:bg-[#F7F8FA] hover:text-[#111827]' }}"
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
                <div class="px-3 py-2.5 rounded-[14px] bg-[#F7F8FA] text-[11.5px]">
                    <div class="font-bold text-[#111827]">Laravel API v1.4 · Online</div>
                    <div class="text-[#6B7280] mt-0.5">IdeaBiz: Connected · Sanctum: Active</div>
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

        <!-- Main Admin Workspace -->
        <main class="lg:col-span-9 space-y-5">
            <!-- Top Status Header -->
            <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-4 px-5 flex flex-wrap items-center justify-between gap-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                <div>
                    <h1 class="text-lg font-extrabold text-[#111827]">
                        @if ($adminTab === 'overview') Platform Analytics &amp; Dual-Revenue Overview @endif
                        @if ($adminTab === 'vetting') Verified Sellers &amp; Tuning Workshops Vetting @endif
                        @if ($adminTab === 'marketplace') JDM &amp; Performance Parts Moderation @endif
                        @if ($adminTab === 'ideabiz') Dialog IdeaBiz / Ideamart Carrier Subscriptions @endif
                        @if ($adminTab === 'ads') Targeted Advertisements Manager @endif
                        @if ($adminTab === 'community') Crews, Meets &amp; Digital Garage Oversight @endif
                    </h1>
                    <p class="text-xs text-[#6B7280]">
                        Sri Lanka Automotive Ecosystem · Real-time Database &amp; Sanctum Telemetry
                    </p>
                </div>

                <div class="flex items-center gap-2.5">
                    <input
                        type="search"
                        wire:model.live.debounce.250ms="adminSearch"
                        placeholder="Search shops, parts, fitment..."
                        class="bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:outline-none focus:ring-2 focus:ring-[#009A5E] w-48 sm:w-60"
                    />
                    <button
                        type="button"
                        wire:click="refreshTelemetry"
                        class="px-3 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer"
                        title="Invalidate Metrics Cache"
                    >
                        🔄 Refresh
                    </button>
                </div>
            </div>

            {{-- ADMIN TAB 1: EXECUTIVE OVERVIEW --}}
            @if ($adminTab === 'overview')
                <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 space-y-2 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-semibold text-[#6B7280]">Total Enthusiasts</span>
                            <span class="w-8 h-8 rounded-full bg-[#ECFDF5] text-[#009A5E] flex items-center justify-center text-sm">👥</span>
                        </div>
                        <div class="text-2xl font-extrabold text-[#111827]">{{ number_format($metrics['total_enthusiasts'] ?? 2840) }}</div>
                        <div class="flex items-center justify-between text-[11px]">
                            <span class="text-[#009A5E] font-bold">+18.4%</span>
                            <span class="text-[#6B7280]">1,910 Cars · 930 Bikes</span>
                        </div>
                    </div>

                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 space-y-2 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-semibold text-[#6B7280]">IdeaBiz MRR (Carrier)</span>
                            <span class="w-8 h-8 rounded-full bg-[#ECFDF5] text-[#009A5E] flex items-center justify-center text-sm">📱</span>
                        </div>
                        <div class="text-2xl font-extrabold text-[#111827]">
                            LKR {{ number_format($metrics['ideabiz_mrr_lkr'] ?? 268500) }}
                        </div>
                        <div class="flex items-center justify-between text-[11px]">
                            <span class="text-[#009A5E] font-bold">{{ $transactions->count() }} subscriptions</span>
                            <span class="text-[#6B7280]">Dialog Daily/Monthly</span>
                        </div>
                    </div>

                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 space-y-2 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-semibold text-[#6B7280]">Ads MRR (Sponsors)</span>
                            <span class="w-8 h-8 rounded-full bg-[#ECFDF5] text-[#009A5E] flex items-center justify-center text-sm">📢</span>
                        </div>
                        <div class="text-2xl font-extrabold text-[#111827]">
                            LKR {{ number_format($ads->where('is_active', true)->sum('revenue_lkr')) }}
                        </div>
                        <div class="flex items-center justify-between text-[11px]">
                            <span class="text-[#009A5E] font-bold">{{ $ads->where('is_active', true)->count() }} active campaigns</span>
                            <span class="text-[#6B7280]">Motul, HKS, Brembo</span>
                        </div>
                    </div>

                    <div class="bg-white rounded-[22px] border border-[#ECEEF0] p-4 space-y-2 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-semibold text-[#6B7280]">Pending Shop Vetting</span>
                            <span class="w-8 h-8 rounded-full bg-[#ECFDF5] text-[#009A5E] flex items-center justify-center text-sm">🛡️</span>
                        </div>
                        <div class="text-2xl font-extrabold text-[#111827]">{{ $pendingApplicationsCount }}</div>
                        <div class="flex items-center justify-between text-[11px]">
                            <span class="text-amber-600 font-bold">Action Required</span>
                            <span class="text-[#6B7280]">BR &amp; Customs review</span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-5">
                    <div class="lg:col-span-7 bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-sm font-bold text-[#111827]">Dual-Monetization Growth</h3>
                                <p class="text-xs text-[#6B7280]">IdeaBiz Carrier Subscriptions vs Targeted Sponsor Ads (LKR)</p>
                            </div>
                            <div class="flex items-center gap-3 text-xs font-bold">
                                <span class="flex items-center gap-1.5">
                                    <span class="w-2.5 h-2.5 rounded-full bg-[#009A5E]"></span>
                                    IdeaBiz PRO
                                </span>
                                <span class="flex items-center gap-1.5">
                                    <span class="w-2.5 h-2.5 rounded-full bg-[#A7F3D0]"></span>
                                    Sponsored Ads
                                </span>
                            </div>
                        </div>

                        <div class="h-48 pt-4 flex items-end justify-between gap-4 border-b border-[#F3F4F6] pb-2">
                            @foreach ($revenueSeries as $m)
                                @php
                                    $ibzHeight = (int) round(($m['ideabiz'] / 300000) * 140);
                                    $adHeight = (int) round(($m['ads'] / 300000) * 140);
                                @endphp
                                <div class="flex-1 flex flex-col items-center gap-2">
                                    <div class="w-full flex items-end justify-center gap-1.5 h-[145px]">
                                        <div style="height: {{ $ibzHeight }}px" title="IdeaBiz: LKR {{ number_format($m['ideabiz']) }}" class="w-4 rounded-t-md bg-[#009A5E] transition-all hover:opacity-85"></div>
                                        <div style="height: {{ $adHeight }}px" title="Ads: LKR {{ number_format($m['ads']) }}" class="w-4 rounded-t-md bg-[#A7F3D0] transition-all hover:opacity-85"></div>
                                    </div>
                                    <span class="text-xs font-bold text-[#6B7280]">{{ $m['month'] }}</span>
                                </div>
                            @endforeach
                        </div>
                    </div>

                    <div class="lg:col-span-5 bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <div class="flex items-center justify-between">
                            <h3 class="text-sm font-bold text-[#111827]">Shop Verification Queue</h3>
                            <button type="button" wire:click="setAdminTab('vetting')" class="text-xs font-bold text-[#009A5E] hover:underline cursor-pointer">
                                View all →
                            </button>
                        </div>

                        <div class="space-y-2.5">
                            @forelse ($applications->take(4) as $app)
                                <div class="p-3 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] flex items-center justify-between gap-2">
                                    <div class="min-w-0">
                                        <div class="text-xs font-bold text-[#111827] truncate">{{ $app->business_name }}</div>
                                        <div class="text-[11px] text-[#6B7280] truncate">{{ $app->type }} · {{ $app->location }}</div>
                                    </div>
                                    <div class="flex items-center gap-1.5 shrink-0">
                                        <button type="button" wire:click="inspectApplication({{ $app->id }})" class="px-2.5 py-1 rounded-full bg-white border border-[#E5E7EB] text-[#374151] hover:bg-[#F3F4F6] text-[10.5px] font-semibold cursor-pointer">
                                            Inspect
                                        </button>
                                        @if ($app->status === 'Pending')
                                            <button type="button" wire:click="verifyApplication({{ $app->id }}, 'Verified')" class="px-3 py-1 rounded-full bg-[#009A5E] text-white text-[10.5px] font-bold cursor-pointer hover:bg-[#00824F]">
                                                Approve
                                            </button>
                                        @else
                                            <span class="px-2 py-0.5 rounded-full bg-[#ECFDF5] border border-[#10B981]/50 text-[#047857] text-[10px] font-bold">
                                                ✓ {{ $app->status }}
                                            </span>
                                        @endif
                                    </div>
                                </div>
                            @empty
                                <p class="text-xs text-[#6B7280] py-4 text-center">No applications pending.</p>
                            @endforelse
                        </div>
                    </div>
                </div>
            @endif

            {{-- ADMIN TAB 2: SELLER & WORKSHOP VETTING --}}
            @if ($adminTab === 'vetting')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex flex-wrap items-center justify-between gap-2 pb-2 border-b border-[#F3F4F6]">
                        <div>
                            <h3 class="text-sm font-bold text-[#111827]">Merchant Applications &amp; Compliance</h3>
                            <p class="text-xs text-[#6B7280]">
                                Verify Sri Lankan Business Registration (BR) certificates before granting the Emerald Verified badge.
                            </p>
                        </div>
                        <span class="px-3 py-1 rounded-full bg-[#ECFDF5] text-[#047857] text-xs font-bold">
                            {{ $pendingApplicationsCount }} Pending Review
                        </span>
                    </div>

                    <div class="space-y-3">
                        @foreach ($applications as $app)
                            <div class="p-4 rounded-[20px] border border-[#ECEEF0] bg-[#F7F8FA] flex flex-wrap items-center justify-between gap-4">
                                <div class="space-y-1">
                                    <div class="flex items-center gap-2">
                                        <h4 class="text-sm font-bold text-[#111827]">{{ $app->business_name }}</h4>
                                        <span class="px-2.5 py-0.5 rounded-full text-[11px] font-bold border {{ $app->status === 'Verified' ? 'bg-[#ECFDF5] border-[#10B981] text-[#047857]' : ($app->status === 'Rejected' ? 'bg-rose-50 border-rose-300 text-rose-700' : 'bg-amber-50 border-amber-300 text-amber-700') }}">
                                            {{ $app->status }}
                                        </span>
                                    </div>
                                    <p class="text-xs text-[#374151]">
                                        Owner: <strong>{{ $app->owner_name }}</strong> · BR: <span class="font-mono font-bold">{{ $app->br_number }}</span> · {{ $app->location }} · {{ $app->phone }}
                                    </p>
                                    <div class="flex items-center gap-2 pt-1 text-[11.5px]">
                                        <span class="text-[#6B7280]">Submitted Documents:</span>
                                        <button type="button" wire:click="inspectApplication({{ $app->id }})" class="px-2.5 py-0.5 rounded-md bg-white border border-[#D1D5DB] text-[#009A5E] font-semibold hover:bg-emerald-50 cursor-pointer flex items-center gap-1">
                                            <span>📄</span>
                                            <span>Inspect {{ is_array($app->documents) ? implode(', ', $app->documents) : 'BR_Certificate.pdf' }}</span>
                                        </button>
                                    </div>
                                </div>

                                <div class="flex items-center gap-2">
                                    <button type="button" wire:click="inspectApplication({{ $app->id }})" class="px-3.5 py-2 rounded-[12px] bg-white border border-[#E5E7EB] hover:bg-[#F3F4F6] text-[#374151] text-xs font-semibold cursor-pointer transition shadow-2xs">
                                        View Verification Dossier
                                    </button>
                                    @if ($app->status !== 'Verified')
                                        <button type="button" wire:click="verifyApplication({{ $app->id }}, 'Verified')" class="px-4 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold flex items-center gap-1 cursor-pointer transition shadow-2xs">
                                            <span>✓ Verify</span>
                                        </button>
                                    @endif
                                    @if ($app->status !== 'Rejected')
                                        <button type="button" wire:click="verifyApplication({{ $app->id }}, 'Rejected')" class="px-3 py-2 rounded-[12px] bg-white border border-rose-200 text-rose-600 hover:bg-rose-50 text-xs font-semibold cursor-pointer transition">
                                            Reject
                                        </button>
                                    @endif
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>
            @endif

            {{-- ADMIN TAB 3: MARKETPLACE MODERATION --}}
            @if ($adminTab === 'marketplace')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex flex-wrap items-center justify-between gap-3">
                        <div class="flex flex-wrap items-center gap-2">
                            @foreach (['All', 'Approved', 'Pending Review', 'Flagged'] as $st)
                                <button type="button" wire:click="setListingStatusFilter('{{ $st }}')" class="px-3.5 py-1.5 rounded-full text-xs font-semibold border cursor-pointer transition {{ $listingStatusFilter === $st ? 'bg-[#ECFDF5] border-[#10B981] text-[#047857]' : 'bg-white border-[#E5E7EB] text-[#374151]' }}">
                                    {{ $st }}
                                </button>
                            @endforeach
                        </div>
                        <span class="text-xs text-[#6B7280]">Showing {{ $listings->count() }} part listings</span>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="border-b border-[#ECEEF0] text-[11.5px] font-bold text-[#6B7280] uppercase">
                                    <th class="py-3 px-2">Part &amp; Fitment</th>
                                    <th class="py-3 px-2">Seller</th>
                                    <th class="py-3 px-2">Stock</th>
                                    <th class="py-3 px-2">Price (LKR)</th>
                                    <th class="py-3 px-2">Status</th>
                                    <th class="py-3 px-2 text-right">Moderation Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-[#F3F4F6] text-xs">
                                @forelse ($listings as $item)
                                    <tr class="hover:bg-[#F7F8FA]">
                                        <td class="py-3 px-2">
                                            <div class="font-bold text-[#111827]">{{ $item->title }}</div>
                                            <div class="text-[11px] text-[#6B7280]">
                                                {{ $item->fitment ?? $item->subtitle }} · {{ $item->condition }} · <span class="font-mono text-[10px]">{{ $item->sku }}</span>
                                            </div>
                                        </td>
                                        <td class="py-3 px-2 font-medium text-[#374151]">{{ $item->seller_name }}</td>
                                        <td class="py-3 px-2 font-semibold">{{ $item->stock }} units</td>
                                        <td class="py-3 px-2 font-bold text-[#111827]">LKR {{ number_format($item->price_lkr) }}</td>
                                        <td class="py-3 px-2">
                                            <span class="px-2.5 py-0.5 rounded-full text-[11px] font-bold border {{ $item->status === 'Approved' ? 'bg-[#ECFDF5] border-[#10B981]/50 text-[#047857]' : ($item->status === 'Flagged' ? 'bg-rose-50 border-rose-300 text-rose-700' : 'bg-amber-50 border-amber-300 text-amber-700') }}">
                                                {{ $item->status }}
                                            </span>
                                        </td>
                                        <td class="py-3 px-2 text-right space-x-1.5">
                                            <button type="button" wire:click="inspectPart({{ $item->id }})" class="px-2.5 py-1 rounded-lg bg-white border border-[#D1D5DB] hover:bg-[#F3F4F6] text-[#374151] text-[11px] font-semibold cursor-pointer">
                                                Inspect / Edit
                                            </button>
                                            @if ($item->status !== 'Approved')
                                                <button type="button" wire:click="moderateListing({{ $item->id }}, 'Approved')" class="px-3 py-1 rounded-lg bg-[#009A5E] hover:bg-[#00824F] text-white text-[11.5px] font-semibold cursor-pointer">
                                                    Approve
                                                </button>
                                            @endif
                                            @if ($item->status !== 'Flagged')
                                                <button type="button" wire:click="moderateListing({{ $item->id }}, 'Flagged')" class="px-3 py-1 rounded-lg bg-white border border-rose-200 text-rose-600 hover:bg-rose-50 text-[11.5px] font-semibold cursor-pointer">
                                                    Flag
                                                </button>
                                            @endif
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="6" class="py-6 text-center text-xs text-[#6B7280]">No listings found matching filter.</td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            @endif

            {{-- ADMIN TAB 4: DIALOG IDEABIZ BILLING LEDGER --}}
            @if ($adminTab === 'ideabiz')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-[#F3F4F6]">
                        <div>
                            <h3 class="text-sm font-bold text-[#111827]">Dialog IdeaBiz Subscription &amp; Charging API Logs</h3>
                            <p class="text-xs text-[#6B7280]">Real-time carrier billing callbacks via TelcoBillingGatewayInterface</p>
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="px-3 py-1 rounded-full bg-[#ECFDF5] border border-[#10B981] text-[#047857] text-xs font-bold">
                                API Status: 200 OK
                            </span>
                            <button type="button" wire:click="simulateIdeaBizBilling" class="px-3.5 py-1.5 rounded-full bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-2xs">
                                ⚡ Simulate USSD Charge (LKR 490)
                            </button>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="border-b border-[#ECEEF0] text-[11.5px] font-bold text-[#6B7280] uppercase">
                                    <th class="py-2.5 px-2">Tx Reference</th>
                                    <th class="py-2.5 px-2">Subscriber MSISDN</th>
                                    <th class="py-2.5 px-2">Plan</th>
                                    <th class="py-2.5 px-2">Amount</th>
                                    <th class="py-2.5 px-2">Carrier Status</th>
                                    <th class="py-2.5 px-2 text-right">Time</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-[#F3F4F6] text-xs">
                                @foreach ($transactions as $tx)
                                    <tr>
                                        <td class="py-3 px-2 font-mono text-[12px] font-bold text-[#111827]">{{ $tx->reference_id }}</td>
                                        <td class="py-3 px-2">
                                            <div class="font-semibold">{{ $tx->mobile_number }}</div>
                                            <div class="text-[11px] text-[#6B7280]">{{ $tx->carrier }}</div>
                                        </td>
                                        <td class="py-3 px-2 text-[#374151]">{{ $tx->plan_code }}</td>
                                        <td class="py-3 px-2 font-bold text-[#111827]">LKR {{ $tx->daily_rate_lkr * 30 }}</td>
                                        <td class="py-3 px-2">
                                            <span class="px-2.5 py-0.5 rounded-full text-[10.5px] font-bold {{ $tx->status === 'CHARGED' || $tx->status === 'active' ? 'bg-[#ECFDF5] text-[#047857] border border-[#10B981]/50' : 'bg-amber-50 text-amber-700 border border-amber-300' }}">
                                                {{ strtoupper($tx->status) }}
                                            </span>
                                        </td>
                                        <td class="py-3 px-2 text-right text-[11px] text-[#6B7280]">
                                            {{ $tx->created_at?->diffForHumans() ?? 'Just now' }}
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            @endif

            {{-- ADMIN TAB 5: SPONSORED ADS MANAGER --}}
            @if ($adminTab === 'ads')
                <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-4 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                    <div class="flex items-center justify-between pb-2 border-b border-[#F3F4F6]">
                        <div>
                            <h3 class="text-sm font-bold text-[#111827]">Sponsored Feed &amp; Banner Placements</h3>
                            <p class="text-xs text-[#6B7280]">Monetize high-intent enthusiasts with targeted brand campaigns.</p>
                        </div>
                        <button type="button" wire:click="openCreateAdModal" class="px-4 py-2 rounded-full bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-2xs">
                            + Launch Campaign
                        </button>
                    </div>

                    <div class="space-y-3">
                        @foreach ($ads as $ad)
                            <div class="p-4 rounded-[20px] border border-[#ECEEF0] bg-[#F7F8FA] flex flex-wrap items-center justify-between gap-4">
                                <div class="space-y-1">
                                    <span class="text-[10.5px] font-bold uppercase text-[#009A5E] bg-[#ECFDF5] px-2.5 py-0.5 rounded-full">
                                        {{ $ad->placement }}
                                    </span>
                                    <h4 class="text-sm font-bold text-[#111827] pt-1">{{ $ad->sponsor }} — {{ $ad->headline }}</h4>
                                    <p class="text-xs text-[#6B7280]">
                                        Impressions: <strong>{{ $ad->impressions }}</strong> · Clicks: <strong>{{ $ad->clicks }}</strong> (CTR {{ $ad->ctr }}) · Monthly Contract: <strong class="text-[#111827]">LKR {{ number_format($ad->revenue_lkr) }}</strong>
                                    </p>
                                </div>

                                <button type="button" wire:click="toggleAd({{ $ad->id }})" class="px-4 py-2 rounded-full text-xs font-bold border cursor-pointer transition {{ $ad->is_active ? 'bg-[#ECFDF5] border-[#10B981] text-[#047857]' : 'bg-white border-[#E5E7EB] text-[#6B7280]' }}">
                                    {{ $ad->is_active ? '● Active in Feed' : 'Paused' }}
                                </button>
                            </div>
                        @endforeach
                    </div>
                </div>
            @endif

            {{-- ADMIN TAB 6: COMMUNITY OVERSIGHT --}}
            @if ($adminTab === 'community')
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <h3 class="text-sm font-bold text-[#111827]">Active Sri Lankan Crews &amp; Meets</h3>
                        @foreach ($meets as $meet)
                            <div class="p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] flex items-center justify-between">
                                <div>
                                    <div class="text-xs font-bold text-[#111827]">{{ $meet->title }}</div>
                                    <div class="text-[11px] text-[#6B7280]">{{ $meet->host }} · {{ $meet->going_count }} Going · {{ $meet->location }}</div>
                                </div>
                                <span class="px-2.5 py-1 rounded-full bg-[#ECFDF5] text-[#047857] text-[10.5px] font-bold">Approved Pin</span>
                            </div>
                        @endforeach
                    </div>

                    <div class="bg-white rounded-[24px] border border-[#ECEEF0] p-5 space-y-3 shadow-[0_4px_12px_rgba(0,0,0,0.03)]">
                        <h3 class="text-sm font-bold text-[#111827]">Recent Digital Garage &amp; Media Logs</h3>
                        @foreach ($vehicles->take(4) as $v)
                            <div class="p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] flex items-center justify-between">
                                <div>
                                    <div class="text-xs font-bold text-[#111827]">{{ $v->brand }} {{ $v->title }}</div>
                                    <div class="text-[11px] text-[#6B7280]">{{ $v->power_value }} {{ $v->power_unit }} · {{ $v->engine }} · {{ $v->owner?->name ?? 'Enthusiast' }}</div>
                                </div>
                                <span class="text-[11px] font-semibold text-[#009A5E]">Verified Build</span>
                            </div>
                        @endforeach
                    </div>
                </div>
            @endif
        </main>
    </div>

    {{-- MODAL 1: DOCUMENT INSPECTION --}}
    @if ($showDocModal && $inspectingApp)
        <div class="fixed inset-0 z-50 bg-black/45 backdrop-blur-xs flex items-center justify-center p-4">
            <div class="w-full max-w-[540px] bg-white rounded-[28px] p-6 space-y-4 shadow-2xl">
                <div class="flex items-center justify-between pb-3 border-b border-[#F3F4F6]">
                    <div>
                        <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] text-[#009A5E] text-[10px] font-extrabold uppercase">Dossier Inspection</span>
                        <h3 class="text-base font-extrabold text-[#111827] mt-0.5">{{ $inspectingApp->business_name }}</h3>
                    </div>
                    <button type="button" wire:click="closeDocModal" class="text-[#6B7280] hover:text-[#111827] text-lg font-bold p-1 cursor-pointer">✕</button>
                </div>

                <div class="space-y-3 text-xs">
                    <div class="grid grid-cols-2 gap-3 p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0]">
                        <div>
                            <span class="text-[#6B7280] block text-[11px]">Business Registration (BR)</span>
                            <span class="font-mono font-bold text-[#111827]">{{ $inspectingApp->br_number }}</span>
                        </div>
                        <div>
                            <span class="text-[#6B7280] block text-[11px]">eROC SL Registry Check</span>
                            <span class="text-[#009A5E] font-bold">✓ Active Legal Entity</span>
                        </div>
                        <div>
                            <span class="text-[#6B7280] block text-[11px]">Applicant / Owner</span>
                            <span class="font-bold text-[#111827]">{{ $inspectingApp->owner_name }}</span>
                        </div>
                        <div>
                            <span class="text-[#6B7280] block text-[11px]">Contact Hotline</span>
                            <span class="font-bold text-[#111827]">{{ $inspectingApp->phone }}</span>
                        </div>
                    </div>

                    @if ($inspectingApp->status !== 'Verified')
                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Rejection Reason (optional, if rejecting)</label>
                            <input
                                type="text"
                                wire:model="rejectionReason"
                                placeholder="e.g., BR certificate scan blurry or expired"
                                class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none"
                            />
                        </div>
                    @endif
                </div>

                <div class="pt-3 border-t border-[#F3F4F6] flex items-center justify-end gap-2.5">
                    <button type="button" wire:click="closeDocModal" class="px-4 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer">Close</button>
                    @if ($inspectingApp->status !== 'Rejected')
                        <button type="button" wire:click="rejectFromModal" class="px-4 py-2 rounded-[12px] bg-white border border-rose-200 text-rose-600 hover:bg-rose-50 text-xs font-bold cursor-pointer">Reject Application</button>
                    @endif
                    @if ($inspectingApp->status !== 'Verified')
                        <button type="button" wire:click="approveFromModal" class="px-5 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs">✓ Verify &amp; Grant Badge</button>
                    @endif
                </div>
            </div>
        </div>
    @endif

    {{-- MODAL 2: PART DETAILS & EDIT --}}
    @if ($showPartDetailsModal && $inspectingPart)
        <div class="fixed inset-0 z-50 bg-black/45 backdrop-blur-xs flex items-center justify-center p-4">
            <form wire:submit="savePartEdits" class="w-full max-w-[480px] bg-white rounded-[28px] p-6 space-y-4 shadow-2xl">
                <div class="flex items-center justify-between pb-3 border-b border-[#F3F4F6]">
                    <div>
                        <span class="px-2.5 py-0.5 rounded-full bg-[#ECFDF5] text-[#009A5E] text-[10px] font-extrabold uppercase">{{ $inspectingPart->sku }}</span>
                        <h3 class="text-base font-extrabold text-[#111827] mt-0.5">{{ $inspectingPart->title }}</h3>
                    </div>
                    <button type="button" wire:click="closePartModal" class="text-[#6B7280] hover:text-[#111827] text-lg font-bold p-1 cursor-pointer">✕</button>
                </div>

                <div class="space-y-3 text-xs">
                    <div class="p-3.5 rounded-[16px] bg-[#F7F8FA] border border-[#ECEEF0] space-y-1">
                        <div><strong class="text-[#111827]">Fitment:</strong> {{ $inspectingPart->fitment }}</div>
                        <div><strong class="text-[#111827]">Seller:</strong> {{ $inspectingPart->seller_name }} ({{ $inspectingPart->location }})</div>
                        <div><strong class="text-[#111827]">Condition:</strong> {{ $inspectingPart->condition }}</div>
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Price (LKR)</label>
                            <input type="number" required wire:model="editPartPrice" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                        </div>
                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Available Units</label>
                            <input type="number" required wire:model="editPartStock" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                        </div>
                    </div>
                </div>

                <div class="pt-3 border-t border-[#F3F4F6] flex items-center justify-end gap-2.5">
                    <button type="button" wire:click="closePartModal" class="px-4 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs">Save Price &amp; Stock</button>
                </div>
            </form>
        </div>
    @endif

    {{-- MODAL 3: CREATE SPONSORED CAMPAIGN --}}
    @if ($showCreateAdModal)
        <div class="fixed inset-0 z-50 bg-black/45 backdrop-blur-xs flex items-center justify-center p-4">
            <form wire:submit="createSponsoredAd" class="w-full max-w-[480px] bg-white rounded-[28px] p-6 space-y-3.5 shadow-2xl">
                <div class="flex items-center justify-between pb-2 border-b border-[#F3F4F6]">
                    <h3 class="text-base font-extrabold text-[#111827]">Launch Sponsored Ad Slot</h3>
                    <button type="button" wire:click="closeCreateAdModal" class="text-[#6B7280] hover:text-[#111827] text-lg font-bold p-1 cursor-pointer">✕</button>
                </div>

                <div>
                    <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Brand / Sponsor</label>
                    <input type="text" required wire:model="newAdSponsor" placeholder="e.g., Liqui Moly Sri Lanka" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                </div>

                <div>
                    <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Campaign Headline</label>
                    <input type="text" required wire:model="newAdHeadline" placeholder="e.g., Gen 3 Molygen Synthetic Oil" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Mobile Placement</label>
                        <select wire:model="newAdPlacement" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:outline-none">
                            <option>Mobile Home Hero Carousel</option>
                            <option>Marketplace Sponsored Pin</option>
                            <option>Workshop Directory Banner</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Monthly Contract (LKR)</label>
                        <input type="number" required wire:model="newAdRevenue" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2.5 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                    </div>
                </div>

                <div class="pt-3 border-t border-[#F3F4F6] flex items-center justify-end gap-2.5">
                    <button type="button" wire:click="closeCreateAdModal" class="px-4 py-2 rounded-[12px] bg-[#F1F3F4] text-[#374151] text-xs font-semibold hover:bg-[#E4E9E7] cursor-pointer">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-[12px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs">Launch Campaign in Feed</button>
                </div>
            </form>
        </div>
    @endif
</div>
