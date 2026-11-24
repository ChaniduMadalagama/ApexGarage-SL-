import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/shared/widgets/pill_selector.dart';
import 'package:apexgarage_sl/features/mechanics/view/service_booking_sheet.dart';

class MechanicsView extends StatelessWidget {
  final ApexAppState appState;

  const MechanicsView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final filteredMechanics = appState.mechanics.where((m) {
      if (appState.mechanicFilter == 'All') return true;
      return m.specialties.any((s) => s.toLowerCase().contains(appState.mechanicFilter.toLowerCase()));
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            // Sub-tabs: Parts vs Mechanics
            PillSelector(
              options: const ['Parts', 'Mechanics'],
              selected: appState.marketSubTab,
              onSelect: (val) => appState.setMarketSubTab(val),
            ),
            const SizedBox(height: 14),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill('All'),
                  _buildFilterPill('Dyno'),
                  _buildFilterPill('Tuning'),
                  _buildFilterPill('Engine Swaps'),
                  _buildFilterPill('Superbike'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Header stats
            Row(
              children: [
                Text(
                  '${filteredMechanics.length} verified tuning workshops',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                const Row(
                  children: [
                    Icon(LucideIcons.shieldCheck, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Apex Certified',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Workshop Cards
            ...filteredMechanics.map((mechanic) => _buildMechanicCard(context, mechanic)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String filter) {
    final isSelected = appState.mechanicFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => appState.setMechanicFilter(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySubtle : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.border,
              width: 1.2,
            ),
          ),
          child: Text(
            filter,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMechanicCard(BuildContext context, MechanicModel mechanic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.wrench, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            mechanic.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (mechanic.verified) ...[
                          const SizedBox(width: 4),
                          const Icon(LucideIcons.checkCircle2, size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          mechanic.location,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.star, size: 12, color: Color(0xFFD97706)),
                    const SizedBox(width: 4),
                    Text(
                      mechanic.rating.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Specialties chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: mechanic.specialties.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Working hours & Action buttons
          Row(
            children: [
              const Icon(LucideIcons.clock, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 5),
              const Text(
                'Mon - Sat · 8:30 AM - 6:00 PM',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => ServiceBookingSheet.show(
                  context,
                  appState: appState,
                  mechanic: mechanic,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Book Dyno / Slot'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
