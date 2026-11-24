import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/ios_phone_frame.dart';
import 'package:apexgarage_sl/features/apex_garage/core/widgets/watermark_showcase_card.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/state/garage_app_state.dart';

class Screen09Feed extends StatelessWidget {
  final bool isStandalone;
  final void Function(int)? onSelectScreen;

  const Screen09Feed({
    super.key,
    this.isStandalone = false,
    this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GarageAppState>();
    final jumper = onSelectScreen ?? state.jumpToScreen;

    final topics = ['All Activity', 'Build Updates', 'Track Days', 'Rare Parts Drop'];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feed Topic Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: topics.map((tp) {
              final active = state.feedTopic == tp;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => state.setFeedTopic(tp),
                  borderRadius: BorderRadius.circular(100),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFFECFDF5) : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: active ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tp,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: active ? const Color(0xFF009B65) : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // Enthusiast Build Post
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '@chanidu_s15 ',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: 'logged a dyno run',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF8E959E),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '2h ago',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF009B65),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        WatermarkShowcaseCard(
          brand: 'Porsche',
          title: 'Porsche 911 GT3 RS',
          subtitle: 'Katukurunda Time Attack • 1:04.2',
          badge: 'New Lap Record',
          watermark: '911 GT3 RS',
          graphicType: 'porsche_red',
          meta1: state.likedPost ? '143♥' : '142♥',
          meta1Icon: LucideIcons.heart,
          meta2: '28💬',
          meta2Icon: LucideIcons.messageCircle,
          meta3: 'Stage 2',
          priceMain: '520',
          priceSub: '/whp',
          onClick: state.toggleLikedPost,
        ),

        const SizedBox(height: 16),

        // Native Sponsored Ad Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SPONSORED PARTNER • DUAL-REVENUE SLOT',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E959E),
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Ad',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009B65),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        WatermarkShowcaseCard(
          brand: 'Motul',
          title: 'Motul 300V Ester Core',
          subtitle: '15W50 Racing Oil • Official Partner',
          badge: 'Sponsored',
          watermark: 'MOTUL 300V',
          graphicType: 'te37_wheel',
          meta1: '10% Off',
          meta1Icon: LucideIcons.sparkles,
          meta2: 'JDM',
          meta2Icon: LucideIcons.gitCommit,
          meta3: 'Colombo',
          meta3Icon: LucideIcons.mapPin,
          priceMain: 'LKR 14.5k',
          priceSub: '/4L',
          onClick: () => jumper(5),
        ),
      ],
    );

    return IOSPhoneFrame(
      screenNumber: '09',
      screenTitle: 'Community Feed & Sponsored Ad',
      headerTitle: 'Community Feed',
      rightHeaderWidget: const Icon(LucideIcons.bell, size: 18, color: Color(0xFF111827)),
      activeBottomTab: 'feed',
      onSelectScreen: jumper,
      isStandalonePhone: isStandalone,
      child: content,
    );
  }
}
