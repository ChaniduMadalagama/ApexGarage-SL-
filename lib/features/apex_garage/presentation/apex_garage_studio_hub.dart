import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_01_onboarding.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_02_auth.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_03_digital_garage.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_04_build_logs.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_05_marketplace.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_06_filter.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_07_workshops.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_08_meets.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_09_feed.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/screens/screen_10_ideabiz.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class ApexGarageStudioHub extends StatelessWidget {
  const ApexGarageStudioHub({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GarageAppState(),
      child: const _StudioHubView(),
    );
  }
}

class _StudioHubView extends StatelessWidget {
  const _StudioHubView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();

    // If on a compact screen (actual mobile phone), present the full mobile view directly
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileWidth = screenWidth < 768;

    if (isMobileWidth || state.viewMode == 'mobile_app') {
      return _buildMobileAppExperience(context, state);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE4E9E7),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Design Studio Top Navigation Bar
            _buildStudioTopHeader(context, state),

            // Main Canvas Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1600),
                    child: state.viewMode == 'all_10'
                        ? _buildAll10Canvas(context, state)
                        : _buildFocusedPairCanvas(context, state),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioTopHeader(BuildContext context, GarageAppState state) {
    final pairs = [
      {'label': '01-02 Onboarding', 'idx': 0},
      {'label': '03-04 Digital Garage', 'idx': 1},
      {'label': '05-06 Search & Filter', 'idx': 2},
      {'label': '07-08 Shops & Meets', 'idx': 3},
      {'label': '09-10 Feed & IdeaBiz', 'idx': 4},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE4E9E7),
        border: Border(bottom: BorderSide(color: Color(0xFFD5DDD9))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              // Brand Title & Description
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF009B65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.car, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'ApexGarage SL — Complete 10-Screen Mobile UI',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(0xFF10B981)),
                            ),
                            child: const Text(
                              '10 Screens • 5 Module Flows',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF009B65),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Minimalist Light-Mode iOS Aesthetic • Watermark Cards • Histogram Sliders • Chanidu Ashen (E231524)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF687078),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // View Mode Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD8E0DC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleBtn(
                      label: 'All 10 Screens Canvas',
                      icon: LucideIcons.layoutGrid,
                      active: state.viewMode == 'all_10',
                      onTap: () => state.setViewMode('all_10'),
                    ),
                    const SizedBox(width: 4),
                    _buildToggleBtn(
                      label: 'Dual-Screen Flow Mode',
                      icon: LucideIcons.columns,
                      active: state.viewMode == 'pair_view',
                      onTap: () => state.setViewMode('pair_view'),
                    ),
                    const SizedBox(width: 4),
                    _buildToggleBtn(
                      label: 'Mobile Phone App',
                      icon: LucideIcons.smartphone,
                      active: state.viewMode == 'mobile_app',
                      onTap: () => state.setViewMode('mobile_app'),
                    ),
                  ],
                ),
              ),

              // Quick Module Pair Jump Pills
              Row(
                mainAxisSize: MainAxisSize.min,
                children: pairs.map((p) {
                  final idx = p['idx'] as int;
                  final active = state.viewMode == 'pair_view' && state.activePairIndex == idx;

                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () => state.setActivePairIndex(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFFECFDF5) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active ? const Color(0xFF10B981) : const Color(0xFFD8E0DC),
                          ),
                        ),
                        child: Text(
                          p['label'] as String,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: active ? const Color(0xFF009B65) : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleBtn({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF009B65) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active ? Colors.white : const Color(0xFF5A626A),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : const Color(0xFF5A626A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAll10Canvas(BuildContext context, GarageAppState state) {
    final modulePairs = [
      {
        'title': 'Pair 01 • Onboarding & Sanctum Auth (Screens 01 – 02)',
        'idx': 0,
        'left': const Screen01Onboarding(),
        'right': const Screen02Auth(),
      },
      {
        'title': 'Pair 02 • Digital Garage & Build Logs (Screens 03 – 04)',
        'idx': 1,
        'left': const Screen03DigitalGarage(),
        'right': const Screen04BuildLogs(),
      },
      {
        'title': 'Pair 03 • Marketplace Search & Filter (Screens 05 – 06 • Exact Reference)',
        'idx': 2,
        'left': const Screen05Marketplace(),
        'right': const Screen06Filter(),
      },
      {
        'title': 'Pair 04 • Verified Workshops & Meets Map (Screens 07 – 08)',
        'idx': 3,
        'left': const Screen07Workshops(),
        'right': const Screen08Meets(),
      },
      {
        'title': 'Pair 05 • Community Feed & IdeaBiz Billing (Screens 09 – 10)',
        'idx': 4,
        'left': const Screen09Feed(),
        'right': const Screen10Ideabiz(),
      },
    ];

    return Column(
      children: modulePairs.map((pair) {
        final idx = pair['idx'] as int;
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFDDE4E1).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: const Color(0xFFCFD8D4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: Text(
                            'MODULE FLOW 0${idx + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF009B65),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pair['title'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => state.setActivePairIndex(idx),
                      icon: const Text(
                        'Focus This Pair',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      label: const Icon(LucideIcons.arrowUpRight, size: 16, color: Color(0xFF009B65)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFD8E0DC)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Center(
                  child: Wrap(
                    spacing: 48,
                    runSpacing: 36,
                    alignment: WrapAlignment.center,
                    children: [
                      pair['left'] as Widget,
                      pair['right'] as Widget,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFocusedPairCanvas(BuildContext context, GarageAppState state) {
    final pairScreens = [
      {
        'title': 'Pair 01 • Onboarding & Sanctum Auth (Screens 01 – 02)',
        'left': const Screen01Onboarding(),
        'right': const Screen02Auth(),
      },
      {
        'title': 'Pair 02 • Digital Garage & Build Logs (Screens 03 – 04)',
        'left': const Screen03DigitalGarage(),
        'right': const Screen04BuildLogs(),
      },
      {
        'title': 'Pair 03 • Marketplace Search & Filter (Screens 05 – 06 • Exact Reference)',
        'left': const Screen05Marketplace(),
        'right': const Screen06Filter(),
      },
      {
        'title': 'Pair 04 • Verified Workshops & Meets Map (Screens 07 – 08)',
        'left': const Screen07Workshops(),
        'right': const Screen08Meets(),
      },
      {
        'title': 'Pair 05 • Community Feed & IdeaBiz Billing (Screens 09 – 10)',
        'left': const Screen09Feed(),
        'right': const Screen10Ideabiz(),
      },
    ];

    final currentPair = pairScreens[state.activePairIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFF10B981)),
          ),
          child: const Text(
            'FOCUSED DUAL-SCREEN ARTBOARD',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF009B65),
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentPair['title'] as String,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 48,
          runSpacing: 36,
          alignment: WrapAlignment.center,
          children: [
            currentPair['left'] as Widget,
            currentPair['right'] as Widget,
          ],
        ),
      ],
    );
  }

  Widget _buildMobileAppExperience(BuildContext context, GarageAppState state) {
    // Return the active screen directly as full mobile UI
    switch (state.currentScreen) {
      case 1:
        return const Screen01Onboarding(isStandalone: true);
      case 2:
        return const Screen02Auth(isStandalone: true);
      case 3:
        return const Screen03DigitalGarage(isStandalone: true);
      case 4:
        return const Screen04BuildLogs(isStandalone: true);
      case 5:
        return const Screen05Marketplace(isStandalone: true);
      case 6:
        return const Screen06Filter(isStandalone: true);
      case 7:
        return const Screen07Workshops(isStandalone: true);
      case 8:
        return const Screen08Meets(isStandalone: true);
      case 9:
        return const Screen09Feed(isStandalone: true);
      case 10:
        return const Screen10Ideabiz(isStandalone: true);
      default:
        return const Screen01Onboarding(isStandalone: true);
    }
  }
}
