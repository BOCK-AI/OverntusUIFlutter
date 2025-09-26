import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../api/api_service.dart';

class ActiveRidePage extends StatefulWidget {
  final int rideId;
  const ActiveRidePage({super.key, required this.rideId});

  @override
  State<ActiveRidePage> createState() => _ActiveRidePageState();
}

class _ActiveRidePageState extends State<ActiveRidePage> {
  final ApiService _apiService = ApiService();
  String _currentStatus = 'ACCEPTED';
  final Location _locationService = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _apiService.stopListeningToRideUpdates('ride-location-update-${widget.rideId}');
    super.dispose();
  }

  // --- THIS IS THE NEW FUNCTION ---
  void _startLocationTracking() {
    _apiService.connectSocket();
    _locationService.changeSettings(distanceFilter: 10); // Update every 10 meters

    _locationSubscription = _locationService.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        print('RIDER LOCATION SENDING: Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}');
        _apiService.sendRiderLocation(
          widget.rideId,
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      }
    });
  }
  
  // This function calls the backend to update the ride's status
  void _updateStatus(String newStatus) async {
    try {
      final result = await _apiService.updateRideStatus(widget.rideId, newStatus);
      final ride = result['ride'];
      if (mounted) {
        setState(() {
          _currentStatus = ride['status'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride status updated to $_currentStatus'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Ride #${widget.rideId}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current Status:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_currentStatus, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              
              // Conditionally show buttons based on the current status
              if (_currentStatus == 'ACCEPTED')
                ElevatedButton(
                  onPressed: () => _updateStatus('PICKED_UP'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Passenger Picked Up'),
                ),

              if (_currentStatus == 'PICKED_UP')
                ElevatedButton(
                  onPressed: () => _updateStatus('COMPLETED'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('Complete Ride'),
                ),
              
              if (_currentStatus == 'COMPLETED')
                Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 16),
                    const Text('Ride Completed!'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Go back to the available rides page to find another job
                        Navigator.of(context).pop();
                      },
                      child: const Text('Find Another Ride'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}