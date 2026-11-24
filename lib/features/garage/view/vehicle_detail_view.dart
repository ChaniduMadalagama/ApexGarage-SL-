import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/watermark_card.dart';
import 'package:apexgarage_sl/shared/widgets/pill_selector.dart';
import 'package:apexgarage_sl/features/garage/view/add_build_sheet.dart';
import 'package:apexgarage_sl/features/garage/view/add_service_record_sheet.dart';

class VehicleDetailView extends StatelessWidget {
  final VehicleModel vehicle;
  final ApexAppState appState;

  const VehicleDetailView({
    super.key,
    required this.vehicle,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final kmLeft = vehicle.kmLeftUntilService;
    final isUrgent = vehicle.isServiceUrgent;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => appState.selectVehicle(null),
        ),
        title: Text(
          vehicle.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, size: 20, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Build link for ${vehicle.title} copied!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          // Hero Watermark Card
          WatermarkCard(
            brand: vehicle.brand,
            title: vehicle.title,
            subtitle: vehicle.subtitle,
            watermark: vehicle.watermark,
            illustrationKey: vehicle.illustration,
            statusBadge: vehicle.stageBadge,
            metricValue: vehicle.powerValue,
            metricUnit: vehicle.powerUnit,
            specs: vehicle.specs,
            accentColor: AppColors.primary,
          ),
          const SizedBox(height: 14),

          // Specs summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpecCol('ENGINE', vehicle.engineCode.isNotEmpty ? vehicle.engineCode : vehicle.chassis),
                _buildDivider(),
                _buildSpecCol('ODOMETER', '${vehicle.currentMileage.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} km'),
                _buildDivider(),
                _buildSpecCol('TORQUE', vehicle.torqueValue),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sub-Tab Switcher: Build Showcase vs Service Glovebox
          PillSelector(
            options: const ['Build Showcase', 'Service Glovebox'],
            selectedValue: appState.vehicleDetailTab,
            onSelected: (tab) => appState.setVehicleDetailTab(tab),
          ),
          const SizedBox(height: 16),

          // Tab Content
          if (appState.vehicleDetailTab == 'Build Showcase')
            _buildShowcaseTab(context)
          else
            _buildGloveboxTab(context, kmLeft, isUrgent),
        ],
      ),
    );
  }

  Widget _buildShowcaseTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PUBLIC BUILD PEDIGREE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${vehicle.logs.length} verified modification logs',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => AddBuildSheet.show(
                context,
                appState: appState,
                vehicleId: vehicle.id,
              ),
              icon: const Icon(LucideIcons.plus, size: 14),
              label: const Text('Log Mod'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (vehicle.logs.isEmpty)
          _buildEmptyState(
            icon: LucideIcons.wrench,
            title: 'No Build Logs Yet',
            desc: 'Add your first modification, dyno result, or exhaust upgrade.',
            btnText: 'Add First Mod',
            onTap: () => AddBuildSheet.show(
              context,
              appState: appState,
              vehicleId: vehicle.id,
            ),
          )
        else
          ...vehicle.logs.map((log) => _buildLogCard(log)),
      ],
    );
  }

  Widget _buildGloveboxTab(BuildContext context, int kmLeft, bool isUrgent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Health Countdown Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUrgent ? const Color(0xFFFEF3C7) : AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isUrgent ? const Color(0xFFF59E0B) : AppColors.accent.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isUrgent ? LucideIcons.alertCircle : LucideIcons.checkCircle2,
                color: isUrgent ? const Color(0xFFD97706) : AppColors.primary,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUrgent ? 'Service Due in $kmLeft km' : 'Health OK · $kmLeft km Left',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isUrgent ? const Color(0xFF92400E) : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Next target: ${vehicle.nextServiceMileage.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} km · Estimated ${vehicle.nextServiceDate}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isUrgent ? const Color(0xFFB45309) : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SERVICE LOGBOOK & INVOICES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${vehicle.serviceRecords.length} private maintenance bills',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => AddServiceRecordSheet.show(
                context,
                appState: appState,
                vehicleId: vehicle.id,
              ),
              icon: const Icon(LucideIcons.fileText, size: 14),
              label: const Text('+ Service Bill'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (vehicle.serviceRecords.isEmpty)
          _buildEmptyState(
            icon: LucideIcons.fileText,
            title: 'No Service Records Yet',
            desc: 'Document oil changes, fluid flushes, and workshop bills with verified receipts.',
            btnText: 'Log Service Bill',
            onTap: () => AddServiceRecordSheet.show(
              context,
              appState: appState,
              vehicleId: vehicle.id,
            ),
          )
        else
          ...vehicle.serviceRecords.map((sr) => _buildServiceRecordCard(context, sr)),
      ],
    );
  }

  Widget _buildServiceRecordCard(BuildContext context, ServiceRecord sr) {
    final costFormatted = 'LKR ${sr.cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sr.date,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${sr.odometer.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} km',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                costFormatted,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sr.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sr.notes,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.35),
          ),
          const SizedBox(height: 10),

          // Parts changed tags
          if (sr.partsChanged.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: sr.partsChanged.map((part) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    part,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              const Icon(LucideIcons.wrench, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  sr.workshop,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: [
                          const Icon(LucideIcons.fileText, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          const Text('Invoice Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Receipt: ${sr.receiptLabel}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('Workshop: ${sr.workshop}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          Text('Date: ${sr.date}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          Text('Total: $costFormatted', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 12),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.canvas,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.shieldCheck, color: AppColors.primary, size: 36),
                                SizedBox(height: 6),
                                Text('Verified Partner Workshop Stamp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, size: 11, color: AppColors.primary),
                      const SizedBox(width: 3),
                      Text(
                        sr.receiptLabel,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(BuildLogEntry log) {
    Color badgeColor = AppColors.primary;
    if (log.category == 'Brakes') badgeColor = const Color(0xFFEF4444);
    if (log.category == 'Suspension') badgeColor = const Color(0xFF3B82F6);
    if (log.category == 'Exhaust') badgeColor = const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  log.category.toUpperCase(),
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                log.brand,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                'LKR ${log.cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            log.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            log.notes,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  log.mechanic,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.shieldCheck, size: 11, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      log.photoLabel ?? 'Verified Receipt',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String desc,
    required String btnText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(LucideIcons.plus, size: 14),
            label: Text(btnText),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCol(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.border,
    );
  }
}
