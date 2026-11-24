import 'dart:io';

import 'package:apexgarage_sl/core/services/api_repository.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellerInventoryView extends StatefulWidget {
  final ApexAppState appState;

  const SellerInventoryView({super.key, required this.appState});

  @override
  State<SellerInventoryView> createState() => _SellerInventoryViewState();
}

class _SellerInventoryViewState extends State<SellerInventoryView> {
  String _filter = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final parts = widget.appState.sellerDashboard?.parts ?? const <ApiSellerPart>[];
    final filtered = parts.where((item) {
      final matchesStatus = _filter == 'All' || item.status == _filter;
      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.part.title.toLowerCase().contains(q) ||
          item.part.brand.toLowerCase().contains(q) ||
          item.sku.toLowerCase().contains(q);
      return matchesStatus && matchesQuery;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Parts Inventory',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPartSheet(context),
                    icon: const Icon(Icons.add_rounded, size: 17),
                    label: const Text('Add Part'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryEmerald,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search SKU, title, or brand...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Approved', 'Pending Review', 'Flagged']
                      .map((status) {
                    final selected = _filter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: selected,
                        onSelected: (_) => setState(() => _filter = status),
                        selectedColor: AppColors.primaryEmerald,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryEmerald,
            onRefresh: widget.appState.loadSellerDashboard,
            child: filtered.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      Center(
                        child: Text(
                          'No matching parts in your shop inventory.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _SellerPartCard(
                        item: item,
                        onEdit: () => _showEditPartSheet(context, item),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _showAddPartSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final fitmentCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '1');
    final descCtrl = TextEditingController();
    var condition = 'Brand New';
    var illustration = 'turbo';
    File? photoFile;
    var saving = false;

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
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Shop Part Listing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SheetField(controller: titleCtrl, label: 'Part Title', hint: 'e.g. HKS GTIII-RS Turbo'),
                    _SheetField(controller: brandCtrl, label: 'Brand', hint: 'e.g. HKS'),
                    _SheetField(controller: fitmentCtrl, label: 'Fitment', hint: 'e.g. Nissan Silvia S15 / SR20DET'),
                    Row(
                      children: [
                        Expanded(
                          child: _SheetField(
                            controller: priceCtrl,
                            label: 'Price (LKR)',
                            hint: '285000',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SheetField(
                            controller: stockCtrl,
                            label: 'Stock Qty',
                            hint: '1',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: condition,
                            decoration: const InputDecoration(labelText: 'Condition'),
                            items: const ['Brand New', 'JDM Recond', 'Used - Mint']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setSheetState(() => condition = v ?? condition),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: illustration,
                            decoration: const InputDecoration(labelText: 'Category Icon'),
                            items: const ['turbo', 'caliper', 'exhaust', 'coilover']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setSheetState(() => illustration = v ?? illustration),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SheetField(
                      controller: descCtrl,
                      label: 'Description',
                      hint: 'Condition notes & warranty',
                    ),
                    const SizedBox(height: 6),
                    if (photoFile != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              photoFile!,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => setSheetState(() => photoFile = null),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                            maxWidth: 1600,
                          );
                          if (picked == null) return;
                          setSheetState(() => photoFile = File(picked.path));
                        },
                        icon: const Icon(Icons.camera_alt_outlined, size: 17),
                        label: const Text('Upload Part Photo (Optional)'),
                      ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saving
                            ? null
                            : () async {
                                final title = titleCtrl.text.trim();
                                final brand = brandCtrl.text.trim();
                                final fitment = fitmentCtrl.text.trim();
                                final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
                                final stock = int.tryParse(stockCtrl.text.trim()) ?? 1;
                                if (title.isEmpty || brand.isEmpty || price < 100) {
                                  return;
                                }
                                setSheetState(() => saving = true);
                                final ok = await widget.appState.createSellerPart(
                                  title: title,
                                  brand: brand,
                                  fitment: fitment.isEmpty ? 'Universal' : fitment,
                                  priceLkr: price,
                                  stock: stock,
                                  condition: condition,
                                  illustration: illustration,
                                  description: descCtrl.text,
                                  photoFile: photoFile,
                                );
                                if (!ctx.mounted) return;
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok ? 'Part submitted for review.' : 'Could not add part.',
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryEmerald,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(saving ? 'Saving...' : 'Publish Part'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditPartSheet(BuildContext context, ApiSellerPart item) {
    final priceCtrl = TextEditingController(text: '${item.part.price}');
    final stockCtrl = TextEditingController(text: '${item.stock}');
    var saving = false;

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
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.part.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${item.sku} · ${item.status}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  _SheetField(
                    controller: priceCtrl,
                    label: 'Price (LKR)',
                    hint: '285000',
                    keyboardType: TextInputType.number,
                  ),
                  _SheetField(
                    controller: stockCtrl,
                    label: 'Stock Quantity',
                    hint: '2',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              final price = int.tryParse(priceCtrl.text.trim()) ?? item.part.price;
                              final stock = int.tryParse(stockCtrl.text.trim()) ?? item.stock;
                              setSheetState(() => saving = true);
                              final ok = await widget.appState.updateSellerPart(
                                partId: item.part.id,
                                priceLkr: price,
                                stock: stock,
                              );
                              if (!ctx.mounted) return;
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(ok ? 'Inventory updated.' : 'Update failed.'),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(saving ? 'Updating...' : 'Save Stock & Price'),
                    ),
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

class _SellerPartCard extends StatelessWidget {
  final ApiSellerPart item;
  final VoidCallback onEdit;

  const _SellerPartCard({required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final approved = item.status == 'Approved';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.part.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: approved
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: approved
                        ? const Color(0xFF047857)
                        : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${item.part.brand} · ${item.fitment.isEmpty ? item.part.subtitle : item.fitment}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LKR ${item.part.price} · Stock: ${item.stock}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryEmerald,
                ),
              ),
              TextButton(
                onPressed: onEdit,
                child: const Text('Edit Stock & Price'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: AppColors.inputSoftGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
