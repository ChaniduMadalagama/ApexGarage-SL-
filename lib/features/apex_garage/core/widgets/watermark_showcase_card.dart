import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/brand_badge.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/studio_cutout_graphic.dart';

class WatermarkShowcaseCard extends StatefulWidget {
  final String brand;
  final String title;
  final String subtitle;
  final String? badge;
  final String watermark;
  final String graphicType;
  final String meta1;
  final String meta2;
  final String meta3;
  final String priceMain;
  final String priceSub;
  final VoidCallback? onClick;
  final bool selected;
  final IconData? meta1Icon;
  final IconData? meta2Icon;
  final IconData? meta3Icon;

  const WatermarkShowcaseCard({
    super.key,
    required this.brand,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.watermark,
    required this.graphicType,
    this.meta1 = '2',
    this.meta2 = 'M.',
    this.meta3 = '4 Unit',
    this.priceMain = '\$250',
    this.priceSub = '/day',
    this.onClick,
    this.selected = false,
    this.meta1Icon,
    this.meta2Icon,
    this.meta3Icon,
  });

  @override
  State<WatermarkShowcaseCard> createState() => _WatermarkShowcaseCardState();
}

class _WatermarkShowcaseCardState extends State<WatermarkShowcaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.selected
        ? const Color(0xFF10B981)
        : (_isHovered ? const Color(0xFF10B981).withValues(alpha: 0.6) : const Color(0xFFECEEF0));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row: Brand Crest + Title/Subtitle + Status Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandBadge(brand: widget.brand),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E959E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (widget.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        widget.badge!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                ],
              ),

              // Center Stage: Giant Watermark + Studio Cutout Graphic
              SizedBox(
                height: 104,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Giant Watermark Text
                    Positioned.fill(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.watermark,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF1F3F5),
                              letterSpacing: -1.2,
                              height: 1.0,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    // Cutout Graphic with slight scale on hover
                    AnimatedScale(
                      scale: _isHovered ? 1.04 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: StudioCutoutGraphic(
                        type: widget.graphicType,
                        width: 250,
                        height: 96,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Row: Thin-stroke spec icons + Bold Metric/Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildMetaChip(widget.meta1Icon ?? LucideIcons.users, widget.meta1),
                      const SizedBox(width: 10),
                      _buildMetaChip(widget.meta2Icon ?? LucideIcons.gitCommit, widget.meta2),
                      const SizedBox(width: 10),
                      _buildMetaChip(widget.meta3Icon ?? LucideIcons.car, widget.meta3),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.priceMain,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.priceSub}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E959E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8E959E)),
        const SizedBox(width: 3.5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
