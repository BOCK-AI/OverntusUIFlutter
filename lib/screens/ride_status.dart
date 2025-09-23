// lib/screens/ride_status.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_service.dart';

class RideStatus extends StatefulWidget {
  final int rideId;
  const RideStatus({super.key, required this.rideId});

  @override
  State<RideStatus> createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  final ApiService _apiService = ApiService();
  String _statusMessage = "Searching for a rider...";
  String _currentStatus = "SEARCHING_FOR_RIDER";
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _initialCameraPosition = const LatLng(12.9716, 77.5946);

  @override
  void initState() {
    super.initState();
    _setupWebSocketListeners();
  }

  // --- THIS IS THE CORRECTED FUNCTION ---
  void _setupWebSocketListeners() {
    
    // It now correctly calls the two-parameter function
    _apiService.listenToRideUpdates(widget.rideId, (data) {
      final newStatus = data['status'];
      final riderId = data['riderId'];
      if (mounted) {
        setState(() {
          _currentStatus = newStatus;
          switch (newStatus) {
            case 'ACCEPTED': _statusMessage = "Rider #$riderId is on the way!"; break;
            case 'PICKED_UP': _statusMessage = "You're on your way!"; break;
            case 'COMPLETED': _statusMessage = "Ride Completed. Thank you!"; break;
          }
        });
      }
    });

    _apiService.listenToRideUpdates(widget.rideId, (data) {
      if (mounted && data['lat'] != null && data['lng'] != null) {
        final riderPosition = LatLng(data['lat'], data['lng']);
        final riderMarker = Marker(
          markerId: const MarkerId('riderLocation'),
          position: riderPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Your Rider'),
        );
        setState(() => _markers.add(riderMarker));
        _mapController.animateCamera(CameraUpdate.newLatLng(riderPosition));
      }
    });
  }

  @override
  void dispose() {
    _apiService.stopListeningToRideUpdates(widget.rideId);
    super.dispose();
  }
  // --- END CORRECTION ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Status')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 14),
            markers: _markers,
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
                    const SizedBox(height: 8),
                    Text('Ride ID: ${widget.rideId}'),
                    if (_currentStatus == "COMPLETED") ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                        child: const Text('Book Another Ride'),
                      )
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