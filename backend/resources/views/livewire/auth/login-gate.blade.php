<div class="min-h-screen w-full bg-[#E4E9E7] text-[#111827] font-sans antialiased flex flex-col">
    <!-- Clean Portal Header (No Fake Role Switcher) -->
    <header class="bg-white/95 backdrop-blur-md border-b border-[#D8E0DC] px-6 py-3 flex items-center justify-between">
        <div class="flex items-center gap-2.5">
            <div class="w-8 h-8 rounded-xl bg-[#009A5E] text-white flex items-center justify-center font-black text-xs shadow-xs">
                AG
            </div>
            <div>
                <span class="text-sm font-extrabold tracking-tight text-[#111827]">
                    Apex<span class="text-[#009A5E]">Garage</span> <span class="text-[#6B7280] font-semibold">· Partner &amp; Admin Portal</span>
                </span>
                <span class="hidden sm:inline-block ml-2 px-2 py-0.5 rounded-full bg-[#E6F6EF] text-[#009A5E] text-[10px] font-bold">
                    {{ $tenant?->name ?? 'Colombo HQ' }}
                </span>
            </div>
        </div>
        <span class="text-xs font-semibold text-[#6B7280]">
            🔒 Sanctum &amp; Spatie RBAC Protected
        </span>
    </header>

    <div class="flex-1 flex items-center justify-center p-4 sm:p-6 md:p-8">
        <div class="w-full max-w-[980px] bg-white rounded-[28px] border border-[#ECEEF0] shadow-[0_20px_50px_rgba(17,24,39,0.08)] overflow-hidden grid grid-cols-1 md:grid-cols-12">
            <!-- Left Brand & Ecosystem Panel -->
            <div class="md:col-span-5 bg-gradient-to-br from-[#064E3B] via-[#047857] to-[#009A5E] text-white p-7 md:p-9 flex flex-col justify-between">
                <div>
                    <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/15 text-[11px] font-bold tracking-wide">
                        <span>🛡️ ROLE-BASED ACCESS CONTROL</span>
                    </div>

                    <h1 class="text-[26px] font-extrabold tracking-tight mt-5 leading-tight">
                        Centralized Control for Sri Lanka's Automotive Ecosystem
                    </h1>
                    <p class="text-[13px] text-emerald-100 mt-3 leading-relaxed">
                        Sign in with your verified credentials to access platform administration or your shop &amp; workshop storefront.
                    </p>
                </div>

                <div class="space-y-4 mt-8 pt-6 border-t border-white/15 text-[12px]">
                    <div class="flex items-start gap-2.5">
                        <span class="text-base">🛡️</span>
                        <div>
                            <strong class="block font-bold">Super Admin Console</strong>
                            <span class="text-emerald-100/85">
                                Verify BR documents, moderate parts, track Dialog IdeaBiz carrier revenue &amp; manage sponsored ads.
                            </span>
                        </div>
                    </div>
                    <div class="flex items-start gap-2.5">
                        <span class="text-base">🏪</span>
                        <div>
                            <strong class="block font-bold">Shop &amp; Seller Hub</strong>
                            <span class="text-emerald-100/85">
                                Manage JDM stock by chassis code, reply to buyer offers &amp; confirm dyno/workshop bookings.
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Login / Registration Form -->
            <div class="md:col-span-7 p-7 md:p-9 flex flex-col justify-center">
                <div class="flex bg-[#F1F3F4] p-1 rounded-full mb-6">
                    <button
                        type="button"
                        wire:click="selectLoginTab('admin')"
                        class="flex-1 py-2 rounded-full text-xs font-bold flex items-center justify-center gap-1.5 transition-all cursor-pointer {{ $loginRoleTab === 'admin' ? 'bg-white text-[#111827] shadow-2xs' : 'text-[#6B7280]' }}"
                    >
                        <span>🛡️ Super Admin Login</span>
                    </button>
                    <button
                        type="button"
                        wire:click="selectLoginTab('seller')"
                        class="flex-1 py-2 rounded-full text-xs font-bold flex items-center justify-center gap-1.5 transition-all cursor-pointer {{ $loginRoleTab === 'seller' ? 'bg-white text-[#111827] shadow-2xs' : 'text-[#6B7280]' }}"
                    >
                        <span>🏪 Shop / Part Seller Login</span>
                    </button>
                </div>

                @if ($loginRoleTab === 'seller')
                    <div class="flex items-center justify-between mb-4 pb-3 border-b border-[#F3F4F6]">
                        <span class="text-xs font-semibold text-[#6B7280]">
                            {{ $portalMode === 'login' ? 'Existing Verified Merchant' : 'Register a New Shop / Workshop' }}
                        </span>
                        <button
                            type="button"
                            wire:click="togglePortalMode('{{ $portalMode === 'login' ? 'register' : 'login' }}')"
                            class="text-xs font-bold text-[#009A5E] hover:underline cursor-pointer"
                        >
                            {{ $portalMode === 'login' ? '+ Apply as Verified Shop' : '← Back to Merchant Login' }}
                        </button>
                    </div>
                @endif

                @if ($portalMode === 'login')
                    <form wire:submit="authenticate" class="space-y-4">
                        <div>
                            <h2 class="text-xl font-extrabold text-[#111827]">
                                {{ $loginRoleTab === 'admin' ? 'Platform Administrator Sign In' : 'Merchant & Workshop Sign In' }}
                            </h2>
                            <p class="text-xs text-[#6B7280] mt-0.5">
                                {{ $loginRoleTab === 'admin' ? 'Requires super-admin role authorization.' : 'Requires workshop-partner role authorization.' }}
                            </p>
                        </div>

                        <div class="space-y-1.5">
                            <label class="text-xs font-semibold text-[#374151] block">Work Email</label>
                            <input
                                type="email"
                                required
                                wire:model="email"
                                placeholder="{{ $loginRoleTab === 'admin' ? 'admin@apexgarage.lk' : 'sales@jdmdirect.lk' }}"
                                class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-3 text-sm text-[#111827] focus:bg-white focus:ring-2 focus:ring-[#009A5E] focus:outline-none transition"
                            />
                            @error('email') <span class="text-rose-600 text-xs font-semibold block">{{ $message }}</span> @enderror
                        </div>

                        <div class="space-y-1.5">
                            <label class="text-xs font-semibold text-[#374151] block">Password</label>
                            <input
                                type="password"
                                required
                                wire:model="password"
                                placeholder="••••••••"
                                class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-3 text-sm text-[#111827] focus:bg-white focus:ring-2 focus:ring-[#009A5E] focus:outline-none transition"
                            />
                            @error('password') <span class="text-rose-600 text-xs font-semibold block">{{ $message }}</span> @enderror
                        </div>

                        <div class="flex items-center justify-between text-xs">
                            <label class="flex items-center gap-2 text-[#4B5563] cursor-pointer">
                                <input type="checkbox" wire:model="remember" class="rounded border-gray-300 text-[#009A5E] focus:ring-[#009A5E]" />
                                <span>Keep me signed in</span>
                            </label>
                            <button
                                type="button"
                                wire:click="fillDemoCredentials('{{ $loginRoleTab }}')"
                                class="text-[11px] font-semibold text-[#009A5E] hover:underline cursor-pointer"
                            >
                                Fill seeded {{ $loginRoleTab }} credentials
                            </button>
                        </div>

                        <button
                            type="submit"
                            class="w-full py-3.5 rounded-[14px] bg-[#009A5E] hover:bg-[#00824F] text-white text-sm font-bold transition shadow-xs cursor-pointer flex items-center justify-center gap-2"
                        >
                            <span>{{ $loginRoleTab === 'admin' ? 'Sign In to Super Admin Console' : 'Sign In to Merchant Hub' }}</span>
                            <span>→</span>
                        </button>

                        {{-- TODO(remove-for-prod): Quick-fill seeded test accounts --}}
                        <div class="pt-3 border-t border-dashed border-[#E5E7EB] space-y-2">
                            <div class="flex items-center justify-between">
                                <span class="text-[10px] font-bold uppercase tracking-wider text-[#9CA3AF]">
                                    Test Quick-Fill (Remove for Prod)
                                </span>
                                <span class="text-[10px] text-[#9CA3AF]">pw: password</span>
                            </div>
                            <div class="grid grid-cols-2 gap-1.5">
                                <button
                                    type="button"
                                    wire:click="fillTestAccount('admin', 'admin@apexgarage.lk')"
                                    class="px-2.5 py-1.5 rounded-[10px] bg-[#F3F4F6] hover:bg-[#E5E7EB] text-[11px] font-semibold text-[#111827] text-left cursor-pointer transition"
                                >
                                    Admin · Kavindu
                                </button>
                                <button
                                    type="button"
                                    wire:click="fillTestAccount('seller', 'sales@jdmdirect.lk')"
                                    class="px-2.5 py-1.5 rounded-[10px] bg-[#F3F4F6] hover:bg-[#E5E7EB] text-[11px] font-semibold text-[#111827] text-left cursor-pointer transition"
                                >
                                    Shop 1 · JDM Direct
                                </button>
                                <button
                                    type="button"
                                    wire:click="fillTestAccount('seller', 'moto@hillcountry.lk')"
                                    class="px-2.5 py-1.5 rounded-[10px] bg-[#F3F4F6] hover:bg-[#E5E7EB] text-[11px] font-semibold text-[#111827] text-left cursor-pointer transition"
                                >
                                    Shop 2 · HillCountry
                                </button>
                                <button
                                    type="button"
                                    wire:click="fillTestAccount('seller', 'parts@boostyard.lk')"
                                    class="px-2.5 py-1.5 rounded-[10px] bg-[#F3F4F6] hover:bg-[#E5E7EB] text-[11px] font-semibold text-[#111827] text-left cursor-pointer transition"
                                >
                                    Shop 3 · BoostYard
                                </button>
                            </div>
                        </div>
                    </form>
                @else
                    <!-- Real Merchant Account & BR Application Form -->
                    <form wire:submit="registerMerchant" class="space-y-3">
                        <h2 class="text-lg font-extrabold text-[#111827]">
                            Register Merchant Account &amp; BR
                        </h2>
                        <p class="text-xs text-[#6B7280]">
                            Creates your authenticated partner account and queues your BR documents for Admin review.
                        </p>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Shop / Garage Name</label>
                                <input type="text" required wire:model="regShopName" placeholder="Tokyo Imports Colombo" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                                @error('regShopName') <span class="text-rose-600 text-[11px]">{{ $message }}</span> @enderror
                            </div>
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Owner Full Name</label>
                                <input type="text" required wire:model="regOwnerName" placeholder="Nimal Silva" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                                @error('regOwnerName') <span class="text-rose-600 text-[11px]">{{ $message }}</span> @enderror
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Work Email</label>
                                <input type="email" required wire:model="regEmail" placeholder="owner@tokyoimports.lk" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                                @error('regEmail') <span class="text-rose-600 text-[11px]">{{ $message }}</span> @enderror
                            </div>
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Password (min 8 chars)</label>
                                <input type="password" required wire:model="regPassword" placeholder="••••••••" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                                @error('regPassword') <span class="text-rose-600 text-[11px]">{{ $message }}</span> @enderror
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">BR Number</label>
                                <input type="text" required wire:model="regBrNumber" placeholder="PV-0029184" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                                @error('regBrNumber') <span class="text-rose-600 text-[11px]">{{ $message }}</span> @enderror
                            </div>
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Hotline</label>
                                <input type="text" required wire:model="regPhone" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                            </div>
                            <div>
                                <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">City / District</label>
                                <input type="text" required wire:model="regLocation" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:bg-white focus:outline-none" />
                            </div>
                        </div>

                        <div>
                            <label class="text-[11.5px] font-semibold text-[#374151] block mb-1">Business Category</label>
                            <select wire:model="regShopType" class="w-full bg-[#F1F3F4] rounded-[12px] px-3.5 py-2 text-xs text-[#111827] focus:outline-none">
                                <option>JDM Parts Importer</option>
                                <option>Verified Tuning Workshop</option>
                                <option>Superbike Parts &amp; Exhausts</option>
                                <option>Recond Performance Parts</option>
                            </select>
                        </div>

                        <button
                            type="submit"
                            class="w-full py-3 rounded-[14px] bg-[#009A5E] hover:bg-[#00824F] text-white text-xs font-bold cursor-pointer transition shadow-xs"
                        >
                            Create Merchant Account &amp; Submit BR for Review
                        </button>
                    </form>
                @endif
            </div>
        </div>
    </div>
</div>
