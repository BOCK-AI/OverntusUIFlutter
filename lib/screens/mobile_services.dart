import 'package:flutter/material.dart';
import '../widgets/site_common.dart';

class MobileServices extends StatelessWidget {
  final void Function(int)? onTabSwitch;
  const MobileServices({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'title': 'AVT', 'icon': Icons.electric_rickshaw, 'desc': 'Autonomous Vehicle Technology: Autonomous vehicles rides for short distances.'},
      {'title': 'Trip', 'icon': Icons.local_taxi, 'desc': 'Book a taxi for your trip across the city.'},
      {'title': 'Reserve', 'icon': Icons.event, 'desc': 'Reserve a ride in advance for your planned events.'},
      {'title': 'Rentals', 'icon': Icons.key, 'desc': 'Rent vehicles for hours or days as per your need.'},
      {'title': 'Intercity', 'icon': Icons.directions_car, 'desc': 'Travel between cities with comfort and safety.'},
      {'title': 'Teens', 'icon': Icons.child_care, 'desc': 'Special rides and safety features for teenagers.'},
      {'title': 'Transit', 'icon': Icons.train, 'desc': 'Connect to public transit options for longer journeys.'},
    ];

    return PopScope(
      
      canPop: false, // This blocks the system back button
  onPopInvokedWithResult: (didPop, result) {
    // Do nothing, so back button is blocked
  },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Services'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (onTabSwitch != null) {
                onTabSwitch!(0); // Go to Home tab
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Section(
              title: 'Services',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: tiles
                    .map(
                      (t) => _ServiceTile(
                        label: t['title'] as String,
                        icon: t['icon'] as IconData,
                        description: t['desc'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;

  const _ServiceTile({required this.label, required this.icon, required this.description});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(label),
              content: Text(description),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: cardDecoration(context),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      );
}