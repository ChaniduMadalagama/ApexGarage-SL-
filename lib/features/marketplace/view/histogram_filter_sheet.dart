import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/histogram_slider.dart';

class HistogramFilterSheet extends StatefulWidget {
  final ApexAppState appState;

  const HistogramFilterSheet({super.key, required this.appState});

  static Future<void> show(BuildContext context, ApexAppState appState) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HistogramFilterSheet(appState: appState),
    );
  }

  @override
  State<HistogramFilterSheet> createState() => _HistogramFilterSheetState();
}

class _HistogramFilterSheetState extends State<HistogramFilterSheet> {
  late double _minPrice;
  late double _maxPrice;
  late List<String> _selectedBrands;
  late String _condition;

  final List<String> _brands = [
    'HKS',
    'Spoon',
    'Akrapovic',
    'Tein',
    'Brembo',
    'Tomei',
    'Bride',
  ];

  @override
  void initState() {
    super.initState();
    _minPrice = widget.appState.minPrice;
    _maxPrice = widget.appState.maxPrice;
    _selectedBrands = List.from(widget.appState.filterBrands);
    _condition = widget.appState.filterCondition;
  }

  void _apply() {
    widget.appState.applyMarketplaceFilters(
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      brands: _selectedBrands,
      condition: _condition,
    );
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _minPrice = 15000;
      _maxPrice = 450000;
      _selectedBrands.clear();
      _condition = '';
    });
    widget.appState.resetFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sheet Title & Reset
            Row(
              children: [
                const Text(
                  'Filters & Price Curve',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _reset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Real-time price distribution across 350+ Colombo JDM listings',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),

            // 36-Bar Bell Curve Histogram & Dual Slider
            HistogramSlider(
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              rangeMin: 15000,
              rangeMax: 450000,
              onPriceChanged: (double min, double max) {
                setState(() {
                  _minPrice = min;
                  _maxPrice = max;
                });
              },
            ),
            const SizedBox(height: 24),

            // Brands
            const Text(
              'TUNER & OEM BRANDS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _brands.map((brand) {
                final isSelected = _selectedBrands.contains(brand);
                return FilterChip(
                  label: Text(brand),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBrands.add(brand);
                      } else {
                        _selectedBrands.remove(brand);
                      }
                    });
                  },
                  selectedColor: AppColors.primarySubtle,
                  backgroundColor: AppColors.inputBackground,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Condition
            const Text(
              'ITEM CONDITION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildConditionOption('All Conditions', ''),
                const SizedBox(width: 8),
                _buildConditionOption('Brand New', 'Brand New'),
                const SizedBox(width: 8),
                _buildConditionOption('Used / Import', 'Used'),
              ],
            ),
            const SizedBox(height: 28),

            // Apply Button
            ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionOption(String label, String value) {
    final isSelected = _condition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _condition = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySubtle : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
