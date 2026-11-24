@props([
    'label',
    'value',
    'subtitle' => null,
    'watermark' => 'APEX',
    'tone' => 'emerald',
])

<div class="relative overflow-hidden bg-white rounded-[20px] border border-[#ECEEF0] p-5 shadow-2xs">
    <span class="pointer-events-none select-none absolute -right-2 -bottom-3 text-5xl font-black tracking-tighter text-[#0F141A]/[0.04]">
        {{ $watermark }}
    </span>

    <div class="relative z-10 flex flex-col justify-between h-full space-y-3">
        <div class="flex items-center justify-between">
            <span class="text-[11px] font-bold uppercase tracking-wider text-[#616E7C]">{{ $label }}</span>
            <x-ui.badge :tone="$tone">{{ $watermark }}</x-ui.badge>
        </div>

        <div>
            <div class="text-2xl font-extrabold tracking-tight text-[#0F141A]">{{ $value }}</div>
            @if ($subtitle)
                <p class="mt-1 text-xs font-medium text-[#616E7C]">{{ $subtitle }}</p>
            @endif
        </div>
    </div>
</div>
