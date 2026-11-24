import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/watermark_card.dart';
import 'package:apexgarage_sl/shared/widgets/pill_selector.dart';
import 'package:apexgarage_sl/features/marketplace/view/part_detail_view.dart';
import 'package:apexgarage_sl/features/marketplace/view/histogram_filter_sheet.dart';
import 'package:apexgarage_sl/features/marketplace/view/sell_part_sheet.dart';
import 'package:apexgarage_sl/features/mechanics/view/mechanics_view.dart';

class MarketplaceView extends StatefulWidget {
  final ApexAppState appState;

  const MarketplaceView({super.key, required this.appState});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.appState.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    if (appState.selectedPart != null) {
      return PartDetailView(part: appState.selectedPart!, appState: appState);
    }

    if (appState.marketSubTab == 'Mechanics') {
      return MechanicsView(appState: appState);
    }

    // Filter parts
    final filteredParts = appState.parts.where((p) {
      // Query filter
      if (appState.searchQuery.isNotEmpty) {
        final q = appState.searchQuery.toLowerCase();
        final match = p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q);
        if (!match) return false;
      }
      // Brand filter
      if (appState.filterBrands.isNotEmpty && !appState.filterBrands.contains(p.brand)) {
        return false;
      }
      // Price range
      if (p.price < appState.minPrice || p.price > appState.maxPrice) {
        return false;
      }
      // Condition
      if (appState.filterCondition.isNotEmpty && !p.condition.contains(appState.filterCondition)) {
        return false;
      }
      return true;
    }).toList();

    final isFilterActive = appState.filterBrands.isNotEmpty ||
        appState.minPrice > 15000 ||
        appState.maxPrice < 450000 ||
        appState.filterCondition.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            // Sub-tabs: Parts vs Mechanics
            Row(
              children: [
                Expanded(
                  child: PillSelector(
                    options: const ['Parts', 'Mechanics'],
                    selected: appState.marketSubTab,
                    onSelect: (val) => appState.setMarketSubTab(val),
                  ),
                ),
                IconButton(
                  onPressed: () => SellPartSheet.show(context, appState),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar & Filter Button
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => appState.setSearchQuery(val),
                            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              hintText: 'Search JDM parts, calipers, turbos...',
                              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              appState.setSearchQuery('');
                            },
                            child: const Icon(LucideIcons.x, size: 16, color: AppColors.textMuted),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => HistogramFilterSheet.show(context, appState),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFilterActive ? AppColors.primarySubtle : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isFilterActive ? AppColors.accent : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          LucideIcons.slidersHorizontal,
                          size: 18,
                          color: isFilterActive ? AppColors.primary : AppColors.textPrimary,
                        ),
                        if (isFilterActive)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recent Searches Chips
            if (appState.recentSearches.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: appState.recentSearches.map((search) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _searchController.text = search;
                              appState.setSearchQuery(search);
                            },
                            child: Text(
                              search,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => appState.removeRecentSearch(search),
                            child: const Icon(LucideIcons.x, size: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 14),

            // Results count
            Row(
              children: [
                Text(
                  '${filteredParts.length} verified listings',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Islandwide Courier',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Parts List
            if (filteredParts.isEmpty)
              Container(
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.packageOpen, size: 40, color: AppColors.textMuted),
                    const SizedBox(height: 10),
                    const Text(
                      'No Parts Found',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Try clearing filters or adjusting your price range.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        appState.setSearchQuery('');
                        appState.resetFilter();
                      },
                      child: const Text('Reset All Filters'),
                    ),
                  ],
                ),
              )
            else
              ...filteredParts.map((part) {
                final formattedPrice = 'LKR ${part.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: WatermarkCard(
                    brand: part.brand,
                    title: part.title,
                    subtitle: part.subtitle,
                    watermark: part.watermark,
                    illustrationKey: part.illustration,
                    photoUrl: part.photoUrl,
                    statusBadge: part.condition,
                    metricValue: formattedPrice,
                    metricUnit: '',
                    specs: part.specs,
                    accentColor: AppColors.primary,
                    onTap: () => appState.selectPart(part.id),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
