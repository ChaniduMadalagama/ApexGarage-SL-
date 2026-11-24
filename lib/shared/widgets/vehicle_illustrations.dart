import 'dart:math' as math;
import 'package:flutter/material.dart';

class VehicleIllustration extends StatelessWidget {
  final String type;
  final double width;
  final double height;

  const VehicleIllustration({
    super.key,
    required this.type,
    this.width = 240,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _IllustrationPainter(type: type),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  final String type;

  _IllustrationPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 320.0;
    final scaleY = size.height / 120.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Common Ground Shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFFE5E7EB).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(160, 106), width: 250, height: 14),
      shadowPaint,
    );

    switch (type.toLowerCase()) {
      case 'fd2':
        _drawFD2(canvas);
        break;
      case 'zx4rr':
        _drawZX4RR(canvas);
        break;
      case 's15':
        _drawS15(canvas);
        break;
      case 'turbo':
        _drawTurbo(canvas);
        break;
      case 'caliper':
        _drawCaliper(canvas);
        break;
      case 'exhaust':
        _drawExhaust(canvas);
        break;
      case 'coilover':
        _drawCoilover(canvas);
        break;
      default:
        _drawFD2(canvas);
        break;
    }

    canvas.restore();
  }

  void _drawFD2(Canvas canvas) {
    // Rear Wing
    final wingPath = Path()
      ..moveTo(36, 53)
      ..lineTo(47, 53)
      ..lineTo(53, 62)
      ..lineTo(42, 62)
      ..close();
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFF1F2937));

    final wingBlade = Path()
      ..moveTo(29, 48)
      ..lineTo(56, 48)
      ..lineTo(54, 53)
      ..lineTo(31, 53)
      ..close();
    canvas.drawPath(wingBlade, Paint()..color = Colors.white);
    canvas.drawPath(
      wingBlade,
      Paint()
        ..color = const Color(0xFF1F2937)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Red Type-R badge on wing endplate
    canvas.drawRect(const Rect.fromLTWH(29, 48, 5, 6), Paint()..color = const Color(0xFFDC2626));

    // Car Body Shell (Championship White)
    final body = Path()
      ..moveTo(36, 82)
      ..lineTo(36, 67)
      ..cubicTo(36, 62, 42, 59, 54, 58)
      ..lineTo(84, 55)
      ..lineTo(114, 35)
      ..cubicTo(124, 30, 144, 28, 176, 29)
      ..cubicTo(198, 30, 220, 40, 241, 54)
      ..lineTo(276, 61)
      ..cubicTo(286, 64, 290, 71, 290, 79)
      ..lineTo(290, 87)
      ..lineTo(268, 89)
      ..cubicTo(266, 72, 238, 72, 235, 89)
      ..lineTo(104, 89)
      ..cubicTo(101, 72, 73, 72, 70, 89)
      ..lineTo(42, 88)
      ..cubicTo(38, 87, 36, 85, 36, 82)
      ..close();

    canvas.drawPath(body, Paint()..color = Colors.white);
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFF1F2937)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Front Lip Splitter
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(254, 88, 38, 4), const Radius.circular(2)),
      Paint()..color = const Color(0xFF1F2937),
    );

    // Side Skirt
    canvas.drawRect(const Rect.fromLTWH(104, 89, 131, 3), Paint()..color = const Color(0xFF374151));

    // Windows
    final win1 = Path()
      ..moveTo(95, 54)
      ..lineTo(119, 37)
      ..cubicTo(127, 33, 144, 32, 162, 32)
      ..lineTo(162, 54)
      ..close();
    canvas.drawPath(win1, Paint()..color = const Color(0xFFE5E7EB));
    canvas.drawPath(win1, Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    final win2 = Path()
      ..moveTo(168, 32)
      ..cubicTo(187, 33, 206, 40, 224, 54)
      ..lineTo(168, 54)
      ..close();
    canvas.drawPath(win2, Paint()..color = const Color(0xFFD1D5DB));
    canvas.drawPath(win2, Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Wheels + Red Brembo Caliper
    _drawWheel(canvas, 251, 89, hasBrembo: true);
    _drawWheel(canvas, 87, 89, hasBrembo: false);
  }

  void _drawZX4RR(Canvas canvas) {
    // Wheels with KRT Green Rim Tape
    canvas.drawCircle(const Offset(90, 80), 22, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      const Offset(90, 80),
      15,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(const Offset(90, 80), 8, Paint()..color = const Color(0xFF10B981));

    canvas.drawCircle(const Offset(230, 80), 22, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      const Offset(230, 80),
      15,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(const Offset(230, 80), 8, Paint()..color = const Color(0xFF10B981));

    // Trellis Frame
    final frame = Path()
      ..moveTo(90, 80)
      ..lineTo(140, 52)
      ..lineTo(200, 52)
      ..lineTo(230, 80);
    canvas.drawPath(
      frame,
      Paint()
        ..color = const Color(0xFF374151)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round,
    );

    // KRT Green Fairings
    final fairing = Path()
      ..moveTo(130, 48)
      ..lineTo(180, 42)
      ..lineTo(224, 34)
      ..lineTo(242, 56)
      ..lineTo(202, 72)
      ..lineTo(146, 70)
      ..close();
    canvas.drawPath(fairing, Paint()..color = const Color(0xFF10B981));

    // Black fuel tank
    final tank = Path()
      ..moveTo(80, 42)
      ..lineTo(134, 48)
      ..lineTo(144, 60)
      ..lineTo(98, 58)
      ..close();
    canvas.drawPath(tank, Paint()..color = const Color(0xFF111827));

    // Akrapovic Carbon Exhaust
    canvas.drawLine(
      const Offset(148, 78),
      const Offset(106, 68),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawS15(Canvas canvas) {
    // Aero spoiler
    final wing = Path()
      ..moveTo(40, 50)
      ..lineTo(58, 50)
      ..lineTo(54, 62)
      ..lineTo(44, 62)
      ..close();
    canvas.drawPath(wing, Paint()..color = const Color(0xFF065F46));

    // Silvia S15 Body
    final body = Path()
      ..moveTo(36, 74)
      ..cubicTo(42, 60, 72, 56, 102, 45)
      ..cubicTo(130, 34, 170, 35, 204, 49)
      ..cubicTo(240, 52, 276, 58, 286, 74)
      ..lineTo(284, 88)
      ..lineTo(40, 88)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFF009B65));

    // Cabin
    final cabin = Path()
      ..moveTo(104, 47)
      ..cubicTo(128, 37, 166, 37, 198, 49)
      ..lineTo(178, 56)
      ..lineTo(106, 56)
      ..close();
    canvas.drawPath(cabin, Paint()..color = const Color(0xFF111827));

    // Bronze TE37 Wheels
    _drawTE37Wheel(canvas, 90, 85);
    _drawTE37Wheel(canvas, 235, 85);
  }

  void _drawTurbo(Canvas canvas) {
    // Cast Exhaust Turbine Housing
    canvas.drawCircle(const Offset(180, 64), 30, Paint()..color = const Color(0xFF4B5563));
    canvas.drawCircle(
      const Offset(180, 64),
      30,
      Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawCircle(const Offset(180, 64), 15, Paint()..color = const Color(0xFF1F2937));

    // Center CHRA Cartridge
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(134, 50, 28, 28), const Radius.circular(4)),
      Paint()..color = const Color(0xFF9CA3AF),
    );

    // Compressor Snail Housing (Polished Silver)
    final snail = Path()
      ..moveTo(124, 28)
      ..lineTo(150, 28)
      ..lineTo(150, 50)
      ..cubicTo(164, 56, 166, 82, 148, 94)
      ..cubicTo(128, 106, 96, 96, 92, 72)
      ..cubicTo(88, 48, 106, 36, 124, 36)
      ..close();
    canvas.drawPath(snail, Paint()..color = const Color(0xFFF3F4F6));
    canvas.drawPath(snail, Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Compressor Intake & Billet Wheel
    canvas.drawCircle(const Offset(122, 67), 22, Paint()..color = const Color(0xFFE5E7EB));
    canvas.drawCircle(
      const Offset(122, 67),
      22,
      Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 1.8,
    );
    canvas.drawCircle(const Offset(122, 67), 14, Paint()..color = const Color(0xFF1F2937));
    canvas.drawCircle(const Offset(122, 67), 4, Paint()..color = const Color(0xFF009B65));
  }

  void _drawCaliper(Canvas canvas) {
    // Slotted Rotor Disc
    canvas.drawCircle(const Offset(168, 62), 44, Paint()..color = const Color(0xFFE5E7EB));
    canvas.drawCircle(
      const Offset(168, 62),
      44,
      Paint()..color = const Color(0xFF1F2937)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawCircle(const Offset(168, 62), 22, Paint()..color = const Color(0xFF374151));

    // Slots
    final slotPaint = Paint()..color = const Color(0xFF6B7280)..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(180, 28), const Offset(192, 40), slotPaint);
    canvas.drawLine(const Offset(196, 56), const Offset(204, 72), slotPaint);

    // Spoon Signature Blue-Teal Monoblock 4-Pot Caliper
    final caliper = Path()
      ..moveTo(108, 34)
      ..cubicTo(122, 22, 144, 22, 154, 36)
      ..lineTo(148, 86)
      ..cubicTo(136, 98, 114, 96, 104, 82)
      ..cubicTo(96, 68, 98, 44, 108, 34)
      ..close();
    canvas.drawPath(caliper, Paint()..color = const Color(0xFF2563EB));
    canvas.drawPath(caliper, Paint()..color = const Color(0xFF1E3A8A)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Caliper Badge
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(113, 47, 26, 26), const Radius.circular(5)),
      Paint()..color = const Color(0xFF1D4ED8),
    );
  }

  void _drawExhaust(Canvas canvas) {
    // Titanium Link Pipe
    final pipe = Path()
      ..moveTo(64, 82)
      ..cubicTo(84, 82, 92, 78, 106, 68)
      ..lineTo(128, 62)
      ..lineTo(132, 73)
      ..lineTo(110, 79)
      ..cubicTo(96, 89, 82, 93, 64, 93)
      ..close();
    canvas.drawPath(pipe, Paint()..color = const Color(0xFFD1D5DB));
    canvas.drawLine(const Offset(94, 74), const Offset(98, 85), Paint()..color = const Color(0xFF60A5FA)..strokeWidth = 2.5);

    // Carbon Fiber Muffler Canister
    final canister = Path()
      ..moveTo(126, 54)
      ..lineTo(216, 36)
      ..cubicTo(224, 35, 232, 40, 234, 49)
      ..lineTo(236, 58)
      ..cubicTo(237, 65, 232, 72, 224, 74)
      ..lineTo(132, 84)
      ..close();
    canvas.drawPath(canister, Paint()..color = const Color(0xFF1F2937));
    canvas.drawPath(canister, Paint()..color = const Color(0xFF111827)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Red Akrapovic Emblem
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(168, 54, 28, 11), const Radius.circular(3)),
      Paint()..color = const Color(0xFFDC2626),
    );
  }

  void _drawCoilover(Canvas canvas) {
    // Top Mount
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(138, 16, 44, 10), const Radius.circular(3)),
      Paint()..color = const Color(0xFF009B65),
    );
    // Green Damper Tube
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(151, 26, 18, 66), const Radius.circular(2)),
      Paint()..color = const Color(0xFF009B65),
    );
    // Coils
    final coilPaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;
    for (final y in [34.0, 43.0, 52.0, 61.0]) {
      canvas.drawLine(Offset(141, y), Offset(179, y + 5), coilPaint);
    }
    // Gold Collars
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(144, 68, 32, 5), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFFF59E0B),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(144, 75, 32, 5), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFFF59E0B),
    );
  }

  void _drawWheel(Canvas canvas, double cx, double cy, {bool hasBrembo = false}) {
    canvas.drawCircle(Offset(cx, cy), 19, Paint()..color = const Color(0xFF1F2937));
    canvas.drawCircle(
      Offset(cx, cy),
      13,
      Paint()..color = const Color(0xFFF9FAFB)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    if (hasBrembo) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: 10),
        math.pi * 0.7,
        math.pi * 0.6,
        false,
        Paint()..color = const Color(0xFFDC2626)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = const Color(0xFFDC2626));
  }

  void _drawTE37Wheel(Canvas canvas, double cx, double cy) {
    canvas.drawCircle(Offset(cx, cy), 18, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      Offset(cx, cy),
      12,
      Paint()..color = const Color(0xFFB45309)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = const Color(0xFFF59E0B));
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter oldDelegate) => oldDelegate.type != type;
}
