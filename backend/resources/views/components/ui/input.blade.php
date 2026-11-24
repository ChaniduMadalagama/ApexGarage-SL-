@props([
    'label' => null,
    'error' => null,
    'hint' => null,
])

<div class="space-y-1.5">
    @if ($label)
        <label class="block text-xs font-semibold tracking-wide text-[#0F141A] uppercase">
            {{ $label }}
        </label>
    @endif

    <input
        {{ $attributes->merge([
            'class' => 'w-full rounded-xl bg-[#F1F3F4] px-3.5 py-2.5 text-sm text-[#0F141A] placeholder-[#7B8794] border border-transparent focus:border-[#009A5E] focus:bg-white focus:outline-none transition',
        ]) }}
    />

    @if ($hint && ! $error)
        <p class="text-[11px] text-[#616E7C]">{{ $hint }}</p>
    @endif

    @if ($error)
        <p class="text-xs font-medium text-rose-600">{{ $error }}</p>
    @endif
</div>
