// lib/widgets/rider_dashboard_view.dart

import 'package:flutter/material.dart';

class RiderDashboardView extends StatelessWidget {
  const RiderDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.drive_eta, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Ready to Drive?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find available rides in your area and start earning.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Find Available Rides'),
              onPressed: () {
                // This navigates to the page that shows the list of available rides
                Navigator.of(context).pushNamed('/available_rides');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}