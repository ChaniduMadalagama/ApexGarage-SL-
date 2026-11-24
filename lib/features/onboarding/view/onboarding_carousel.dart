import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/shared/widgets/vehicle_illustrations.dart';

class OnboardingCarousel extends StatelessWidget {
  final ApexAppState? appState;

  const OnboardingCarousel({super.key, this.appState});

  @override
  Widget build(BuildContext context) {
    final state = appState ?? context.watch<ApexAppState>();
    final step = state.onboardingStep;

    final stepsData = [
      {
        'tag': 'DIGITAL GARAGE',
        'illustration': 'fd2',
        'pill1': '242 WHP Dyno',
        'pill2': 'Verified Logs',
        'title': 'Track Every Build',
        'desc':
            'Document every dyno sheet, suspension setup, and workshop receipt in one clean timeline for your car or superbike.',
      },
      {
        'tag': 'VERIFIED JDM MARKETPLACE',
        'illustration': 'turbo',
        'pill1': 'SR20DET · K20A',
        'pill2': 'Colombo & Islandwide',
        'title': 'Source Verified JDM Parts',
        'desc':
            'Filter rare JDM & performance parts by chassis code, price range, and verified Sri Lankan sellers.',
      },
      {
        'tag': 'CREWS & TRACK MEETS',
        'illustration': 'zx4rr',
        'pill1': 'Port City Meets',
        'pill2': 'Cars & Superbikes',
        'title': 'Join Local Crews & Meets',
        'desc':
            'Discover midnight meets at Port City, Southern Expressway breakfast runs, and verified tuning workshops.',
      },
    ];

    final current = stepsData[step];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mintBg,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.emeraldMint.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '0${step + 1} / 03',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      state.saveOnboarding();
                      state.setStage('app');
                      state.setActiveTab('home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              // Center Visual Stage
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Column(
                      children: [
                        Text(
                          current['tag'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const SizedBox(height: 12),
                        VehicleIllustration(
                          type: current['illustration'] as String,
                          width: 260,
                          height: 110,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: AppColors.surfaceBorder),
                              ),
                              child: Text(
                                current['pill1'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.mintBg,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: AppColors.emeraldMint.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                current['pill2'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.emeraldDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    current['title'] as String,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    current['desc'] as String,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Dots & Action Button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (idx) {
                      final isActive = step == idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryEmerald : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (step < 2) {
                          state.setOnboardingStep(step + 1);
                        } else {
                          state.saveOnboarding();
                          state.setStage('app');
                          state.setActiveTab('home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        step < 2 ? 'Continue' : 'Get Started',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
