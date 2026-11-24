import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/histogram_range_filter.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen04BuildLogs extends StatefulWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen04BuildLogs({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  State<Screen04BuildLogs> createState() => _Screen04BuildLogsState();
}

class _Screen04BuildLogsState extends State<Screen04BuildLogs> {
  late TextEditingController _modTitleController;

  @override
  void initState() {
    super.initState();
    final state = context.read<GarageAppState>();
    _modTitleController = TextEditingController(text: state.newModTitle);
  }

  @override
  void dispose() {
    _modTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = widget.onSelectScreen ?? state.jumpToScreen;

    final categories = ['Engine & Turbo', 'Suspension', 'ECU / Dyno', 'Aero', 'Brakes'];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mod Category Filter
        const Text(
          'Mod Category Filter',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: categories.map((cat) {
            final active = state.modCategories.contains(cat);
            return InkWell(
              onTap: () => state.toggleModCategory(cat),
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5.5),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFECFDF5) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Histogram Range Filter
        HistogramRangeFilter(
          label: 'Mod Cost & Dyno Gain Distribution',
          minVal: state.modMinCost,
          maxVal: state.modMaxCost,
          onChanged: (vals) => state.setModCostRange(vals.start, vals.end),
          maxLimit: 3000,
          prefix: '\$',
        ),

        const SizedBox(height: 16),

        // Cloudinary Media Pipeline Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFECEEF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(LucideIcons.uploadCloud, size: 14, color: Color(0xFF009B65)),
                      SizedBox(width: 6),
                      Text(
                        'Cloudinary Media Pipeline',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '4.8MB → 310KB WebP',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF009B65),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: TextField(
                  controller: _modTitleController,
                  onChanged: state.setNewModTitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
                  decoration: const InputDecoration(
                    hintText: 'Add new mod (e.g. Tomei Titanium Exhaust)',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF8E959E)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Verified Build Logs List
        ...state.garageLogs.map((log) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECEEF0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${log.stage} • ${log.gain}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF009B65),
                          ),
                        ),
                      ),
                      Text(
                        log.cost,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    log.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, size: 14, color: Color(0xFF009B65)),
                      const SizedBox(width: 4),
                      Text(
                        log.shop,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );

    final footer = Row(
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            'Export PDF',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              state.publishNewMod();
              _modTitleController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009B65),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Publish Mod Log',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '04',
      screenTitle: 'Build-Log Timeline & Cloudinary Upload',
      headerTitle: 'Build Sheet',
      rightHeaderWidget: const Icon(LucideIcons.uploadCloud, size: 16, color: Color(0xFF009B65)),
      onSelectScreen: jumper,
      footerBar: footer,
      isStandalonePhone: widget.isStandalone,
      child: content,
    );
  }
}
