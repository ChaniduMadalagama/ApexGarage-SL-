@props([
    'tone' => 'emerald',
])

@php
    $classes = match ($tone) {
        'emerald' => 'bg-[#E6F6EF] text-[#009A5E] border-[#B6E8D2]',
        'amber' => 'bg-amber-50 text-amber-700 border-amber-200',
        'indigo' => 'bg-indigo-50 text-indigo-700 border-indigo-200',
        default => 'bg-[#F1F3F4] text-[#52606D] border-[#E4E9E7]',
    };
@endphp

<span {{ $attributes->merge(['class' => "inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-semibold border $classes"]) }}>
    {{ $slot }}
</span>
