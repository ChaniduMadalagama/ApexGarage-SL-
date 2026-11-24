import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class IOSPhoneFrame extends StatelessWidget {
  final String screenNumber;
  final String screenTitle;
  final String headerTitle;
  final Widget? rightHeaderWidget;
  final String? activeBottomTab;
  final void Function(int screenNum)? onSelectScreen;
  final Widget? footerBar;
  final Widget child;
  final bool isStandalonePhone;
  final VoidCallback? onBack;

  const IOSPhoneFrame({
    super.key,
    required this.screenNumber,
    required this.screenTitle,
    required this.headerTitle,
    this.rightHeaderWidget,
    this.activeBottomTab,
    this.onSelectScreen,
    this.footerBar,
    required this.child,
    this.isStandalonePhone = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (isStandalonePhone) {
      // Direct full screen mobile presentation
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF111827)),
            onPressed: onBack ?? () {
              if (onSelectScreen != null) {
                onSelectScreen!(1);
              } else if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          centerTitle: true,
          title: Text(
            headerTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          actions: rightHeaderWidget != null
              ? [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: rightHeaderWidget!,
                    ),
                  ),
                ]
              : null,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: Color(0xFFECEEF0)),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  child: child,
                ),
              ),
              if (footerBar != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFECEEF0))),
                  ),
                  child: footerBar,
                ),
            ],
          ),
        ),
        bottomNavigationBar: activeBottomTab != null ? _buildBottomNav() : null,
      );
    }

    // Studio Device Artboard
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Studio Label Above Frame
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF009B65),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'SCREEN $screenNumber',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                screenTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),

        // iOS Phone Frame Artboard (366x768)
        Container(
          width: 366,
          height: 768,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(42),
            border: Border.all(color: Colors.white, width: 6),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // iOS Status Bar
              _buildIOSStatusBar(),

              // App Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFECEEF0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 32,
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF111827)),
                        onPressed: () => onSelectScreen?.call(1),
                      ),
                    ),
                    Text(
                      headerTitle,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: rightHeaderWidget ?? const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Screen Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  physics: const BouncingScrollPhysics(),
                  child: child,
                ),
              ),

              // Optional Sticky Action Footer Bar
              if (footerBar != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFECEEF0))),
                  ),
                  child: footerBar!,
                ),

              // Optional 5-Tab Bottom Bar
              if (activeBottomTab != null) _buildBottomNav(),

              // Home Indicator
              Container(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  width: 126,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIOSStatusBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '10:55',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          Row(
            children: [
              // Cellular Signal Bars
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _signalBar(4, const Color(0xFF111827)),
                  const SizedBox(width: 2),
                  _signalBar(6, const Color(0xFF111827)),
                  const SizedBox(width: 2),
                  _signalBar(8.5, const Color(0xFF111827)),
                  const SizedBox(width: 2),
                  _signalBar(11, const Color(0xFFD1D5DB)),
                ],
              ),
              const SizedBox(width: 6),
              // Wifi Icon
              const Icon(LucideIcons.wifi, size: 14, color: Color(0xFF111827)),
              const SizedBox(width: 6),
              // Battery
              Container(
                width: 20,
                height: 10,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF111827).withValues(alpha: 0.4)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signalBar(double h, Color color) {
    return Container(
      width: 2.5,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildBottomNav() {
    final tabs = [
      {'id': 'feed', 'label': 'Feed', 'icon': LucideIcons.home, 'target': 9},
      {'id': 'garage', 'label': 'Garage', 'icon': LucideIcons.car, 'target': 3},
      {'id': 'parts', 'label': 'Parts', 'icon': LucideIcons.wrench, 'target': 5},
      {'id': 'meets', 'label': 'Meets', 'icon': LucideIcons.mapPin, 'target': 8},
      {'id': 'pro', 'label': 'IdeaBiz', 'icon': LucideIcons.award, 'target': 10},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFECEEF0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((t) {
          final isAct = activeBottomTab == t['id'];
          final icon = t['icon'] as IconData;
          final target = t['target'] as int;

          return InkWell(
            onTap: () => onSelectScreen?.call(target),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isAct ? const Color(0xFF009B65) : const Color(0xFF8E959E),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isAct ? FontWeight.bold : FontWeight.w500,
                      color: isAct ? const Color(0xFF009B65) : const Color(0xFF8E959E),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
