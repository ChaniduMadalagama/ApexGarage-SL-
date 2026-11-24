import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen07Workshops extends StatelessWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen07Workshops({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final specializations = [
      'Dyno Tuning',
      'JDM Engine Swap',
      'Rotary Specialist',
      'Superbike ECU',
      'Alignment',
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: const [
              Icon(LucideIcons.search, size: 16, color: Color(0xFF7C848D)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search specialist by engine code or city',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E959E),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Specialization Pills
        const Text(
          'Specialization',
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
          children: specializations.map((sp) {
            final active = state.shopSpecFilter == sp;
            return InkWell(
              onTap: () => state.setShopSpecFilter(sp),
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
                  sp,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Workshop Watermark Cards
        WatermarkShowcaseCard(
          brand: 'Shop',
          title: 'Apex Dyno Lab',
          subtitle: 'Nawala • AWD Mainline Dyno',
          badge: 'Verified Shop',
          watermark: 'APEX DYNO',
          graphicType: 's15_emerald',
          meta1: '4.9★',
          meta1Icon: LucideIcons.star,
          meta2: 'ECU',
          meta2Icon: LucideIcons.zap,
          meta3: '4 Bays',
          meta3Icon: LucideIcons.wrench,
          priceMain: 'LKR 25k',
          priceSub: '/tune',
          onClick: () => jumper(4),
        ),

        const SizedBox(height: 12),

        WatermarkShowcaseCard(
          brand: 'Honda',
          title: 'K-Series Works SL',
          subtitle: 'Rathmalana • Honda & Track Prep',
          badge: 'Top Rated',
          watermark: 'K-SERIES SL',
          graphicType: 'te37_wheel',
          meta1: '4.8★',
          meta1Icon: LucideIcons.star,
          meta2: 'K20A',
          meta2Icon: LucideIcons.gauge,
          meta3: '3 Bays',
          meta3Icon: LucideIcons.wrench,
          priceMain: 'LKR 15k',
          priceSub: '/svc',
          onClick: () => jumper(4),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '07',
      screenTitle: 'Verified Mechanics & Dyno Hubs',
      headerTitle: 'Workshops',
      rightHeaderWidget: const Icon(LucideIcons.shieldCheck, size: 18, color: Color(0xFF009B65)),
      activeBottomTab: 'parts',
      onSelectScreen: jumper,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }
}
