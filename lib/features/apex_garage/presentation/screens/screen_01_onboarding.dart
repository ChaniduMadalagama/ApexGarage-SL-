import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Screen01Onboarding extends StatelessWidget {
  const Screen01Onboarding({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final cultures = [
      'JDM Cars',
      'Superbikes',
      'Rotary',
      'Time Attack',
      'Euro Tuning',
      'K-Series',
    ];

    final brands = [
      'Nissan',
      'Porsche',
      'Honda',
      'Kawasaki',
      'BMW',
      'Subaru',
      'Toyota',
      'Mazda',
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Automotive Culture Section
        const Text(
          'Select Automotive Culture',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Personalize your Sri Lankan Digital Garage & JDM parts feed',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8E959E),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cultures.map((c) {
            final active = state.selectedCultures.contains(c);
            return _buildChip(
              label: c,
              active: active,
              onTap: () => state.toggleCulture(c),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // Preferred Marques Section
        const Text(
          'Preferred Marques',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: brands.map((b) {
            final active = state.onboardBrands.contains(b);
            return _buildChip(
              label: b,
              active: active,
              onTap: () => state.toggleMarque(b),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // Featured Community Build Card
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Community Build',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Colombo SL',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF009B65),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        WatermarkShowcaseCard(
          brand: 'Nissan',
          title: 'Nissan GT-R 2023',
          subtitle: 'Nismo 3.8 v6 • Colombo',
          badge: 'Featured Garage',
          watermark: 'NISSAN GT-R',
          graphicType: 'gtr_white',
          meta1: '1',
          meta2: 'A.',
          meta3: '14 Mods',
          priceMain: '600',
          priceSub: '/whp',
          onClick: () => jumper(3),
        ),
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: () => jumper(3),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Skip',
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
            onPressed: () => jumper(2),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Continue to Garage',
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
      screenNumber: '01',
      screenTitle: 'Onboarding & Culture Setup',
      headerTitle: 'Welcome',
      rightHeaderWidget: const Text(
        '1/2',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF009B65),
        ),
      ),
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }

  Widget _buildChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
