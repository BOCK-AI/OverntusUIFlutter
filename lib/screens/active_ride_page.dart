import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../api/api_service.dart';
import 'dart:math';

class ActiveRidePage extends StatefulWidget {
  final int rideId;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  const ActiveRidePage({super.key, required this.rideId, required this.pickupLocation, required this.dropoffLocation});

  @override
  State<ActiveRidePage> createState() => _ActiveRidePageState();
}

class _ActiveRidePageState extends State<ActiveRidePage> {
  final ApiService _apiService = ApiService();
  String _currentStatus = 'ACCEPTED';
  String? _eta;
  final Location _locationService = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(markerId: const MarkerId('pickup'), position: widget.pickupLocation, infoWindow: const InfoWindow(title: 'Pickup')));
    _markers.add(Marker(markerId: const MarkerId('dropoff'), position: widget.dropoffLocation, infoWindow: const InfoWindow(title: 'Dropoff')));
    _startLocationTracking();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    _apiService.connectSocket();
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _locationService.requestService();
    if (!serviceEnabled) return;
    PermissionStatus permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    await _locationService.changeSettings(accuracy: LocationAccuracy.high, interval: 3000, distanceFilter: 5);
    final initialLocationData = await _locationService.getLocation();
    if (initialLocationData.latitude != null && initialLocationData.longitude != null) {
      final riderPos = LatLng(initialLocationData.latitude!, initialLocationData.longitude!);
      _drawRoute(riderPos, widget.pickupLocation);
    }
    _locationSubscription = _locationService.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        _apiService.sendRiderLocation(widget.rideId, currentLocation.latitude!, currentLocation.longitude!);
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
      final Polyline routePolyline = Polyline(polylineId: const PolylineId('rider_route'), color: Colors.blueAccent, width: 5, points: points);
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
    } catch (e) { print('Error drawing route for rider: $e'); }
  }

  void _updateStatus(String newStatus) async {
    try {
      final result = await _apiService.updateRideStatus(widget.rideId, newStatus);
      final ride = result['ride'];
      if (mounted) {
        setState(() { _currentStatus = ride['status']; });
        if (_currentStatus == 'PICKED_UP') {
          final currentLocationData = await _locationService.getLocation();
          if (currentLocationData.latitude != null && currentLocationData.longitude != null) {
            final riderPosition = LatLng(currentLocationData.latitude!, currentLocationData.longitude!);
            _drawRoute(riderPosition, widget.dropoffLocation);
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Active Ride #${widget.rideId}')),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Current Status: $_currentStatus', style: Theme.of(context).textTheme.titleLarge),
                    if (_eta != null) 
                      Text('ETA to destination: $_eta', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 16),
                    if (_currentStatus == 'ACCEPTED')
                      ElevatedButton(onPressed: () => _updateStatus('PICKED_UP'), child: const Text('Passenger Picked Up')),
                    if (_currentStatus == 'PICKED_UP')
                      ElevatedButton(onPressed: () => _updateStatus('COMPLETED'), child: const Text('Complete Ride')),
                    if (_currentStatus == 'COMPLETED')
                      ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Find Another Ride')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}