import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';

class HostMeetSheet extends StatefulWidget {
  final ApexAppState appState;

  const HostMeetSheet({super.key, required this.appState});

  static Future<void> show(BuildContext context, ApexAppState appState) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HostMeetSheet(appState: appState),
    );
  }

  @override
  State<HostMeetSheet> createState() => _HostMeetSheetState();
}

class _HostMeetSheetState extends State<HostMeetSheet> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const _mapHubs = <({String label, double lat, double lng})>[
    (label: 'Port City Colombo', lat: 6.9319, lng: 79.8428),
    (label: 'Katukurunda Circuit', lat: 6.5553, lng: 79.9746),
    (label: 'Kandy City / Hanthana', lat: 7.2906, lng: 80.6337),
    (label: 'Welipenna Rest Area', lat: 6.4250, lng: 80.1300),
    (label: 'Negombo Beach Park', lat: 7.2116, lng: 79.8386),
  ];

  var _selectedHub = _mapHubs.first;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a meet title'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    widget.appState.createMeet(
      title: title,
      location: location.isEmpty ? _selectedHub.label : location,
      date: _dateController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: _selectedHub.lat,
      longitude: _selectedHub.lng,
    );
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meet "$title" published!'),
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
                  'Host an Enthusiast Meet',
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
              'Organize car & bike meets, cruises, and track day meetups.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),

            // Title
            _buildInputField(
              label: 'MEET TITLE',
              controller: _titleController,
              hint: 'e.g. Colombo JDM Midnight Cruise',
              icon: LucideIcons.calendar,
            ),
            const SizedBox(height: 14),

            // Location
            _buildInputField(
              label: 'MEETING SPOT / VENUE',
              controller: _locationController,
              hint: 'e.g. Colombo Port City, Katukurunda',
              icon: LucideIcons.mapPin,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _selectedHub.label,
              decoration: InputDecoration(
                labelText: 'GOOGLE MAP PIN REGION',
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _mapHubs
                  .map((h) => DropdownMenuItem(value: h.label, child: Text(h.label)))
                  .toList(),
              onChanged: (val) {
                final hub = _mapHubs.firstWhere(
                  (h) => h.label == val,
                  orElse: () => _mapHubs.first,
                );
                setState(() => _selectedHub = hub);
              },
            ),
            const SizedBox(height: 14),

            // Date
            _buildInputField(
              label: 'DATE & TIME',
              controller: _dateController,
              hint: 'e.g. Friday 9:00 PM',
              icon: LucideIcons.clock,
            ),
            const SizedBox(height: 14),

            // Description
            _buildInputField(
              label: 'MEET RULES & ROUTE',
              controller: _descriptionController,
              hint: 'e.g. Respect speed limits, no revving in residential areas',
              icon: LucideIcons.info,
              maxLines: 2,
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
                  Icon(LucideIcons.mapPin, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Publish Meet to Map',
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 14,
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
