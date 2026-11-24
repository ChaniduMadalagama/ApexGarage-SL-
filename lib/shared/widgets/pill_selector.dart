import 'package:flutter/material.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';

class PillSelector extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final List<String>? selectedValues; // For multi-select
  final ValueChanged<String> onSelected;
  final bool isMultiSelect;
  final bool isScrollable;

  PillSelector({
    super.key,
    required this.options,
    String? selectedValue,
    String? selected,
    this.selectedValues,
    ValueChanged<String>? onSelected,
    ValueChanged<String>? onSelect,
    this.isMultiSelect = false,
    this.isScrollable = true,
  })  : selectedValue = selectedValue ?? selected,
        onSelected = onSelected ?? onSelect ?? ((_) {});

  @override
  Widget build(BuildContext context) {
    final chips = options.map((opt) {
      final isSelected = isMultiSelect
          ? (selectedValues?.contains(opt) ?? false)
          : selectedValue == opt;

      return Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 6),
        child: InkWell(
          onTap: () => onSelected(opt),
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mintBg : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? AppColors.emeraldMint : AppColors.neutralBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMultiSelect && isSelected) ...[
                  const Text(
                    '✓ ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ],
                Text(
                  opt,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryEmerald : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    if (!isScrollable) {
      return Wrap(
        children: chips,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips,
      ),
    );
  }
}
