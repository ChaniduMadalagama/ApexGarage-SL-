import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen10Ideabiz extends StatefulWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen10Ideabiz({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  State<Screen10Ideabiz> createState() => _Screen10IdeabizState();
}

class _Screen10IdeabizState extends State<Screen10Ideabiz> {
  late TextEditingController _dialogPhoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<GarageAppState>();
    _dialogPhoneController = TextEditingController(text: state.dialogNumber);
  }

  @override
  void dispose() {
    _dialogPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = widget.onSelectScreen ?? state.jumpToScreen;

    final plans = ['Monthly PRO • LKR 490', 'Annual Pass • LKR 4,500'];
    final gateways = ['Dialog 077 / 076', 'Ideamart USSD'];
    final benefits = [
      'Unlimited Build Logs',
      'Verified Seller Badge',
      'Zero Sponsored Ads',
      'Instant Part Alerts',
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carrier Plan Section
        const Text(
          'Select Carrier Plan',
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
          children: plans.map((pl) {
            final active = state.subPlan == pl;
            return InkWell(
              onTap: () => state.setSubPlan(pl),
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
                  pl,
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

        const SizedBox(height: 14),

        // Sri Lankan Carrier Gateway
        const Text(
          'Sri Lankan Carrier Gateway',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: gateways.map((gw) {
            final active = state.carrierNetwork == gw;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => state.setCarrierNetwork(gw),
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
                    gw,
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

        const SizedBox(height: 14),

        // PRO Member Benefits
        const Text(
          'PRO Member Benefits',
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
          children: benefits.map((b) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Text(
                '✓ $b',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF009B65),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Dialog IdeaBiz Direct Billing Boxes
        const Text(
          'Dialog IdeaBiz Direct Billing',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dialog MSISDN',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(
                width: 130,
                child: TextField(
                  controller: _dialogPhoneController,
                  textAlign: TextAlign.right,
                  onChanged: state.setDialogNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
                'IdeaBiz SMS OTP',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                '8  4  9  2',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Color(0xFF009B65),
                ),
              ),
            ],
          ),
        ),

        if (state.otpSubscribed) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            alignment: Alignment.center,
            child: const Text(
              '✓ Subscribed! LKR 490/mo billed via IdeaBiz API Ref #IBZ-2026',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF009B65),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: () => state.otpSubscribed ? state.toggleOtpSubscribed() : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          child: const Text(
            'Restore',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: state.toggleOtpSubscribed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              state.otpSubscribed ? '✓ Active via Dialog 077' : 'Subscribe via Dialog',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '10',
      screenTitle: 'Dialog IdeaBiz Carrier Billing',
      headerTitle: 'IdeaBiz PRO',
      rightHeaderWidget: const Icon(LucideIcons.award, size: 18, color: Color(0xFF009B65)),
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: widget.isStandalone,
      child: content,
    );
  }
}
