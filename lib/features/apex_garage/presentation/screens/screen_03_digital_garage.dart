import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen03DigitalGarage extends StatelessWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen03DigitalGarage({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final categories = ['All Builds (3)', 'Track Ready', 'Street Spec', 'Bikes'];

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
                  'Search your garage or mod history',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E959E),
                  ),
                ),
              ),
              Icon(LucideIcons.slidersHorizontal, size: 16, color: Color(0xFF111827)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Category Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: categories.map((cat) {
              final active = state.garageFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => state.setGarageFilter(cat),
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
                      cat,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // Watermark Vehicle Cards
        WatermarkShowcaseCard(
          brand: 'Nissan',
          title: 'Nissan Silvia S15',
          subtitle: 'Spec-R Aero • SR20DET',
          badge: 'Stage 2+',
          watermark: 'SILVIA S15',
          graphicType: 's15_emerald',
          meta1: '2',
          meta2: '6-M.',
          meta3: '14 Mods',
          priceMain: '420',
          priceSub: '/whp',
          selected: state.selectedGarageId == 's15',
          onClick: () {
            state.setSelectedGarageId('s15');
            jumper(4);
          },
        ),

        const SizedBox(height: 12),

        WatermarkShowcaseCard(
          brand: 'Kawasaki',
          title: 'Ninja ZX-4RR KRT',
          subtitle: '399cc In-Line Four • 2024',
          badge: 'Track Spec',
          watermark: 'NINJA ZX-4RR',
          graphicType: 'zx4rr_bike',
          meta1: '1',
          meta2: 'QS.',
          meta3: '8 Mods',
          priceMain: '77',
          priceSub: '/ps',
          selected: state.selectedGarageId == 'zx4rr',
          onClick: () {
            state.setSelectedGarageId('zx4rr');
            jumper(4);
          },
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '03',
      screenTitle: 'Digital Garage Fleet & Specs',
      headerTitle: 'Digital Garage',
      rightHeaderWidget: InkWell(
        onTap: () => jumper(4),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF10B981), width: 1),
          ),
          child: const Icon(LucideIcons.plus, size: 14, color: Color(0xFF009B65)),
        ),
      ),
      activeBottomTab: 'garage',
      onSelectScreen: jumper,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }
}
