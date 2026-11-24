@props([
    'variant' => 'primary',
    'size' => 'md',
    'type' => 'button',
])

@php
    $baseClasses = 'inline-flex items-center justify-center gap-2 font-semibold transition-all duration-150 rounded-xl focus:outline-none focus:ring-2 focus:ring-offset-1 disabled:opacity-50 cursor-pointer';

    $variantClasses = match ($variant) {
        'primary' => 'bg-[#009A5E] text-white hover:bg-[#00824F] focus:ring-[#009A5E] shadow-xs',
        'secondary' => 'bg-[#0F141A] text-white hover:bg-[#1E2732] focus:ring-[#0F141A]',
        'outline' => 'bg-white text-[#0F141A] border border-[#ECEEF0] hover:bg-[#F7F9F8] focus:ring-[#009A5E]',
        'danger' => 'bg-rose-600 text-white hover:bg-rose-700 focus:ring-rose-500',
        default => 'bg-[#F1F3F4] text-[#0F141A] hover:bg-[#E4E9E7]',
    };

    $sizeClasses = match ($size) {
        'sm' => 'px-3 py-1.5 text-xs',
        'lg' => 'px-5 py-3 text-sm',
        default => 'px-4 py-2.5 text-xs',
    };
@endphp

<button type="{{ $type }}" {{ $attributes->merge(['class' => "$baseClasses $variantClasses $sizeClasses"]) }}>
    {{ $slot }}
</button>
