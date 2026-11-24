import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/watermark_card.dart';
import 'package:apexgarage_sl/shared/widgets/pill_selector.dart';
import 'package:apexgarage_sl/features/garage/view/vehicle_detail_view.dart';
import 'package:apexgarage_sl/features/garage/view/add_vehicle_sheet.dart';
import 'package:apexgarage_sl/features/garage/view/motul_offer_sheet.dart';

class GarageView extends StatelessWidget {
  final ApexAppState appState;

  const GarageView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    if (appState.selectedVehicle != null) {
      return VehicleDetailView(
        vehicle: appState.selectedVehicle!,
        appState: appState,
      );
    }

    final filteredVehicles = appState.vehicles.where((v) {
      if (appState.garageFilter == 'All') return true;
      if (appState.garageFilter == 'Cars') return v.category == 'Car';
      if (appState.garageFilter == 'Bikes') return v.category == 'Bike';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 95),
          children: [
            // Top Header: My Garage & Vault
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.layers, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Garage & Vault',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${appState.vehicles.length} Vehicles · ${appState.totalBuildLogsCount} Mods · ${appState.totalServiceRecordsCount} Service Bills',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => AddVehicleSheet.show(context, appState),
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Add Vehicle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySubtle,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Pills
            PillSelector(
              options: [
                'All (${appState.vehicles.length})',
                'Cars (${appState.vehicles.where((v) => v.category == 'Car').length})',
                'Bikes (${appState.vehicles.where((v) => v.category == 'Bike').length})',
              ],
              selectedValue: appState.garageFilter == 'All'
                  ? 'All (${appState.vehicles.length})'
                  : appState.garageFilter == 'Cars'
                      ? 'Cars (${appState.vehicles.where((v) => v.category == 'Car').length})'
                      : 'Bikes (${appState.vehicles.where((v) => v.category == 'Bike').length})',
              onSelected: (String val) {
                if (val.startsWith('All')) {
                  appState.setGarageFilter('All');
                } else if (val.startsWith('Cars')) {
                  appState.setGarageFilter('Cars');
                } else if (val.startsWith('Bikes')) {
                  appState.setGarageFilter('Bikes');
                }
              },
            ),
            const SizedBox(height: 14),

            // Motul 300V Sponsored Banner (if not PRO)
            if (!appState.isPro) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MOTUL 300V',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '15% Off Dyno Service',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'ESTER Core® oil promo code inside',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => MotulOfferSheet.show(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Claim',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Vehicle Cards List
            if (filteredVehicles.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.car, size: 36, color: AppColors.textMuted),
                    const SizedBox(height: 8),
                    const Text(
                      'No vehicles in this category',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => AddVehicleSheet.show(context, appState),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Add Vehicle'),
                    ),
                  ],
                ),
              )
            else
              ...filteredVehicles.map((vehicle) {
                final kmLeft = vehicle.kmLeftUntilService;
                final isUrgent = vehicle.isServiceUrgent;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      WatermarkCard(
                        brand: vehicle.brand,
                        title: vehicle.title,
                        subtitle: vehicle.subtitle,
                        watermark: vehicle.watermark,
                        illustrationKey: vehicle.illustration,
                        photoUrl: vehicle.photoUrl,
                        statusBadge: vehicle.stageBadge,
                        metricValue: vehicle.powerValue,
                        metricUnit: vehicle.powerUnit,
                        specs: vehicle.specs,
                        accentColor: AppColors.primary,
                        onTap: () => appState.selectVehicle(vehicle.id),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isUrgent
                                  ? const Color(0xFFFEF3C7)
                                  : AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isUrgent ? LucideIcons.alertCircle : LucideIcons.checkCircle2,
                                  size: 12,
                                  color: isUrgent ? const Color(0xFFD97706) : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isUrgent ? 'Service Due ($kmLeft km)' : 'Health OK ($kmLeft km)',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: isUrgent ? const Color(0xFFB45309) : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${vehicle.logs.length} Mods · ${vehicle.serviceRecords.length} Bills',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
