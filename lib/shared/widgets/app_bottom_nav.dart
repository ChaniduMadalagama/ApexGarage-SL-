import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabSelected;

  const AppBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'id': 'home', 'label': 'Home', 'icon': LucideIcons.home},
      {'id': 'garage', 'label': 'Garage', 'icon': LucideIcons.layers},
      {'id': 'market', 'label': 'Market', 'icon': LucideIcons.shoppingBag},
      {'id': 'meets', 'label': 'Meets', 'icon': LucideIcons.compass},
      {'id': 'profile', 'label': 'Profile', 'icon': LucideIcons.user},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs.map((t) {
            final id = t['id'] as String;
            final label = t['label'] as String;
            final icon = t['icon'] as IconData;
            final isSelected = activeTab == id;

            return InkWell(
              onTap: () => onTabSelected(id),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 21,
                      color: isSelected ? AppColors.primaryEmerald : AppColors.textMuted,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryEmerald : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
