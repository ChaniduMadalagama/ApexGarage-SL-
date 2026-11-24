import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:apexgarage_sl/features/meets/view/create_crew_sheet.dart';
import 'package:apexgarage_sl/features/meets/view/host_meet_sheet.dart';
import 'package:apexgarage_sl/features/meets/view/interactive_map_view.dart';
import 'package:apexgarage_sl/shared/widgets/pill_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MeetsView extends StatefulWidget {
  final ApexAppState appState;

  const MeetsView({super.key, required this.appState});

  @override
  State<MeetsView> createState() => _MeetsViewState();
}

class _MeetsViewState extends State<MeetsView> {
  LatLng? _focusLocation;

  @override
  void initState() {
    super.initState();
    widget.appState.refreshLiveCrewRiders();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await appState.refreshLiveCrewRiders();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            children: [
              // Top Sub-tabs & Host action
              Row(
                children: [
                  Expanded(
                    child: PillSelector(
                      options: const ['Upcoming Meets', 'Crews'],
                      selected: appState.meetsSubTab,
                      onSelect: (val) => appState.setMeetsSubTab(val),
                    ),
                  ),
                  IconButton(
                    onPressed: () => HostMeetSheet.show(context, appState),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (appState.meetsSubTab == 'Upcoming Meets') ...[
                // Google Map showing Meets + Live Crew Riders
                InteractiveMapView(
                  appState: appState,
                  focusLocation: _focusLocation,
                ),
                const SizedBox(height: 18),

                // Live Crew Online & What They're Riding
                _buildLiveCrewSection(context, appState),
                const SizedBox(height: 20),

                // Meets List Header
                Row(
                  children: [
                    const Text(
                      'ALL UPCOMING MEETS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${appState.meets.length} scheduled',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Meets List
                ...appState.meets.map((m) => _buildMeetCard(context, appState, m)),
              ] else ...[
                // Live Crew Section in Crews Tab too
                _buildLiveCrewSection(context, appState),
                const SizedBox(height: 18),

                // Crews Sub-tab
                Row(
                  children: [
                    const Text(
                      'MOTORING CREWS & CLUBS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => CreateCrewSheet.show(context, appState),
                      icon: const Icon(LucideIcons.plus, size: 13),
                      label: const Text('Create Crew'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...appState.crews.map((c) => _buildCrewCard(context, appState, c)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCrewSection(BuildContext context, ApexAppState appState) {
    final riders = appState.liveCrewRiders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'MY CREW ONLINE & RIDING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${riders.length} live',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            if (appState.isAuthenticated)
              GestureDetector(
                onTap: () => _showGoLiveSheet(context, appState),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: appState.isRidingLive
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                  ),
                  child: Text(
                    appState.isRidingLive ? '● Riding Live' : '+ Go Live',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: appState.isRidingLive
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (riders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'No crew members are riding right now. Tap "+ Go Live" to share what you are riding on the map!',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          )
        else
          SizedBox(
            height: 118,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: riders.length,
              itemBuilder: (context, index) {
                final rider = riders[index];
                final isBike = rider.vehicleCategory.toLowerCase() == 'bike';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _focusLocation = LatLng(rider.latitude, rider.longitude);
                    });
                    if (appState.meetsSubTab != 'Upcoming Meets') {
                      appState.setMeetsSubTab('Upcoming Meets');
                    }
                  },
                  child: Container(
                    width: 230,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: rider.isMe
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.primarySubtle,
                                  child: Text(
                                    rider.avatar,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rider.isMe ? '${rider.name} (You)' : rider.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${rider.crewName} · ${rider.lastSeenAgo}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isBike ? LucideIcons.bike : LucideIcons.car,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  rider.vehicleTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (rider.statusNote != null &&
                            rider.statusNote!.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            rider.statusNote!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showGoLiveSheet(BuildContext context, ApexAppState appState) {
    final noteCtrl = TextEditingController();
    var selectedVehicleId = appState.vehicles.isNotEmpty
        ? appState.activeContextVehicleId
        : null;
    const hubs = <({String label, double lat, double lng})>[
      (label: 'Colombo Port City', lat: 6.9319, lng: 79.8428),
      (label: 'Marine Drive / Colombo 03', lat: 6.9110, lng: 79.8505),
      (label: 'Katukurunda Circuit', lat: 6.5553, lng: 79.9746),
      (label: 'Kandy City / Hanthana', lat: 7.2906, lng: 80.6337),
      (label: 'Galle Fort / Welipenna', lat: 6.4250, lng: 80.1300),
    ];
    var selectedHub = hubs.first;
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
                18,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Share Live Crew Ride',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Let your crew see you online and what you are riding on Google Maps.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 14),
                  if (appState.vehicles.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      initialValue: selectedVehicleId,
                      decoration: const InputDecoration(
                        labelText: 'What are you riding?',
                      ),
                      items: appState.vehicles
                          .map((v) => DropdownMenuItem(
                                value: v.id,
                                child: Text('${v.title} (${v.category})'),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setSheetState(() => selectedVehicleId = v),
                    ),
                    const SizedBox(height: 10),
                  ],
                  DropdownButtonFormField<String>(
                    initialValue: selectedHub.label,
                    decoration: const InputDecoration(
                      labelText: 'Current Area / Pin',
                    ),
                    items: hubs
                        .map((h) => DropdownMenuItem(
                              value: h.label,
                              child: Text(h.label),
                            ))
                        .toList(),
                    onChanged: (val) {
                      final match = hubs.firstWhere(
                        (h) => h.label == val,
                        orElse: () => hubs.first,
                      );
                      setSheetState(() => selectedHub = match);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ride Status Note (Optional)',
                      hintText: 'e.g. Heading to Port City meet',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (appState.isRidingLive) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: saving
                                ? null
                                : () async {
                                    setSheetState(() => saving = true);
                                    await appState.toggleLiveRiding(
                                      isRiding: false,
                                      latitude: selectedHub.lat,
                                      longitude: selectedHub.lng,
                                    );
                                    if (!ctx.mounted) return;
                                    Navigator.of(ctx).pop();
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFFECACA)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Go Offline'),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: saving
                              ? null
                              : () async {
                                  setSheetState(() => saving = true);
                                  await appState.toggleLiveRiding(
                                    isRiding: true,
                                    vehicleId: selectedVehicleId,
                                    latitude: selectedHub.lat,
                                    longitude: selectedHub.lng,
                                    statusNote: noteCtrl.text.trim(),
                                  );
                                  if (!ctx.mounted) return;
                                  Navigator.of(ctx).pop();
                                  setState(() {
                                    _focusLocation = LatLng(
                                      selectedHub.lat,
                                      selectedHub.lng,
                                    );
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(saving ? 'Updating...' : 'Go Live Now'),
                        ),
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

  Widget _buildMeetCard(
    BuildContext context,
    ApexAppState appState,
    MeetModel meet,
  ) {
    final isRsvpd = appState.rsvpMeetIds.contains(meet.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  meet.date,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(LucideIcons.users, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${meet.going} Going',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            meet.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _focusLocation = LatLng(meet.latitude, meet.longitude);
              });
            },
            child: Row(
              children: [
                const Icon(LucideIcons.mapPin, size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${meet.location} · View on Map',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Host: ${meet.host}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => appState.toggleMeetRsvp(meet.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRsvpd ? AppColors.primary : AppColors.surface,
                  foregroundColor: isRsvpd ? Colors.white : AppColors.primary,
                  side: BorderSide(
                    color: isRsvpd ? Colors.transparent : AppColors.primary,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isRsvpd ? '✓ Attending' : 'RSVP'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCrewCard(
    BuildContext context,
    ApexAppState appState,
    CrewModel crew,
  ) {
    final isJoined = appState.joinedCrewIds.contains(crew.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.flag, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${crew.members} Members · ${crew.category}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            crew.description,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                crew.location,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => appState.toggleJoinCrew(crew.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isJoined ? AppColors.primary : AppColors.surface,
                  foregroundColor: isJoined ? Colors.white : AppColors.primary,
                  side: BorderSide(
                    color: isJoined ? Colors.transparent : AppColors.primary,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isJoined ? '✓ Joined' : 'Join Crew'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
