import 'package:apexgarage_sl/core/services/api_repository.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SellerDashboardView extends StatelessWidget {
  final ApexAppState appState;
  final VoidCallback onOpenAddPart;

  const SellerDashboardView({
    super.key,
    required this.appState,
    required this.onOpenAddPart,
  });

  @override
  Widget build(BuildContext context) {
    final dash = appState.sellerDashboard;
    if (dash == null) {
      if (appState.isSellerLoading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryEmerald),
        );
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                appState.sellerError ?? 'Unable to load shop dashboard.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: appState.loadSellerDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final shop = dash.shop;
    final stats = dash.stats;
    final isVerified = shop.status == 'Verified';

    return RefreshIndicator(
      color: AppColors.primaryEmerald,
      onRefresh: appState.loadSellerDashboard,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          // Top Shop Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isVerified
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: isVerified
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      child: Text(
                        isVerified ? 'VERIFIED SHOP PARTNER' : shop.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: isVerified
                              ? const Color(0xFF047857)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      shop.businessName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${shop.location} · BR ${shop.brNumber}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: appState.loadSellerDashboard,
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                tooltip: 'Refresh Dashboard',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2x2 KPI Grid
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  label: 'Active Listings',
                  value: '${stats.approvedCount}/${stats.listingsCount}',
                  sub: '${stats.pendingCount} pending review',
                  accent: AppColors.primaryEmerald,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  label: 'Listing Views',
                  value: '${stats.totalViews}',
                  sub: 'Marketplace impressions',
                  accent: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  label: 'Open Inquiries',
                  value: '${stats.openInquiriesCount}',
                  sub: '${stats.inquiriesCount} total threads',
                  accent: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  label: 'Workshop Slots',
                  value: '${stats.pendingBookingsCount}',
                  sub: '${stats.bookingsCount} total bookings',
                  accent: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpenAddPart,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Part'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => appState.setSellerTab('inquiries'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                  label: const Text('Inquiries'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Recent Inquiries Preview
          _SectionHeader(
            title: 'Recent Buyer Inquiries',
            actionLabel: 'See All',
            onAction: () => appState.setSellerTab('inquiries'),
          ),
          const SizedBox(height: 10),
          if (dash.inquiries.isEmpty)
            const _EmptyBanner(text: 'No buyer inquiries yet.')
          else
            ...dash.inquiries.take(2).map((inq) => _InquiryPreviewTile(
                  inquiry: inq,
                  onTap: () => appState.setSellerTab('inquiries'),
                )),

          const SizedBox(height: 18),

          // Upcoming Workshop Bookings Preview
          _SectionHeader(
            title: 'Upcoming Workshop Slots',
            actionLabel: 'Manage',
            onAction: () => appState.setSellerTab('workshop'),
          ),
          const SizedBox(height: 10),
          if (dash.bookings.isEmpty)
            const _EmptyBanner(text: 'No workshop bookings yet.')
          else
            ...dash.bookings.take(2).map((b) => _BookingPreviewTile(
                  booking: b,
                  onTap: () => appState.setSellerTab('workshop'),
                )),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color accent;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryEmerald,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyBanner extends StatelessWidget {
  final String text;
  const _EmptyBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
      ),
    );
  }
}

class _InquiryPreviewTile extends StatelessWidget {
  final ApiSellerInquiry inquiry;
  final VoidCallback onTap;

  const _InquiryPreviewTile({required this.inquiry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inquiry.partTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${inquiry.buyerName} · ${inquiry.vehicle}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
      ),
    );
  }
}

class _BookingPreviewTile extends StatelessWidget {
  final ApiSellerBooking booking;
  final VoidCallback onTap;

  const _BookingPreviewTile({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.service,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${booking.customerName} · ${booking.slotDate}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: booking.status == 'Pending'
                    ? const Color(0xFFFFFBEB)
                    : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                booking.status,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: booking.status == 'Pending'
                      ? const Color(0xFFB45309)
                      : const Color(0xFF047857),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
