// lib/widgets/ride_cards.dart

import 'package:flutter/material.dart';
import '../api/api_service.dart'; // Make sure this import is correct
import '../models/ride_model.dart'; // Make sure you have a RideModel

class RideStatus extends StatefulWidget {
  final RideModel ride;
  const RideStatus({super.key, required this.ride});

  @override
  State<RideStatus> createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  final ApiService _apiService = ApiService();
  late RideModel _currentRide;

  @override
  void initState() {
    super.initState();
    _currentRide = widget.ride;
    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    // Construct the full event name here
    final String eventName = 'ride-update-${_currentRide.id}';
    
    // Call the corrected function with the full event name
    _apiService.listenToRideUpdates(eventName, (data) {
      if (mounted) {
        setState(() {
          // Assuming the backend sends back the full ride object on update
          _currentRide = RideModel.fromJson(data); 
        });
      }
    });
  }

  @override
  void dispose() {
    // Construct the event name again to stop listening
    final String eventName = 'ride-update-${_currentRide.id}';
    _apiService.stopListeningToRideUpdates(eventName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is an example UI for a ride card.
    // You can customize it to match your app's design.
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Ride to: ${_currentRide.dropoffAddress}'),
        subtitle: Text('Status: ${_currentRide.status}'),
        trailing: Text('Fare: \$${_currentRide.fare.toStringAsFixed(2)}'),
      ),
    );
  }
}