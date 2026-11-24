import 'package:apexgarage_sl/core/services/api_repository.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SellerWorkshopView extends StatelessWidget {
  final ApexAppState appState;

  const SellerWorkshopView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final bookings =
        appState.sellerDashboard?.bookings ?? const <ApiSellerBooking>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Text(
            'Workshop & Dyno Slots',
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
            child: bookings.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      Center(
                        child: Text(
                          'No workshop bookings assigned yet.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return _BookingCard(
                        booking: booking,
                        onTransition: (status) async {
                          final ok = await appState.updateSellerBooking(
                            bookingId: booking.id,
                            status: status,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok
                                    ? 'Booking marked as $status.'
                                    : 'Could not update booking.',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  final ApiSellerBooking booking;
  final ValueChanged<String> onTransition;

  const _BookingCard({
    required this.booking,
    required this.onTransition,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = booking.status == 'Pending';
    final isConfirmed = booking.status == 'Confirmed';

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
                  booking.service,
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
                  color: isPending
                      ? const Color(0xFFFFFBEB)
                      : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isPending
                        ? const Color(0xFFB45309)
                        : const Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${booking.customerName} · ${booking.vehicle}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '${booking.slotDate} · Est. LKR ${booking.estimateLkr}',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (isPending || isConfirmed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (isPending)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onTransition('Confirmed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Confirm Slot'),
                    ),
                  ),
                if (isConfirmed)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onTransition('Completed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryEmerald,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Mark Completed'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
