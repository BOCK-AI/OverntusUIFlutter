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

  // --- THIS IS THE CORRECTED, UNIFIED LISTENER ---
  void _setupWebSocketListeners() {
    // We listen to the single 'ride-update' event
    _apiService.listenToRideUpdates('ride-update-${widget.rideId}', (data) {
      if (mounted) {
        final newStatus = data['status'];
        final riderId = data['riderId'];
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

    // We listen to the separate 'ride-location-update' event
    _apiService.listenToRideUpdates('ride-location-update-${widget.rideId}', (data) {
      if (mounted && data['lat'] != null && data['lng'] != null) {
        final riderPosition = LatLng(data['lat'], data['lng']);
        final riderMarker = Marker(
          markerId: const MarkerId('riderLocation'),
          position: riderPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
        setState(() => _markers.add(riderMarker));
        _mapController.animateCamera(CameraUpdate.newLatLng(riderPosition));
      }
    });
  }

  @override
  void dispose() {
    _apiService.stopListeningToRideUpdates('ride-update-${widget.rideId}');
    _apiService.stopListeningToRideUpdates('ride-location-update-${widget.rideId}');
    super.dispose();
  }
  
  


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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_statusMessage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
          )
        ],
      ),
    );
  }
}