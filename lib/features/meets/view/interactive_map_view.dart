import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InteractiveMapView extends StatefulWidget {
  final ApexAppState appState;
  final LatLng? focusLocation;

  const InteractiveMapView({
    super.key,
    required this.appState,
    this.focusLocation,
  });

  @override
  State<InteractiveMapView> createState() => _InteractiveMapViewState();
}

class _InteractiveMapViewState extends State<InteractiveMapView> {
  GoogleMapController? _mapController;

  static const LatLng _colomboCenter = LatLng(6.9271, 79.8612);

  @override
  void didUpdateWidget(covariant InteractiveMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.focusLocation;
    if (next != null && next != oldWidget.focusLocation) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(next, 13.5),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (final meet in widget.appState.meets) {
      markers.add(
        Marker(
          markerId: MarkerId('meet_${meet.id}'),
          position: LatLng(meet.latitude, meet.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: meet.title,
            snippet: '${meet.location} · ${meet.going} going',
          ),
        ),
      );
    }

    for (final rider in widget.appState.liveCrewRiders) {
      markers.add(
        Marker(
          markerId: MarkerId('rider_${rider.userId}'),
          position: LatLng(rider.latitude, rider.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            rider.isMe
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: '${rider.name} (${rider.crewName})',
            snippet: 'Riding: ${rider.vehicleTitle}',
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final initialTarget = widget.appState.meets.isNotEmpty
        ? LatLng(
            widget.appState.meets.first.latitude,
            widget.appState.meets.first.longitude,
          )
        : _colomboCenter;

    return Container(
      height: 245,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 10.6,
            ),
            markers: _buildMarkers(),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          // Legend Overlay
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendDot(color: Color(0xFF16A34A), label: 'Meets'),
                  SizedBox(width: 10),
                  _LegendDot(color: Color(0xFF2563EB), label: 'Crew Riding'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
