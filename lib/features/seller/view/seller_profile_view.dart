import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SellerProfileView extends StatefulWidget {
  final ApexAppState appState;

  const SellerProfileView({super.key, required this.appState});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> {
  late TextEditingController _nameCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _specialtyCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final shop = widget.appState.sellerDashboard?.shop;
    _nameCtrl = TextEditingController(text: shop?.businessName ?? '');
    _locationCtrl = TextEditingController(text: shop?.location ?? '');
    _phoneCtrl = TextEditingController(text: shop?.phone ?? '');
    _specialtyCtrl = TextEditingController(text: shop?.specialty ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _phoneCtrl.dispose();
    _specialtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.appState.sellerDashboard?.shop;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        const Text(
          'Shop Profile & BR Trust',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BR Number: ${shop?.brNumber ?? 'Registered'}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Verification Status: ${shop?.status ?? 'Verified'} · ${shop?.type ?? 'Verified Merchant'}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              if ((shop?.documents ?? []).isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: shop!.documents
                      .map((doc) => Chip(
                            label: Text(doc, style: const TextStyle(fontSize: 11)),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ProfileField(controller: _nameCtrl, label: 'Business Name'),
        _ProfileField(controller: _locationCtrl, label: 'City / Location'),
        _ProfileField(controller: _phoneCtrl, label: 'Business Phone'),
        _ProfileField(controller: _specialtyCtrl, label: 'Specialty'),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving
                ? null
                : () async {
                    setState(() => _saving = true);
                    final ok = await widget.appState.updateSellerProfile(
                      businessName: _nameCtrl.text.trim(),
                      location: _locationCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      specialty: _specialtyCtrl.text.trim(),
                    );
                    if (!mounted) return;
                    setState(() => _saving = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? 'Shop profile updated.' : 'Could not update profile.',
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryEmerald,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(_saving ? 'Saving...' : 'Save Shop Profile'),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.appState.signOut,
            icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFECACA)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _ProfileField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
    );
  }
}
