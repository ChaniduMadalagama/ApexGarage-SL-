import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';

class AddServiceRecordSheet extends StatefulWidget {
  final ApexAppState appState;
  final String vehicleId;

  const AddServiceRecordSheet({
    super.key,
    required this.appState,
    required this.vehicleId,
  });

  static Future<void> show(
    BuildContext context, {
    required ApexAppState appState,
    required String vehicleId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddServiceRecordSheet(appState: appState, vehicleId: vehicleId),
    );
  }

  @override
  State<AddServiceRecordSheet> createState() => _AddServiceRecordSheetState();
}

class _AddServiceRecordSheetState extends State<AddServiceRecordSheet> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _odometerController = TextEditingController();
  final _nextKmController = TextEditingController();
  final _nextDateController = TextEditingController();
  final _costController = TextEditingController();
  final _partsController = TextEditingController();
  final _workshopController = TextEditingController();
  bool _photoAttached = true;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.appState.vehicles.firstWhere(
      (v) => v.id == widget.vehicleId,
      orElse: () => widget.appState.activeContextVehicle,
    );
    _titleController.text = '${vehicle.currentMileage + 5000} km Periodic Maintenance';
    _odometerController.text = vehicle.currentMileage.toString();
    _nextKmController.text = (vehicle.currentMileage + vehicle.serviceInterval).toString();
    _detailsController.text = 'Engine oil and filter change, brake pad inspection, and coolant top-up.';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _odometerController.dispose();
    _nextKmController.dispose();
    _nextDateController.dispose();
    _costController.dispose();
    _partsController.dispose();
    _workshopController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    final odoText = _odometerController.text.trim();
    final nextKmText = _nextKmController.text.trim();
    final nextDate = _nextDateController.text.trim();
    final costText = _costController.text.trim();
    final partsText = _partsController.text.trim();
    final workshop = _workshopController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a service record title'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final odo = int.tryParse(odoText.replaceAll(',', '')) ?? 65000;
    final nextKm = int.tryParse(nextKmText.replaceAll(',', '')) ?? (odo + 5000);
    final cost = int.tryParse(costText.replaceAll(',', '')) ?? 30000;
    final partsList = partsText
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    widget.appState.addServiceRecord(
      vehicleId: widget.vehicleId,
      title: title,
      details: details,
      odometer: odo,
      nextServiceKm: nextKm,
      nextDate: nextDate.isEmpty ? '20 Nov 2026' : nextDate,
      cost: cost,
      partsChanged: partsList.isEmpty ? ['Engine Oil', 'Oil Filter'] : partsList,
      workshop: workshop.isEmpty ? 'K-Series Works SL' : workshop,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service bill added to Digital Glovebox!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: bottomInset + MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text(
                  'Add Service Record & Bill',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Record routine service bills, oil changes, and workshop invoices in your private glovebox.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),

            // Service Title
            _buildInputField(
              label: 'SERVICE TITLE',
              controller: _titleController,
              hint: 'e.g. 65,000 km Major Service & Fluid Flush',
              icon: LucideIcons.fileText,
            ),
            const SizedBox(height: 14),

            // Mileage Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'ODOMETER (KM)',
                    controller: _odometerController,
                    hint: '65000',
                    icon: LucideIcons.gauge,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    label: 'NEXT SERVICE (KM)',
                    controller: _nextKmController,
                    hint: '70000',
                    icon: LucideIcons.compass,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Next Date & Total Cost Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'NEXT SERVICE DATE',
                    controller: _nextDateController,
                    hint: '15 Mar 2027',
                    icon: LucideIcons.calendar,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    label: 'TOTAL BILL (LKR)',
                    controller: _costController,
                    hint: '32500',
                    icon: LucideIcons.banknote,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Parts Changed
            _buildInputField(
              label: 'PARTS CHANGED (COMMA-SEPARATED)',
              controller: _partsController,
              hint: 'Motul 300V 5W-40, HAMP Filter, Brake Pads',
              icon: LucideIcons.tag,
            ),
            const SizedBox(height: 14),

            // Workshop
            _buildInputField(
              label: 'WORKSHOP / MECHANIC NAME',
              controller: _workshopController,
              hint: 'e.g. K-Series Works SL · Nawala',
              icon: LucideIcons.wrench,
            ),
            const SizedBox(height: 14),

            // Details
            _buildInputField(
              label: 'SERVICE DETAILS & NOTES',
              controller: _detailsController,
              hint: 'Inspection notes, valve clearance check, etc.',
              icon: LucideIcons.info,
              maxLines: 2,
            ),
            const SizedBox(height: 14),

            // Receipt Photo Button
            GestureDetector(
              onTap: () => setState(() => _photoAttached = !_photoAttached),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: _photoAttached ? AppColors.primarySubtle : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _photoAttached ? AppColors.accent : AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.camera,
                      size: 16,
                      color: _photoAttached ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _photoAttached
                          ? '✓ Receipt Verified · Cloudinary WebP'
                          : 'Upload Bill / Receipt Photo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _photoAttached ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.check, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Save to Digital Glovebox',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 14 : 0),
                child: Icon(icon, size: 16, color: AppColors.textMuted),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
