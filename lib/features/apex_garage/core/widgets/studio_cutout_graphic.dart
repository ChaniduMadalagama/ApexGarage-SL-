import 'dart:math' as math;
import 'package:flutter/material.dart';

class StudioCutoutGraphic extends StatelessWidget {
  final String type;
  final double width;
  final double height;

  const StudioCutoutGraphic({
    super.key,
    this.type = 'porsche_red',
    this.width = 230,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CutoutPainter(type: type),
      ),
    );
  }
}

class _CutoutPainter extends CustomPainter {
  final String type;

  _CutoutPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 280.0;
    final scaleY = size.height / 110.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Ground Shadow for all
    final shadowPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(140, 94), width: 216, height: 16),
      shadowPaint,
    );

    switch (type) {
      case 'porsche_red':
        _drawPorscheRed(canvas);
        break;
      case 'gtr_white':
        _drawGtrWhite(canvas);
        break;
      case 's15_emerald':
        _drawS15Emerald(canvas);
        break;
      case 'zx4rr_bike':
        _drawZx4rrBike(canvas);
        break;
      case 'turbo_part':
        _drawTurboPart(canvas);
        break;
      case 'te37_wheel':
        _drawTe37Wheel(canvas);
        break;
      default:
        _drawGenericCar(canvas);
        break;
    }

    canvas.restore();
  }

  void _drawPorscheRed(Canvas canvas) {
    // Rear Wing
    final wingPath = Path()
      ..moveTo(28, 52)
      ..lineTo(48, 52)
      ..lineTo(44, 62)
      ..lineTo(32, 62)
      ..close();
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFF991B1B));
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(24, 49, 28, 4), const Radius.circular(2)),
      Paint()..color = const Color(0xFF111827),
    );

    // Body Silhouette
    final body = Path()
      ..moveTo(26, 72)
      ..cubicTo(28, 58, 52, 54, 78, 46)
      ..cubicTo(102, 32, 146, 30, 178, 45)
      ..cubicTo(208, 49, 244, 56, 254, 70)
      ..cubicTo(257, 76, 255, 84, 246, 86)
      ..lineTo(36, 86)
      ..cubicTo(27, 86, 24, 79, 26, 72)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFDC2626));

    // Cabin Glass
    final cabin = Path()
      ..moveTo(84, 47)
      ..cubicTo(104, 35, 142, 34, 172, 46)
      ..lineTo(156, 54)
      ..lineTo(88, 54)
      ..close();
    canvas.drawPath(cabin, Paint()..color = const Color(0xFF1F2937));

    // Highlight line
    final hlPath = Path()
      ..moveTo(40, 66)
      ..quadraticBezierTo(140, 60, 242, 68);
    canvas.drawPath(
      hlPath,
      Paint()
        ..color = const Color(0xFFFCA5A5).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Side intake vent
    final vent = Path()
      ..moveTo(198, 68)
      ..lineTo(236, 68)
      ..lineTo(232, 76)
      ..lineTo(195, 76)
      ..close();
    canvas.drawPath(vent, Paint()..color = const Color(0xFF111827));

    // Headlight
    canvas.save();
    canvas.translate(232, 59);
    canvas.rotate(14 * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 18, height: 8),
      Paint()..color = const Color(0xFFF8FAFC),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 18, height: 8),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.restore();

    // Wheels
    _drawWheel(canvas, 74, 82, rimColor: const Color(0xFF374151), hubColor: const Color(0xFFDC2626));
    _drawWheel(canvas, 204, 82, rimColor: const Color(0xFF374151), hubColor: const Color(0xFFDC2626));
  }

  void _drawGtrWhite(Canvas canvas) {
    // Nismo GT Wing
    final wingPath = Path()
      ..moveTo(26, 46)
      ..lineTo(44, 46)
      ..lineTo(40, 60)
      ..lineTo(30, 60)
      ..close();
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFF111827));
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(20, 43, 28, 3.5), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFF111827),
    );

    // GT-R White Body
    final body = Path()
      ..moveTo(24, 72)
      ..cubicTo(26, 57, 56, 54, 82, 44)
      ..cubicTo(108, 31, 148, 31, 178, 46)
      ..cubicTo(210, 49, 245, 55, 255, 71)
      ..lineTo(254, 85)
      ..lineTo(28, 85)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFF8FAFC));
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Nismo Red Lower Skirt
    canvas.drawLine(
      const Offset(28, 84),
      const Offset(254, 84),
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 3,
    );

    // Cabin
    final cabin = Path()
      ..moveTo(86, 45)
      ..cubicTo(108, 34, 144, 34, 172, 46)
      ..lineTo(154, 54)
      ..lineTo(90, 54)
      ..close();
    canvas.drawPath(cabin, Paint()..color = const Color(0xFF111827));

    // Nismo Grille
    final grille = Path()
      ..moveTo(220, 64)
      ..lineTo(252, 66)
      ..lineTo(249, 80)
      ..lineTo(216, 80)
      ..close();
    canvas.drawPath(grille, Paint()..color = const Color(0xFF111827));

    // Wheels
    _drawWheel(canvas, 74, 82, rimColor: const Color(0xFF1F2937), hubColor: const Color(0xFF64748B));
    _drawWheel(canvas, 204, 82, rimColor: const Color(0xFF1F2937), hubColor: const Color(0xFF64748B));
  }

  void _drawS15Emerald(Canvas canvas) {
    // Aero spoiler
    final wing = Path()
      ..moveTo(28, 49)
      ..lineTo(44, 49)
      ..lineTo(40, 60)
      ..lineTo(32, 60)
      ..close();
    canvas.drawPath(wing, Paint()..color = const Color(0xFF065F46));

    // Silvia S15 Body (Emerald Green)
    final body = Path()
      ..moveTo(24, 72)
      ..cubicTo(30, 58, 60, 54, 88, 43)
      ..cubicTo(114, 32, 150, 33, 180, 47)
      ..cubicTo(212, 50, 246, 56, 254, 72)
      ..lineTo(252, 85)
      ..lineTo(28, 85)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFF009B65));

    // Cabin
    final cabin = Path()
      ..moveTo(90, 45)
      ..cubicTo(112, 35, 146, 35, 174, 47)
      ..lineTo(156, 54)
      ..lineTo(92, 54)
      ..close();
    canvas.drawPath(cabin, Paint()..color = const Color(0xFF111827));

    // Bronze TE37 Wheels
    _drawWheel(canvas, 74, 82, rimColor: const Color(0xFFB45309), hubColor: const Color(0xFFF59E0B));
    _drawWheel(canvas, 204, 82, rimColor: const Color(0xFFB45309), hubColor: const Color(0xFFF59E0B));
  }

  void _drawZx4rrBike(Canvas canvas) {
    // Wheels with KRT Green Rim Tape
    canvas.drawCircle(const Offset(78, 76), 20, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      const Offset(78, 76),
      13,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(const Offset(78, 76), 8, Paint()..color = const Color(0xFF10B981));

    canvas.drawCircle(const Offset(202, 76), 20, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      const Offset(202, 76),
      13,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(const Offset(202, 76), 8, Paint()..color = const Color(0xFF10B981));

    // Frame
    final frame = Path()
      ..moveTo(78, 76)
      ..lineTo(122, 52)
      ..lineTo(174, 52)
      ..lineTo(202, 76);
    canvas.drawPath(
      frame,
      Paint()
        ..color = const Color(0xFF374151)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    // KRT Green Fairings
    final fairing = Path()
      ..moveTo(114, 48)
      ..lineTo(158, 42)
      ..lineTo(196, 34)
      ..lineTo(212, 54)
      ..lineTo(176, 68)
      ..lineTo(128, 66)
      ..close();
    canvas.drawPath(fairing, Paint()..color = const Color(0xFF10B981));

    // Black engine cover
    final tank = Path()
      ..moveTo(68, 42)
      ..lineTo(116, 48)
      ..lineTo(124, 58)
      ..lineTo(84, 56)
      ..close();
    canvas.drawPath(tank, Paint()..color = const Color(0xFF111827));

    // Exhaust
    canvas.drawLine(
      const Offset(126, 74),
      const Offset(92, 64),
      Paint()
        ..color = const Color(0xFF64748B)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawTurboPart(Canvas canvas) {
    // Cast Turbine Housing
    canvas.drawCircle(
      const Offset(116, 54),
      30,
      Paint()..color = const Color(0xFF475569),
    );
    canvas.drawCircle(
      const Offset(116, 54),
      30,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(const Offset(116, 54), 16, Paint()..color = const Color(0xFF1E293B));

    // Polished Compressor Housing
    canvas.drawCircle(
      const Offset(158, 54),
      32,
      Paint()..color = const Color(0xFFE2E8F0),
    );
    canvas.drawCircle(
      const Offset(158, 54),
      32,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(154, 18, 38, 16), const Radius.circular(5)),
      Paint()..color = const Color(0xFFCBD5E1),
    );
    canvas.drawCircle(const Offset(158, 54), 18, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(const Offset(158, 54), 6, Paint()..color = const Color(0xFF009B65));

    // Billet Blades
    final bladesPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(158, 38), const Offset(158, 70), bladesPaint);
    canvas.drawLine(const Offset(142, 54), const Offset(174, 54), bladesPaint);
    canvas.drawLine(const Offset(147, 43), const Offset(169, 65), bladesPaint);
    canvas.drawLine(const Offset(169, 43), const Offset(147, 65), bladesPaint);
  }

  void _drawTe37Wheel(Canvas canvas) {
    // Outer Wheel Rim
    canvas.drawCircle(const Offset(140, 52), 38, Paint()..color = const Color(0xFF1E293B));
    canvas.drawCircle(
      const Offset(140, 52),
      31,
      Paint()
        ..color = const Color(0xFFFEF3C7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 6 Rays Spokes
    final spokePaint = Paint()
      ..color = const Color(0xFFB45309)
      ..strokeWidth = 6.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(140, 21), const Offset(140, 83), spokePaint);
    canvas.drawLine(const Offset(113, 36), const Offset(167, 68), spokePaint);
    canvas.drawLine(const Offset(167, 36), const Offset(113, 68), spokePaint);

    // Center Hub
    canvas.drawCircle(const Offset(140, 52), 10, Paint()..color = const Color(0xFF78350F));
    canvas.drawCircle(const Offset(140, 52), 4, Paint()..color = const Color(0xFF009B65));
  }

  void _drawGenericCar(Canvas canvas) {
    final body = Path()
      ..moveTo(28, 72)
      ..cubicTo(32, 58, 58, 54, 86, 44)
      ..cubicTo(112, 33, 148, 33, 176, 46)
      ..cubicTo(208, 50, 242, 56, 250, 72)
      ..lineTo(248, 85)
      ..lineTo(30, 85)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFF1F2937));

    final cabin = Path()
      ..moveTo(88, 45)
      ..cubicTo(110, 35, 144, 35, 172, 46)
      ..lineTo(154, 54)
      ..lineTo(90, 54)
      ..close();
    canvas.drawPath(cabin, Paint()..color = const Color(0xFF94A3B8));

    _drawWheel(canvas, 74, 82, rimColor: const Color(0xFFE5E7EB), hubColor: const Color(0xFF111827));
    _drawWheel(canvas, 204, 82, rimColor: const Color(0xFFE5E7EB), hubColor: const Color(0xFF111827));
  }

  void _drawWheel(Canvas canvas, double cx, double cy, {required Color rimColor, required Color hubColor}) {
    canvas.drawCircle(Offset(cx, cy), 17, Paint()..color = const Color(0xFF111827));
    canvas.drawCircle(
      Offset(cx, cy),
      11,
      Paint()
        ..color = rimColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = hubColor);
  }

  @override
  bool shouldRepaint(covariant _CutoutPainter oldDelegate) => oldDelegate.type != type;
}
