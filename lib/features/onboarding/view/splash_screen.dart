import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final ApexAppState? appState;

  const SplashScreen({super.key, this.appState});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        final state = widget.appState ?? context.read<ApexAppState>();
        if (state.stage == 'splash') {
          state.proceedFromSplash();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState ?? context.watch<ApexAppState>();

    return Scaffold(
      body: InkWell(
        onTap: () => state.proceedFromSplash(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFF9FDFB),
                Color(0xFFECFDF5),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),

                // Center Logo & Title
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minimalist Tachometer / Apex Rotor Emblem
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.surfaceBorder, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(56, 56),
                          painter: _RotorLogoPainter(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Apex',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'Garage',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryEmerald,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Sri Lanka Digital Garage & JDM Marketplace',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 36),

                    // Animated Progress Bar
                    Container(
                      width: 160,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Hint
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Tap anywhere to continue',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryEmerald,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RotorLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer Gauge Arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: 22),
      0.8,
      4.7,
      false,
      Paint()
        ..color = AppColors.primaryEmerald
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    // Apex Rotor Triangle
    final rotor = Path()
      ..moveTo(cx, cy - 14)
      ..cubicTo(cx + 8, cy - 9, cx + 13, cy + 2, cx + 11, cy + 10)
      ..cubicTo(cx + 2, cy + 14, cx - 2, cy + 14, cx - 11, cy + 10)
      ..cubicTo(cx - 13, cy + 2, cx - 8, cy - 9, cx, cy - 14)
      ..close();

    canvas.drawPath(rotor, Paint()..color = const Color(0xFFECFDF5));
    canvas.drawPath(
      rotor,
      Paint()
        ..color = const Color(0xFF111827)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Tachometer Needle
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + 12, cy - 10),
      Paint()
        ..color = AppColors.primaryEmerald
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(Offset(cx, cy), 3.5, Paint()..color = const Color(0xFF111827));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
