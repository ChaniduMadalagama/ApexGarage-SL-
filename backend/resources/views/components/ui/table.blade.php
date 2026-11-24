@props([
    'title' => null,
    'subtitle' => null,
])

<div class="bg-white rounded-[20px] border border-[#ECEEF0] overflow-hidden shadow-2xs">
    @if ($title || isset($actions))
        <div class="px-6 py-4 border-b border-[#ECEEF0] flex flex-wrap items-center justify-between gap-4">
            <div>
                @if ($title)
                    <h3 class="text-base font-bold text-[#0F141A]">{{ $title }}</h3>
                @endif
                @if ($subtitle)
                    <p class="text-xs text-[#616E7C] mt-0.5">{{ $subtitle }}</p>
                @endif
            </div>
            @isset($actions)
                <div class="flex items-center gap-2">
                    {{ $actions }}
                </div>
            @endisset
        </div>
    @endif

    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            @isset($head)
                <thead>
                    <tr class="border-b border-[#ECEEF0] bg-[#F8FAFC] text-[11px] font-bold uppercase tracking-wider text-[#616E7C]">
                        {{ $head }}
                    </tr>
                </thead>
            @endisset
            <tbody class="divide-y divide-[#ECEEF0] text-sm text-[#0F141A]">
                {{ $slot }}
            </tbody>
        </table>
    </div>
</div>
