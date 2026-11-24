import 'package:flutter/material.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';

class HistogramSlider extends StatelessWidget {
  final String label;
  final double minVal;
  final double maxVal;
  final ValueChanged<RangeValues> onChanged;
  final double minLimit;
  final double maxLimit;
  final String currencyPrefix;

  static const List<double> histogramBars = [
    10, 12, 14, 11, 16, 22, 30, 42, 54, 66, 78, 88, 96, 100, 95, 86, 76, 68,
    58, 50, 44, 38, 34, 29, 24, 20, 18, 16, 14, 15, 13, 12, 10, 11, 9, 10
  ];

  HistogramSlider({
    super.key,
    this.label = 'Price Range (LKR)',
    double? minVal,
    double? minPrice,
    double? maxVal,
    double? maxPrice,
    ValueChanged<RangeValues>? onChanged,
    void Function(double min, double max)? onPriceChanged,
    double? rangeMin,
    double? rangeMax,
    double maxLimit = 500000,
    this.currencyPrefix = 'LKR ',
  })  : minVal = minVal ?? minPrice ?? 15000,
        maxVal = maxVal ?? maxPrice ?? 450000,
        minLimit = rangeMin ?? 10000,
        maxLimit = rangeMax ?? maxLimit,
        onChanged = onChanged ??
            (onPriceChanged != null
                ? ((RangeValues v) => onPriceChanged(v.start, v.end))
                : ((_) {}));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // 36 Vertical Histogram Bars
        SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(histogramBars.length, (index) {
              final posVal = minLimit + (index / (histogramBars.length - 1)) * (maxLimit - minLimit);
              final isActive = posVal >= minVal && posVal <= maxVal;
              final h = histogramBars[index];

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.2),
                  height: (h / 100.0) * 64.0,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent.withValues(alpha: 0.6) : const Color(0xFFEAEEF1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              );
            }),
          ),
        ),

        // Dual Range Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.5,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFE5E7EB),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7, elevation: 2),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 7, elevation: 2),
          ),
          child: RangeSlider(
            values: RangeValues(minVal.clamp(minLimit, maxLimit), maxVal.clamp(minLimit, maxLimit)),
            min: minLimit,
            max: maxLimit,
            divisions: 50,
            onChanged: onChanged,
          ),
        ),

        // Dual Soft-Grey Value Boxes
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.inputSoftGrey,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '$currencyPrefix${_formatNumber(minVal.toInt())}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('–', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.inputSoftGrey,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '$currencyPrefix${_formatNumber(maxVal.toInt())}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return s.replaceAllMapped(reg, (Match m) => '${m[1]},');
    }
    return n.toString();
  }
}
