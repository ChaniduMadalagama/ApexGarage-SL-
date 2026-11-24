import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen08Meets extends StatelessWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen08Meets({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final crews = [
      'Colombo JDM Crew',
      'Lanka K-Club',
      'Apex Superbikes',
      'Rotary Underground',
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clean Google Maps Viewport Simulation
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECEEF0)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Custom Painted Map Grid & Roads
              CustomPaint(
                size: const Size(double.infinity, 140),
                painter: _MapRoadsPainter(),
              ),

              // Overlay Pills
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Text(
                            '📍 Google Maps • Colombo Live',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF009B65),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            '3 Active Pins',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: const Text(
                            'Port City Marina',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF009B65),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Text(
                            'Kottawa E01',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Active Sri Lankan Crews Pills
        const Text(
          'Active Sri Lankan Crews',
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
          children: crews.map((cr) {
            final active = state.selectedCrew == cr;
            return InkWell(
              onTap: () => state.setSelectedCrew(cr),
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
                  cr,
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

        // Upcoming Meet Watermark Card
        WatermarkShowcaseCard(
          brand: 'Meet',
          title: 'Port City Midnight Meet',
          subtitle: 'Sunday 9:00 PM • Marina Promenade',
          badge: state.rsvpConfirmed ? '69 Attending' : '68 Attending',
          watermark: 'PORT CITY MEET',
          graphicType: 'gtr_white',
          meta1: state.rsvpConfirmed ? '69' : '68',
          meta1Icon: LucideIcons.users,
          meta2: 'JDM',
          meta2Icon: LucideIcons.gitCommit,
          meta3: 'Colombo 01',
          meta3Icon: LucideIcons.mapPin,
          priceMain: 'Free',
          priceSub: '/entry',
          onClick: state.toggleRsvp,
        ),
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            'Create Crew',
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
            onPressed: state.toggleRsvp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              state.rsvpConfirmed ? '✓ RSVP Confirmed (69)' : 'RSVP to Meet',
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
      screenNumber: '08',
      screenTitle: 'Crews & Google Maps Meets',
      headerTitle: 'Crews & Meets',
      rightHeaderWidget: const Icon(LucideIcons.mapPin, size: 18, color: Color(0xFF009B65)),
      activeBottomTab: 'meets',
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }
}

class _MapRoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Expressway Green Accent Highway
    final highwayPaint = Paint()
      ..color = const Color(0xFFA7F3D0).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(130, 70, 110, 150);
    canvas.drawPath(path, highwayPaint);

    // Secondary Arterials
    final roadPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawLine(const Offset(50, 0), const Offset(140, 150), roadPaint);
    canvas.drawLine(const Offset(20, 75), const Offset(340, 55), roadPaint);
    canvas.drawLine(const Offset(100, 115), const Offset(340, 125), roadPaint);

    // Pin indicator dots
    canvas.drawCircle(const Offset(120, 60), 6, Paint()..color = const Color(0xFF009B65));
    canvas.drawCircle(const Offset(120, 60), 10, Paint()..color = const Color(0xFF009B65).withValues(alpha: 0.2));

    canvas.drawCircle(const Offset(240, 58), 5, Paint()..color = const Color(0xFFDC2626));
    canvas.drawCircle(const Offset(280, 122), 5, Paint()..color = const Color(0xFF2563EB));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
