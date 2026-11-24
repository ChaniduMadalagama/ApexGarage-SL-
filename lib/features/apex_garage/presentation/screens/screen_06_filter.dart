import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/histogram_range_filter.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen06Filter extends StatelessWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen06Filter({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final brands = [
      'Aston Martin',
      'Porsche',
      'BMW',
      'Corvette',
      'Ferrari',
      'Mercedes',
      'KTM',
      'Volvo',
      'Nissan',
    ];

    final features = [
      {'label': 'Air Conditioner', 'icon': LucideIcons.wind},
      {'label': 'Manual', 'icon': LucideIcons.gitCommit},
      {'label': 'Automatic', 'icon': LucideIcons.gitCommit},
      {'label': 'Electric', 'icon': LucideIcons.zap},
      {'label': 'Gas', 'icon': LucideIcons.fuel},
      {'label': 'Verified JDM', 'icon': LucideIcons.shieldCheck},
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Section
        const Text(
          'Brand',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: brands.map((b) {
            final active = state.filterBrands.contains(b);
            return InkWell(
              onTap: () => state.toggleFilterBrand(b),
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFECFDF5) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Text(
                  b,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        Row(
          children: const [
            Text(
              'Show all',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF009B65),
              ),
            ),
            SizedBox(width: 4),
            Icon(LucideIcons.chevronDown, size: 14, color: Color(0xFF009B65)),
          ],
        ),

        const SizedBox(height: 16),

        // Price Range 36-bar Histogram
        HistogramRangeFilter(
          label: 'Price Range',
          minVal: state.minPrice,
          maxVal: state.maxPrice,
          onChanged: (vals) => state.setPriceRange(vals.start, vals.end),
          maxLimit: 3400,
          prefix: '\$',
        ),

        const SizedBox(height: 16),

        // Rental Type
        const Text(
          'Rental Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['Long-term', 'Short-term'].map((rt) {
            final active = state.rentalType == rt;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => state.setRentalType(rt),
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFECFDF5) : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    rt,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Features with Thin-Stroke Icons
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: features.map((f) {
            final label = f['label'] as String;
            final icon = f['icon'] as IconData;
            final active = state.filterFeatures.contains(label);

            return InkWell(
              onTap: () => state.toggleFilterFeature(label),
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFECFDF5) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: active ? const Color(0xFF009B65) : const Color(0xFF4B5563),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: state.clearFilterAll,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Clear all',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => jumper(5),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Show 145 results',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '06',
      screenTitle: 'Interactive Filter & Price Histogram',
      headerTitle: 'Filter',
      rightHeaderWidget: const Icon(LucideIcons.chevronUp, size: 20, color: Color(0xFF111827)),
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }
}
