import 'package:flutter/material.dart';

class HistogramRangeFilter extends StatelessWidget {
  final String label;
  final double minVal;
  final double maxVal;
  final ValueChanged<RangeValues> onChanged;
  final double maxLimit;
  final String prefix;

  static const List<double> histogramHeights = [
    12, 10, 14, 11, 15, 22, 30, 40, 52, 65, 78, 88, 96, 100, 94, 86, 76, 68, 58,
    50, 44, 38, 32, 26, 22, 18, 15, 17, 14, 12, 10, 13, 11, 9, 12, 10
  ];

  const HistogramRangeFilter({
    super.key,
    this.label = 'Price Range',
    required this.minVal,
    required this.maxVal,
    required this.onChanged,
    this.maxLimit = 3400,
    this.prefix = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),

        // 36 Vertical Histogram Bars
        SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(histogramHeights.length, (index) {
              final posVal = (index / (histogramHeights.length - 1)) * maxLimit;
              final isActive = posVal >= minVal && posVal <= maxVal;
              final h = histogramHeights[index];

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.2),
                  height: (h / 100.0) * 64.0,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFCFD6DC) : const Color(0xFFEAEEF1),
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
            activeTrackColor: const Color(0xFF1F2937),
            inactiveTrackColor: const Color(0xFFE5E7EB),
            thumbColor: const Color(0xFF1F2937),
            overlayColor: const Color(0xFF1F2937).withValues(alpha: 0.1),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 7,
              elevation: 2,
            ),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 7,
              elevation: 2,
            ),
          ),
          child: RangeSlider(
            values: RangeValues(minVal, maxVal),
            min: 50,
            max: maxLimit,
            divisions: (maxLimit / 50).round(),
            onChanged: onChanged,
          ),
        ),

        // Labels below slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$prefix${minVal.toInt()}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                '$prefix${maxVal.toInt()}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Dual Soft-Grey Value Boxes
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '$prefix${minVal.toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '–',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '$prefix${maxVal.toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
