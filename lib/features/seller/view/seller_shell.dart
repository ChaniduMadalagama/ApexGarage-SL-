import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/features/seller/view/seller_dashboard_view.dart';
import 'package:apexgarage_sl/features/seller/view/seller_inquiries_view.dart';
import 'package:apexgarage_sl/features/seller/view/seller_inventory_view.dart';
import 'package:apexgarage_sl/features/seller/view/seller_profile_view.dart';
import 'package:apexgarage_sl/features/seller/view/seller_workshop_view.dart';
import 'package:flutter/material.dart';

class SellerShell extends StatefulWidget {
  final ApexAppState appState;

  const SellerShell({super.key, required this.appState});

  @override
  State<SellerShell> createState() => _SellerShellState();
}

class _SellerShellState extends State<SellerShell> {
  @override
  void initState() {
    super.initState();
    if (widget.appState.sellerDashboard == null &&
        !widget.appState.isSellerLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.appState.loadSellerDashboard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.appState.sellerTab;
    final stats = widget.appState.sellerDashboard?.stats;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: _buildBody(tab)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFFE5E7EB).withValues(alpha: 0.9),
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          icon: Icons.storefront_rounded,
                          label: 'Dashboard',
                          active: tab == 'dashboard',
                          onTap: () => widget.appState.setSellerTab('dashboard'),
                        ),
                        _NavItem(
                          icon: Icons.inventory_2_outlined,
                          label: 'Inventory',
                          active: tab == 'inventory',
                          onTap: () => widget.appState.setSellerTab('inventory'),
                        ),
                        _NavItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Inquiries',
                          active: tab == 'inquiries',
                          badge: stats?.openInquiriesCount ?? 0,
                          onTap: () => widget.appState.setSellerTab('inquiries'),
                        ),
                        _NavItem(
                          icon: Icons.build_outlined,
                          label: 'Workshop',
                          active: tab == 'workshop',
                          badge: stats?.pendingBookingsCount ?? 0,
                          onTap: () => widget.appState.setSellerTab('workshop'),
                        ),
                        _NavItem(
                          icon: Icons.verified_user_outlined,
                          label: 'Shop',
                          active: tab == 'profile',
                          onTap: () => widget.appState.setSellerTab('profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(String tab) {
    switch (tab) {
      case 'inventory':
        return SellerInventoryView(appState: widget.appState);
      case 'inquiries':
        return SellerInquiriesView(appState: widget.appState);
      case 'workshop':
        return SellerWorkshopView(appState: widget.appState);
      case 'profile':
        return SellerProfileView(appState: widget.appState);
      case 'dashboard':
      default:
        return SellerDashboardView(
          appState: widget.appState,
          onOpenAddPart: () => widget.appState.setSellerTab('inventory'),
        );
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final int badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    this.badge = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryEmerald : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22, color: color),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
