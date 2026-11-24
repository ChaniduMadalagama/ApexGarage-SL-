@props(['title' => null, 'message' => null, 'type' => 'success'])

@if ($message)
    <div
        x-data="{ show: true }"
        x-init="setTimeout(() => { show = false; $wire.dismissToast(); }, 4000)"
        x-show="show"
        x-transition:enter="transition ease-out duration-300 transform"
        x-transition:enter-start="opacity-0 translate-y-[-10px] scale-95"
        x-transition:enter-end="opacity-100 translate-y-0 scale-100"
        x-transition:leave="transition ease-in duration-200 transform"
        x-transition:leave-start="opacity-100 translate-y-0 scale-100"
        x-transition:leave-end="opacity-0 translate-y-[-10px] scale-95"
        class="fixed top-16 right-5 z-[999] max-w-sm w-full bg-white rounded-[20px] p-4 border border-[#ECEEF0] shadow-[0_20px_40px_rgba(0,0,0,0.14)] flex items-start gap-3"
    >
        <div class="w-8 h-8 rounded-full flex items-center justify-center shrink-0 {{ $type === 'success' ? 'bg-[#ECFDF5] text-[#009A5E]' : ($type === 'warning' ? 'bg-amber-50 text-amber-600' : 'bg-blue-50 text-blue-600') }}">
            @if ($type === 'success') ✓ @elseif ($type === 'warning') ⚠️ @else ℹ️ @endif
        </div>
        <div class="flex-1 min-w-0">
            <div class="text-xs font-extrabold text-[#111827] leading-tight">
                {{ $title ?? 'ApexGarage Notification' }}
            </div>
            <div class="text-[11.5px] text-[#4B5563] mt-0.5 leading-snug">
                {{ $message }}
            </div>
        </div>
        <button
            type="button"
            wire:click="dismissToast"
            class="text-[#9CA3AF] hover:text-[#111827] text-xs font-bold p-1 cursor-pointer"
        >
            ✕
        </button>
    </div>
@endif
