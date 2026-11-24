import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen02Auth extends StatefulWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen02Auth({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  State<Screen02Auth> createState() => _Screen02AuthState();
}

class _Screen02AuthState extends State<Screen02Auth> {
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<GarageAppState>();
    _phoneController = TextEditingController(text: state.authPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = widget.onSelectScreen ?? state.jumpToScreen;

    final chassis = state.quickChassis;
    final String brand;
    final String graphicType;
    final String priceSub;
    final String priceMain;

    if (chassis == 'Porsche 911') {
      brand = 'Porsche';
      graphicType = 'porsche_red';
      priceSub = '/whp';
      priceMain = '420';
    } else if (chassis == 'Ninja ZX-4RR') {
      brand = 'Kawasaki';
      graphicType = 'zx4rr_bike';
      priceSub = '/ps';
      priceMain = '77';
    } else {
      brand = 'Nissan';
      graphicType = 's15_emerald';
      priceSub = '/whp';
      priceMain = '420';
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Credentials Card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Account Credentials',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Laravel Sanctum',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF009B65),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Phone Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.phone, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  onChanged: state.setAuthPhone,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Password Preview
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '••••••••••••',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Verified',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF009B65),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Primary Vehicle Quick-Add Pills
        const Text(
          'Primary Build Class',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTypeChip(
              label: 'Car',
              icon: LucideIcons.car,
              active: state.quickVehicleType == 'Car',
              onTap: () => state.setQuickVehicleType('Car'),
            ),
            const SizedBox(width: 8),
            _buildTypeChip(
              label: 'Motorcycle',
              icon: LucideIcons.bike,
              active: state.quickVehicleType == 'Motorcycle',
              onTap: () => state.setQuickVehicleType('Motorcycle'),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Quick Chassis Preset
        const Text(
          'Quick Chassis Preset',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Silvia S15', 'Porsche 911', 'Ninja ZX-4RR'].map((ch) {
            final active = state.quickChassis == ch;
            return InkWell(
              onTap: () => state.setQuickChassis(ch),
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFECFDF5) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Text(
                  ch,
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

        const SizedBox(height: 18),

        // Digital Garage Preview
        const Text(
          'Digital Garage Preview',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        WatermarkShowcaseCard(
          brand: brand,
          title: chassis,
          subtitle: 'WP CBO-9911 • Registered Owner',
          badge: 'Ready to Log',
          watermark: chassis.toUpperCase(),
          graphicType: graphicType,
          meta1: '1',
          meta2: 'M.',
          meta3: 'Stage 2',
          priceMain: priceMain,
          priceSub: priceSub,
          onClick: () => jumper(3),
        ),
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: () => jumper(5),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          child: const Text(
            'Guest',
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
            onPressed: () => jumper(3),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Sign In & Sync Garage',
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
      screenNumber: '02',
      screenTitle: 'Sanctum Auth & Vehicle Registration',
      headerTitle: 'Sign In & Garage',
      rightHeaderWidget: const Icon(LucideIcons.lock, size: 16, color: Color(0xFF009B65)),
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: widget.isStandalone,
      child: content,
    );
  }

  Widget _buildTypeChip({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
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
              color: active ? const Color(0xFF009B65) : const Color(0xFF6B7280),
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
  }
}
