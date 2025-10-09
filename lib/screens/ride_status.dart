import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../api/api_service.dart';
import 'dart:math';

class RideStatus extends StatefulWidget {
  final int rideId;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  const RideStatus({super.key, required this.rideId, required this.pickupLocation, required this.dropoffLocation});

  @override
  State<RideStatus> createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  final ApiService _apiService = ApiService();
  String _statusMessage = "Searching for a rider...";
  String _currentStatus = "SEARCHING_FOR_RIDER";
  String? _eta;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _riderPosition;
  BitmapDescriptor? _riderIcon;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(markerId: const MarkerId('pickup'), position: widget.pickupLocation, infoWindow: const InfoWindow(title: 'Pickup Location')));
    _markers.add(Marker(markerId: const MarkerId('dropoff'), position: widget.dropoffLocation, infoWindow: const InfoWindow(title: 'Dropoff Location')));
    _loadCustomIcon();
    _setupWebSocketListeners();
  }

  @override
  void dispose() {
    _apiService.stopListeningToRideUpdates('ride-update-${widget.rideId}');
    _apiService.stopListeningToRideUpdates('ride-location-update-${widget.rideId}');
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCustomIcon() async {
    _riderIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/car_icon.png',
    );
  }

  void _setupWebSocketListeners() {
    _apiService.listenToRideUpdates('ride-update-${widget.rideId}', (data) {
      if (!mounted) return;
      final newStatus = data['status'];
      final riderId = data['riderId'];
      setState(() {
        _currentStatus = newStatus;
        switch (newStatus) {
          case 'ACCEPTED': _statusMessage = "Rider #$riderId is on the way!"; break;
          case 'PICKED_UP': _statusMessage = "You're on your way!"; break;
          case 'COMPLETED': _statusMessage = "Ride Completed. Thank you!"; _polylines.clear(); break;
        }
      });
      if (newStatus == 'PICKED_UP' && _riderPosition != null) {
        _drawRoute(_riderPosition!, widget.dropoffLocation);
      }
    });

    _apiService.listenToRideUpdates('ride-location-update-${widget.rideId}', (data) {
      if (mounted && data['lat'] != null && data['lng'] != null) {
        final newRiderPosition = LatLng(data['lat'], data['lng']);
        setState(() {
          _riderPosition = newRiderPosition;
          _markers.removeWhere((m) => m.markerId.value == 'riderLocation');
          _markers.add(Marker(
            markerId: const MarkerId('riderLocation'),
            position: newRiderPosition,
            icon: _riderIcon ?? BitmapDescriptor.defaultMarker,
            anchor: const Offset(0.5, 0.5),
            flat: true,
          ));
        });
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(seconds: 5), () {
          if (_currentStatus == 'ACCEPTED') {
            _drawRoute(newRiderPosition, widget.pickupLocation);
          } else if (_currentStatus == 'PICKED_UP') {
            _drawRoute(newRiderPosition, widget.dropoffLocation);
          }
        });
      }
    });
  }
  
  Future<void> _drawRoute(LatLng start, LatLng end) async {
    try {
      final routeData = await _apiService.getRoutePolyline(start, end);
      final String encodedPolyline = routeData['polyline'];
      final String duration = routeData['duration'];
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedResult = polylinePoints.decodePolyline(encodedPolyline);
      List<LatLng> points = decodedResult.map((p) => LatLng(p.latitude, p.longitude)).toList();
      if (points.isEmpty) return;
      final Polyline routePolyline = Polyline(polylineId: const PolylineId('dynamic_route'), color: Colors.deepPurple, width: 5, points: points);
      setState(() {
        _polylines.clear();
        _polylines.add(routePolyline);
        _eta = duration;
      });
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(min(start.latitude, end.latitude), min(start.longitude, end.longitude)),
          northeast: LatLng(max(start.latitude, end.latitude), max(start.longitude, end.longitude)),
        ), 80.0
      ));
    } catch (e) {
      print('Error drawing route: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Status')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: widget.pickupLocation, zoom: 14),
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_currentStatus == "SEARCHING_FOR_RIDER") const CircularProgressIndicator(),
                    if (_currentStatus == "ACCEPTED") const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    if (_currentStatus == "PICKED_UP") const Icon(Icons.drive_eta, color: Colors.orange, size: 40),
                    if (_currentStatus == "COMPLETED") const Icon(Icons.check_circle, color: Colors.green, size: 40),
                    const SizedBox(height: 16),
                    Text(_statusMessage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                    if (_eta != null) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Estimated arrival: $_eta', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue))),
                    const SizedBox(height: 8),
                    Text('Ride ID: ${widget.rideId}'),
                    if (_currentStatus == "COMPLETED") ...[
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false), child: const Text('Book Another Ride'))
                    ]
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}