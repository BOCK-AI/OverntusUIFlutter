// lib/screens/available_rides_page.dart

import 'package:flutter/material.dart';
import '../api/api_service.dart';
import './active_ride_page.dart';

class AvailableRidesPage extends StatefulWidget {
  const AvailableRidesPage({super.key});

  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  // --- THIS IS THE CORRECTED STATE LOGIC ---
  late Future<List<dynamic>> _ridesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // The API call is now made ONLY ONCE when the page is first created.
    _ridesFuture = _apiService.getAvailableRides();
  }

  void _refreshRides() {
    // This function can be called to manually refresh the list
    setState(() {
      _ridesFuture = _apiService.getAvailableRides();
    });
  }

 void _acceptRide(int rideId) async {
    try {
      await _apiService.acceptRide(rideId);
      if (!mounted) return;

      // Instead of showing a SnackBar, we now navigate to the new page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ActiveRidePage(rideId: rideId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRides,
            tooltip: 'Refresh',
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ridesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No available rides found.'));
          }

          final rides = snapshot.data!;
          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('From: ${ride['pickupAddress']}'),
                  subtitle: Text('To: ${ride['dropAddress']}\nFare: \$${ride['fare']}'),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    onPressed: () => _acceptRide(ride['id']),
                    child: const Text('Accept'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}