import 'package:flutter/material.dart';
import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/shared/widgets/brand_crest.dart';
import 'package:apexgarage_sl/shared/widgets/vehicle_illustrations.dart';

class WatermarkCard extends StatelessWidget {
  final String brand;
  final String title;
  final String subtitle;
  final String? statusPill;
  final bool statusAccent;
  final String watermark;
  final String illustrationType;
  final String? photoUrl;
  final List<SpecItem> specs;
  final String rightValue;
  final String? rightUnit;
  final VoidCallback? onClick;
  final Color? accentColor;

  WatermarkCard({
    super.key,
    required this.brand,
    required this.title,
    required this.subtitle,
    String? statusPill,
    String? statusBadge,
    this.statusAccent = false,
    required this.watermark,
    String? illustrationType,
    String? illustrationKey,
    this.photoUrl,
    required this.specs,
    String? rightValue,
    String? metricValue,
    String? rightUnit,
    String? metricUnit,
    VoidCallback? onClick,
    VoidCallback? onTap,
    this.accentColor,
  })  : statusPill = statusPill ?? statusBadge,
        illustrationType = illustrationType ?? illustrationKey ?? 'fd2',
        rightValue = rightValue ?? metricValue ?? '',
        rightUnit = rightUnit ?? metricUnit,
        onClick = onClick ?? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Brand Crest + Title + Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandCrest(brand: brand),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (statusPill != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusAccent ? AppColors.mintBg : const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: statusAccent ? AppColors.emeraldMint.withValues(alpha: 0.5) : AppColors.neutralBorder,
                      ),
                    ),
                    child: Text(
                      statusPill!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusAccent ? AppColors.emeraldDark : const Color(0xFF374151),
                      ),
                    ),
                  ),
              ],
            ),

            // Middle: Real Photo (if uploaded) or GIANT Watermark + Vector Illustration
            SizedBox(
              height: (photoUrl != null && photoUrl!.isNotEmpty) ? 148 : 116,
              child: (photoUrl != null && photoUrl!.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        photoUrl!,
                        width: double.infinity,
                        height: 148,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildWatermarkIllustration(),
                      ),
                    )
                  : _buildWatermarkIllustration(),
            ),

            // Bottom Row: Spec Chips + Right Value/Unit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: specs.map((s) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(s.icon, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              s.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                if (rightValue.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rightValue,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (rightUnit != null) ...[
                        const SizedBox(width: 2),
                        Text(
                          rightUnit!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatermarkIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            watermark,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: AppColors.watermarkText,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
        ),
        VehicleIllustration(
          type: illustrationType,
          width: 250,
          height: 106,
        ),
      ],
    );
  }
}
