import 'package:apexgarage_sl/core/services/api_repository.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SellerInquiriesView extends StatelessWidget {
  final ApexAppState appState;

  const SellerInquiriesView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final inquiries =
        appState.sellerDashboard?.inquiries ?? const <ApiSellerInquiry>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Text(
            'Buyer Inquiries & Orders',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryEmerald,
            onRefresh: appState.loadSellerDashboard,
            child: inquiries.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      Center(
                        child: Text(
                          'No buyer inquiries yet.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      final inq = inquiries[index];
                      return _InquiryCard(
                        inquiry: inq,
                        onOpenChat: () => _openChatSheet(context, inq),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _openChatSheet(BuildContext context, ApiSellerInquiry inquiry) {
    final replyCtrl = TextEditingController();
    var selectedStatus = inquiry.status == 'New Inquiry' ? 'Replied' : inquiry.status;
    var sending = false;

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
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inquiry.partTitle,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${inquiry.buyerName} · ${inquiry.vehicle} · Offer LKR ${inquiry.offerLkr}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: inquiry.messages.length,
                      itemBuilder: (_, i) {
                        final msg = inquiry.messages[i];
                        final isSeller = msg.from == 'seller';
                        return Align(
                          alignment: isSeller
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: isSeller
                                  ? AppColors.primaryEmerald
                                  : AppColors.inputSoftGrey,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSeller ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Update Inquiry Status',
                      isDense: true,
                    ),
                    items: const [
                      'Replied',
                      'Reserved (Pickup)',
                      'Closed',
                    ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setSheetState(() => selectedStatus = v ?? selectedStatus),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyCtrl,
                          decoration: InputDecoration(
                            hintText: 'Write reply to ${inquiry.buyerName}...',
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
                        onPressed: sending
                            ? null
                            : () async {
                                final text = replyCtrl.text.trim();
                                if (text.isEmpty) return;
                                setSheetState(() => sending = true);
                                final ok = await appState.replySellerInquiry(
                                  inquiryId: inquiry.id,
                                  message: text,
                                  status: selectedStatus,
                                );
                                if (!ctx.mounted) return;
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok ? 'Reply sent.' : 'Could not send reply.',
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryEmerald,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(sending ? '...' : 'Send'),
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

class _InquiryCard extends StatelessWidget {
  final ApiSellerInquiry inquiry;
  final VoidCallback onOpenChat;

  const _InquiryCard({required this.inquiry, required this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenChat,
      child: Container(
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
                    inquiry.partTitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    inquiry.status,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF047857),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${inquiry.buyerName} · ${inquiry.vehicle}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offer: LKR ${inquiry.offerLkr}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryEmerald,
                  ),
                ),
                Text(
                  '${inquiry.messages.length} msgs · Tap to reply',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
