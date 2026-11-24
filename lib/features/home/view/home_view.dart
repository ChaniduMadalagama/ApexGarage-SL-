import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/shared/widgets/watermark_card.dart';
import 'package:apexgarage_sl/shared/widgets/vehicle_illustrations.dart';
import 'package:apexgarage_sl/features/garage/view/add_build_sheet.dart';
import 'package:apexgarage_sl/features/garage/view/add_service_record_sheet.dart';
import 'package:apexgarage_sl/features/garage/view/add_vehicle_sheet.dart';
import 'package:apexgarage_sl/features/garage/view/motul_offer_sheet.dart';
import 'package:apexgarage_sl/features/marketplace/view/sell_part_sheet.dart';
import 'package:apexgarage_sl/features/billing/view/ideabiz_billing_sheet.dart';

class HomeView extends StatelessWidget {
  final ApexAppState appState;

  const HomeView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final activeVehicle = appState.activeContextVehicle;
    final kmLeft = activeVehicle.kmLeftUntilService;
    final isUrgent = activeVehicle.isServiceUrgent;

    // Filter recommended parts for this vehicle
    final recommendedParts = appState.parts.where((p) {
      final fitment = p.subtitle.toLowerCase() + p.description.toLowerCase();
      return fitment.contains(activeVehicle.chassis.toLowerCase()) ||
          fitment.contains(activeVehicle.engineCode.toLowerCase()) ||
          fitment.contains(activeVehicle.brand.toLowerCase());
    }).toList();

    final nextMeet = appState.meets.isNotEmpty ? appState.meets.first : null;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 95),
          children: [
            // 1. Top App Bar & Profile Context
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySubtle,
                  child: Text(
                    appState.authName.length >= 2
                        ? appState.authName.substring(0, 2).toUpperCase()
                        : 'CM',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                TextSpan(text: 'Apex'),
                                TextSpan(
                                  text: 'Garage',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              if (!appState.isPro) {
                                IdeaBizBillingSheet.show(context, appState);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: appState.isPro
                                    ? AppColors.primarySubtle
                                    : AppColors.inputBackground,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: appState.isPro
                                      ? AppColors.accent
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                appState.isPro ? 'PRO' : 'FREE · UPGRADE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: appState.isPro
                                      ? AppColors.primary
                                      : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Active Context · ${activeVehicle.engineCode} Fitment Engine',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => appState.setActiveTab('meets'),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(LucideIcons.bell, size: 16, color: AppColors.textPrimary),
                        Positioned(
                          top: -1,
                          right: -1,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (appState.vehicles.isEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            LucideIcons.car,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Digital Garage is Empty',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Add your car or bike to track dyno specs, mods & service intervals.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => AddVehicleSheet.show(context, appState),
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text('Add Your First Vehicle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          textStyle: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ] else ...[
              // 2. Active Vehicle Context Switcher (Horizontal Pills)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: appState.vehicles.map((v) {
                    final isSelected = v.id == appState.activeContextVehicleId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => appState.setActiveContextVehicleId(v.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primarySubtle : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.accent : AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                v.category == 'Bike' ? LucideIcons.bike : LucideIcons.car,
                                size: 14,
                                color: isSelected ? AppColors.primary : AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                v.shortContextLabel.isNotEmpty ? v.shortContextLabel : v.title,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // 3. Active Build Hero Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WatermarkCard(
                      brand: activeVehicle.brand,
                      title: activeVehicle.title,
                      subtitle: activeVehicle.subtitle,
                      watermark: activeVehicle.watermark,
                      illustrationKey: activeVehicle.illustration,
                      photoUrl: activeVehicle.photoUrl,
                      statusBadge: activeVehicle.stageBadge,
                      metricValue: activeVehicle.powerValue,
                      metricUnit: activeVehicle.powerUnit,
                      specs: activeVehicle.specs,
                      accentColor: AppColors.primary,
                      onTap: () {
                        appState.selectVehicle(activeVehicle.id);
                        appState.setVehicleDetailTab('Build Showcase');
                        appState.setActiveTab('garage');
                      },
                    ),
                    const SizedBox(height: 12),

                    // Telemetry Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.gauge, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                '${activeVehicle.currentMileage.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} km',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(LucideIcons.zap, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                activeVehicle.torqueValue,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: AppColors.textPrimary),
                              children: [
                                TextSpan(
                                  text: activeVehicle.powerValue,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text: ' ${activeVehicle.powerUnit}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dual Intent Footer Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              appState.selectVehicle(activeVehicle.id);
                              appState.setVehicleDetailTab('Build Showcase');
                              appState.setActiveTab('garage');
                            },
                            icon: const Icon(LucideIcons.wrench, size: 13, color: AppColors.primary),
                            label: Text('Build Log (${activeVehicle.logs.length})'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              appState.selectVehicle(activeVehicle.id);
                              appState.setVehicleDetailTab('Service Glovebox');
                              appState.setActiveTab('garage');
                            },
                            icon: Icon(
                              isUrgent ? LucideIcons.alertCircle : LucideIcons.checkCircle2,
                              size: 13,
                              color: isUrgent ? const Color(0xFFD97706) : AppColors.primary,
                            ),
                            label: Text(
                              isUrgent ? 'Due in $kmLeft km' : 'Health OK · $kmLeft km',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isUrgent ? const Color(0xFFB45309) : AppColors.primary,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isUrgent
                                  ? const Color(0xFFFEF3C7)
                                  : AppColors.primarySubtle,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 4. Quick Action Dock (4 Cards)
            Row(
              children: [
                _buildActionCard(
                  icon: LucideIcons.plus,
                  label: '+ Log Mod',
                  onTap: () => AddBuildSheet.show(
                    context,
                    appState: appState,
                    vehicleId: activeVehicle.id,
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionCard(
                  icon: LucideIcons.fileText,
                  label: '+ Service Bill',
                  onTap: () => AddServiceRecordSheet.show(
                    context,
                    appState: appState,
                    vehicleId: activeVehicle.id,
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionCard(
                  icon: LucideIcons.tag,
                  label: '+ Sell Part',
                  onTap: () => SellPartSheet.show(context, appState),
                ),
                const SizedBox(width: 8),
                _buildActionCard(
                  icon: LucideIcons.wrench,
                  label: 'Find Dyno',
                  onTap: () {
                    appState.setActiveTab('market');
                    appState.setMarketSubTab('Mechanics');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Live Local Meet Radar
            if (nextMeet != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.mapPin, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySubtle,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'RADAR · THIS WEEKEND',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${nextMeet.going} Going',
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nextMeet.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nextMeet.location,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => appState.toggleMeetRsvp(nextMeet.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appState.rsvpMeetIds.contains(nextMeet.id)
                            ? AppColors.primary
                            : AppColors.primarySubtle,
                        foregroundColor: appState.rsvpMeetIds.contains(nextMeet.id)
                            ? Colors.white
                            : AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(appState.rsvpMeetIds.contains(nextMeet.id) ? '✓ In' : 'RSVP'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 6. Recommended JDM Parts for Active Vehicle
            if (recommendedParts.isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    'PARTS FOR YOUR BUILD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      appState.setActiveTab('market');
                      appState.setMarketSubTab('Parts');
                    },
                    child: const Text(
                      'Browse All →',
                      style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recommendedParts.take(3).map((p) {
                    final priceStr = 'LKR ${p.price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}';
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 12),
                      child: WatermarkCard(
                        brand: p.brand,
                        title: p.title,
                        subtitle: p.subtitle,
                        watermark: p.watermark,
                        illustrationKey: p.illustration,
                        photoUrl: p.photoUrl,
                        statusBadge: p.condition,
                        metricValue: priceStr,
                        metricUnit: '',
                        specs: p.specs,
                        accentColor: AppColors.primary,
                        onTap: () {
                          appState.selectPart(p.id);
                          appState.setActiveTab('market');
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 7. Community Build Pulse (Feed)
            Row(
              children: [
                const Text(
                  'COMMUNITY BUILD PULSE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${appState.communityFeed.length} updates',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...appState.communityFeed.asMap().entries.map((entry) {
              final idx = entry.key;
              final post = entry.value;
              return Column(
                children: [
                  _buildFeedCard(context, post),
                  if (idx == 0 && !appState.isPro && appState.sponsoredAds.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    // Dynamic Sponsored Ad Banner from Backend
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySubtle,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'SPONSORED · ${appState.sponsoredAds.first.sponsor.toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appState.sponsoredAds.first.headline,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  appState.sponsoredAds.first.placement,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => MotulOfferSheet.show(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primarySubtle,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Claim Offer'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, CommunityFeedPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primarySubtle,
                child: Text(
                  post.avatar,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    Text(
                      '${post.handle} · ${post.crew}',
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.vehicleTitle,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 2),
          Text(
            post.modTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildFeedMedia(post),
          const SizedBox(height: 10),

          // Tags
          Wrap(
            spacing: 6,
            children: post.tags.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  t,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // Workshop & Like / Comment Footer
          Row(
            children: [
              GestureDetector(
                onTap: () => appState.toggleFeedLike(post.id),
                child: Row(
                  children: [
                    Icon(
                      post.liked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: post.liked ? const Color(0xFFEF4444) : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.likes.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: post.liked ? const Color(0xFFEF4444) : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => _showCommentsSheet(context, post),
                child: Row(
                  children: [
                    const Icon(LucideIcons.messageSquare, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      post.comments.toString(),
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(LucideIcons.wrench, size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    post.workshop,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedMedia(CommunityFeedPost post) {
    final photoUrl = post.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: 168,
          child: Image.network(
            photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFeedIllustrationBanner(post),
          ),
        ),
      );
    }
    return _buildFeedIllustrationBanner(post);
  }

  Widget _buildFeedIllustrationBanner(CommunityFeedPost post) {
    return Container(
      width: double.infinity,
      height: 112,
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              post.watermark,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.watermarkText,
                letterSpacing: -1.0,
                height: 1.0,
              ),
            ),
          ),
          VehicleIllustration(
            type: post.illustration,
            width: 220,
            height: 92,
          ),
        ],
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, CommunityFeedPost post) {
    final commentCtrl = TextEditingController();
    List<FeedComment>? comments;
    var loading = true;
    var posting = false;
    var started = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            if (!started) {
              started = true;
              appState.fetchFeedComments(post.id).then((list) {
                if (!ctx.mounted) return;
                setSheetState(() {
                  comments = list;
                  loading = false;
                });
              });
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.modTitle,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${post.vehicleTitle} · ${post.author}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else if (comments == null || comments!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No comments yet. Start the discussion!',
                        style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments!.length,
                        itemBuilder: (_, i) {
                          final c = comments![i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primarySubtle,
                                  child: Text(
                                    c.avatar,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.canvas,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              c.author,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              c.timeAgo,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c.body,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentCtrl,
                          decoration: InputDecoration(
                            hintText: appState.isAuthenticated
                                ? 'Write a comment...'
                                : 'Sign in to comment',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            filled: true,
                            fillColor: AppColors.inputSoftGrey,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (!appState.isAuthenticated || posting)
                            ? null
                            : () async {
                                final body = commentCtrl.text.trim();
                                if (body.isEmpty) return;
                                setSheetState(() => posting = true);
                                final created = await appState.addFeedComment(post.id, body);
                                if (!ctx.mounted) return;
                                commentCtrl.clear();
                                setSheetState(() {
                                  posting = false;
                                  if (created != null) {
                                    comments = [...(comments ?? []), created];
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(posting ? '...' : 'Post'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
