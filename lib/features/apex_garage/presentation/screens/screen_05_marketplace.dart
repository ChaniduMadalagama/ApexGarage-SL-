import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen05Marketplace extends StatefulWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen05Marketplace({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  State<Screen05Marketplace> createState() => _Screen05MarketplaceState();
}

class _Screen05MarketplaceState extends State<Screen05Marketplace> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final state = context.read<GarageAppState>();
    _searchController = TextEditingController(text: state.marketSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = widget.onSelectScreen ?? state.jumpToScreen;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input with Filter Icon
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.search, size: 16, color: Color(0xFF7C848D)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: state.setMarketSearch,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
                  decoration: const InputDecoration(
                    hintText: 'Search with car model, type or brand name',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF8E959E)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              InkWell(
                onTap: () => jumper(6),
                child: const Icon(LucideIcons.slidersHorizontal, size: 16, color: Color(0xFF111827)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Recent Search List
        const Text(
          'Recent Search',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        ...state.recentSearches.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _searchController.text = item;
                    state.setMarketSearch(item);
                  },
                  child: Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 14, color: Color(0xFF8E959E)),
                      const SizedBox(width: 8),
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => state.removeRecentSearch(item),
                  child: const Icon(LucideIcons.x, size: 14, color: Color(0xFF8E959E)),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // Recently Viewed Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recently Viewed',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            InkWell(
              onTap: () => jumper(6),
              child: Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF009B65),
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFF009B65)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Watermark Showcase Cards
        WatermarkShowcaseCard(
          brand: 'Porsche',
          title: 'Porsche 911',
          subtitle: 'Turbo s - 2021',
          watermark: 'PORSCHE 911',
          graphicType: 'porsche_red',
          meta1: '2',
          meta2: 'M.',
          meta3: '4 Unit',
          priceMain: '\$250',
          priceSub: '/day',
          onClick: () => jumper(6),
        ),

        const SizedBox(height: 12),

        WatermarkShowcaseCard(
          brand: 'HKS',
          title: 'HKS GTIII-RS Turbo',
          subtitle: 'Bolt-on Kit • SR20DET',
          badge: 'Arriving soon',
          watermark: 'HKS GTIII-RS',
          graphicType: 'turbo_part',
          meta1: '1',
          meta2: 'M.',
          meta3: '2 Unit',
          priceMain: 'LKR 485k',
          priceSub: '/kit',
          onClick: () => jumper(4),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '05',
      screenTitle: 'Search & JDM Parts Marketplace',
      headerTitle: 'Search',
      activeBottomTab: 'parts',
      onSelectScreen: jumper,
      isStandalonePhone: widget.isStandalone,
      child: content,
    );
  }
}
