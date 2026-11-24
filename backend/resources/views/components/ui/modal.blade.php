@props([
    'name',
    'title',
    'subtitle' => null,
])

<div
    x-data="{ open: false }"
    x-on:open-modal.window="if ($event.detail === '{{ $name }}') open = true"
    x-on:close-modal.window="if ($event.detail === '{{ $name }}') open = false"
    x-on:keydown.escape.window="open = false"
    x-show="open"
    style="display: none;"
    class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#0F141A]/60 backdrop-blur-xs"
>
    <div
        x-on:click.away="open = false"
        class="w-full max-w-lg bg-white rounded-[20px] border border-[#ECEEF0] shadow-xl overflow-hidden"
    >
        <div class="px-6 py-4 border-b border-[#ECEEF0] flex items-center justify-between">
            <div>
                <h3 class="text-base font-bold text-[#0F141A]">{{ $title }}</h3>
                @if ($subtitle)
                    <p class="text-xs text-[#616E7C]">{{ $subtitle }}</p>
                @endif
            </div>
            <button
                type="button"
                x-on:click="open = false"
                class="rounded-lg p-1.5 text-[#616E7C] hover:bg-[#F1F3F4] hover:text-[#0F141A]"
            >
                ✕
            </button>
        </div>

        <div class="p-6">
            {{ $slot }}
        </div>
    </div>
</div>
