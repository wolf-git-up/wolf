import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/tracked_ride.dart';
import '../providers/ride_provider.dart';
import '../providers/ride_tracking_provider.dart';
import '../services/ride_report_service.dart';
import '../theme/app_theme.dart';

class MapTabScreen extends StatefulWidget {
  final VoidCallback? onRideEnded;

  const MapTabScreen({super.key, this.onRideEnded});

  @override
  State<MapTabScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<MapTabScreen> {
  final MapController _mapController = MapController();
  final RideReportService _reportService = RideReportService();
  LatLng? _lastFollowedLocation;
  LatLng? _lastCenteredLocation;
  double _zoom = 15;
  bool _autoStartRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RideTrackingProvider>().loadCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<RideTrackingProvider>();
    final setup = context.watch<RideSetup>();
    final visiblePoints = tracking.visiblePoints;
    final current =
        tracking.currentLatLng ??
        (visiblePoints.isNotEmpty
            ? LatLng(visiblePoints.last.latitude, visiblePoints.last.longitude)
            : const LatLng(20, 0));
    final route = visiblePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    final start = route.isEmpty ? null : route.first;
    final end = route.isEmpty ? null : route.last;

    if (setup.isComplete &&
        !tracking.isTracking &&
        tracking.selectedRide == null &&
        !_autoStartRequested) {
      _autoStartRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RideTrackingProvider>().startRide();
        }
      });
    } else if (!setup.isComplete) {
      _autoStartRequested = false;
    }

    if (!tracking.isTracking &&
        tracking.currentLatLng != null &&
        tracking.currentLatLng != _lastCenteredLocation) {
      _lastCenteredLocation = tracking.currentLatLng;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(tracking.currentLatLng!, _zoom);
        }
      });
    }

    if (tracking.isTracking &&
        tracking.currentLatLng != null &&
        tracking.currentLatLng != _lastFollowedLocation) {
      _lastFollowedLocation = tracking.currentLatLng;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _mapController.move(tracking.currentLatLng!, _zoom);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.themedBackground,
      appBar: AppBar(
        title: Text(
          tracking.isTracking
              ? 'Ride Tracking'
              : (tracking.selectedRide == null ? 'Map' : 'Ride Report'),
        ),
        actions: [
          IconButton(
            tooltip: 'Center on current location',
            icon: const Icon(Icons.my_location),
            onPressed: tracking.currentLatLng == null
                ? null
                : () => _mapController.move(tracking.currentLatLng!, _zoom),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: Theme.of(context).brightness == Brightness.dark
                      ? const ColorFilter.matrix([
                          -0.7,
                          0,
                          0,
                          0,
                          255,
                          0,
                          -0.7,
                          0,
                          0,
                          255,
                          0,
                          0,
                          -0.7,
                          0,
                          255,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ])
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: current,
                      initialZoom: route.isEmpty ? 2 : _zoom,
                      onPositionChanged: (position, _) {
                        _zoom = position.zoom;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.bikers',
                      ),
                      if (route.length > 1)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: route,
                              color: AppColors.orange,
                              strokeWidth: 5,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (start != null)
                            _marker(start, AppColors.blue, Icons.trip_origin),
                          if (end != null && end != start)
                            _marker(end, AppColors.danger, Icons.flag),
                          if (tracking.currentLatLng != null)
                            _marker(
                              tracking.currentLatLng!,
                              AppColors.orange,
                              Icons.navigation,
                            ),
                        ],
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('OpenStreetMap contributors'),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Column(
                    children: [
                      _MapButton(
                        icon: Icons.add,
                        onPressed: () =>
                            _mapController.move(current, _zoom + 1),
                      ),
                      _MapButton(
                        icon: Icons.remove,
                        onPressed: () =>
                            _mapController.move(current, _zoom - 1),
                      ),
                    ],
                  ),
                ),
                if (tracking.errorMessage != null)
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 12,
                    child: Material(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          tracking.errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _MetricsPanel(tracking: tracking),
          _RideActions(
            tracking: tracking,
            setup: setup,
            reportService: _reportService,
            onRideEnded: widget.onRideEnded,
          ),
          _HistorySection(tracking: tracking),
        ],
      ),
    );
  }

  Marker _marker(LatLng point, Color color, IconData icon) => Marker(
    point: point,
    width: 42,
    height: 42,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}

class _MetricsPanel extends StatelessWidget {
  final RideTrackingProvider tracking;

  const _MetricsPanel({required this.tracking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      color: AppColors.themedSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Metric(
            label: 'Distance',
            value: '${tracking.distanceKm.toStringAsFixed(2)} km',
          ),
          _Metric(
            label: 'Speed',
            value: '${tracking.currentSpeedKmh.toStringAsFixed(1)} km/h',
          ),
          _Metric(
            label: 'Max',
            value: '${tracking.maximumSpeedKmh.toStringAsFixed(1)} km/h',
          ),
          _Metric(label: 'Stops', value: '${tracking.stopCount}'),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: TextStyle(color: AppColors.themedGrey, fontSize: 12)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          color: AppColors.themedText,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _RideActions extends StatelessWidget {
  final RideTrackingProvider tracking;
  final RideSetup setup;
  final RideReportService reportService;
  final VoidCallback? onRideEnded;

  const _RideActions({
    required this.tracking,
    required this.setup,
    required this.reportService,
    this.onRideEnded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(tracking.isTracking ? Icons.stop : Icons.play_arrow),
              style: ElevatedButton.styleFrom(
                backgroundColor: tracking.isTracking
                    ? AppColors.danger
                    : AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () =>
                  tracking.isTracking ? _stop(context) : _start(context),
              label: Text(tracking.isTracking ? 'STOP RIDE' : 'START RIDE'),
            ),
          ),
          if (!tracking.isTracking && tracking.selectedRide != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () =>
                    reportService.printReport(tracking.selectedRide!),
                label: const Text('Generate PDF Report'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _start(BuildContext context) async {
    final started = await tracking.startRide();
    if (!started && context.mounted && tracking.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tracking.errorMessage!)));
    }
  }

  Future<void> _stop(BuildContext context) async {
    final ride = await tracking.stopRide();
    if (ride == null || !context.mounted) return;
    setup.endRide();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride saved. Your PDF report is ready.')),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final RideTrackingProvider tracking;

  const _HistorySection({required this.tracking});

  @override
  Widget build(BuildContext context) {
    if (tracking.completedRides.isEmpty) return const SizedBox(height: 8);
    return SizedBox(
      height: 112,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        scrollDirection: Axis.horizontal,
        itemCount: tracking.completedRides.length,
        itemBuilder: (context, index) {
          final ride = tracking.completedRides[index];
          return _HistoryCard(
            ride: ride,
            onTap: () => tracking.selectRide(ride),
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final TrackedRide ride;
  final VoidCallback onTap;

  const _HistoryCard({required this.ride, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 230,
    child: Card(
      color: AppColors.themedCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ride.startTime.day}/${ride.startTime.month}/${ride.startTime.year}',
                style: TextStyle(
                  color: AppColors.themedText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${ride.distanceKm.toStringAsFixed(1)} km  |  ${ride.averageSpeedKmh.toStringAsFixed(1)} km/h avg',
                style: TextStyle(color: AppColors.themedGrey, fontSize: 12),
              ),
              Text(
                '${ride.totalDuration.inMinutes} min  |  ${ride.maximumSpeedKmh.toStringAsFixed(1)} km/h max  |  ${ride.stopCount} stops',
                style: TextStyle(color: AppColors.themedGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 4),
    child: IconButton(onPressed: onPressed, icon: Icon(icon)),
  );
}
