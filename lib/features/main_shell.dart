import 'package:flutter/material.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/app_bottom_nav.dart';
import 'package:apexgarage_sl/features/onboarding/view/splash_screen.dart';
import 'package:apexgarage_sl/features/onboarding/view/onboarding_carousel.dart';
import 'package:apexgarage_sl/features/onboarding/view/auth_screen.dart';
import 'package:apexgarage_sl/features/home/view/home_view.dart';
import 'package:apexgarage_sl/features/garage/view/garage_view.dart';
import 'package:apexgarage_sl/features/marketplace/view/marketplace_view.dart';
import 'package:apexgarage_sl/features/meets/view/meets_view.dart';
import 'package:apexgarage_sl/features/billing/view/profile_view.dart';
import 'package:apexgarage_sl/features/seller/view/seller_shell.dart';

class MainShell extends StatelessWidget {
  final ApexAppState appState;

  const MainShell({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final stage = appState.stage;

        if (stage == 'splash') {
          return SplashScreen(appState: appState);
        }

        if (stage == 'auth') {
          return AuthScreen(appState: appState);
        }

        if (stage == 'onboarding') {
          return OnboardingCarousel(appState: appState);
        }

        if (appState.isAuthenticated && appState.isSeller) {
          return SellerShell(appState: appState);
        }

        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: Stack(
            children: [
              // Active Tab Content
              Positioned.fill(
                child: _buildCurrentTab(appState.activeTab),
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppBottomNav(
                  activeTab: appState.activeTab,
                  onTabSelected: (tab) => appState.setActiveTab(tab),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(String tab) {
    switch (tab) {
      case 'home':
        return HomeView(appState: appState);
      case 'garage':
        return GarageView(appState: appState);
      case 'market':
        return MarketplaceView(appState: appState);
      case 'meets':
        return MeetsView(appState: appState);
      case 'profile':
        return ProfileView(appState: appState);
      default:
        return HomeView(appState: appState);
    }
  }
}
