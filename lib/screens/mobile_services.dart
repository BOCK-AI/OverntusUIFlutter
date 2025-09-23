import 'package:flutter/material.dart';
import '../widgets/site_common.dart';

class MobileServices extends StatelessWidget {
  const MobileServices({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'title': 'Auto', 'icon': Icons.electric_rickshaw},
      {'title': 'Trip', 'icon': Icons.local_taxi},
      {'title': 'Reserve', 'icon': Icons.event},
      {'title': 'Rentals', 'icon': Icons.key},
      {'title': 'Intercity', 'icon': Icons.directions_car},
      {'title': 'Teens', 'icon': Icons.child_care},
      {'title': 'Transit', 'icon': Icons.train},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Section(
            title: 'Services offered by Orventus',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tiles
                  .map(
                    (t) => _ServiceTile(
                      label: t['title'] as String,
                      icon: t['icon'] as IconData,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ServiceTile({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected $label')),
        ),
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
