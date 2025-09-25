import 'package:flutter/material.dart';
import '../widgets/site_common.dart';

class MobileServices extends StatelessWidget {
  final void Function(int)? onTabSwitch;
  const MobileServices({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    // Service tiles to match the screenshot, no Bike/Taxi
    // The order and names are tailored to the screen you provided
    final services = [
      {'label': 'AVT', 'icon': Icons.electric_rickshaw, 'desc': 'Autonomous Vehicle Technology: Autonomous vehicles rides for short distances.'},
      {'label': 'Reserve', 'icon': Icons.event, 'desc': 'Reserve a ride in advance for your planned events.'},
      {'label': 'Rentals', 'icon': Icons.key, 'desc': 'Rent vehicles for hours or days as per your need.'},
      {'label': 'Intercity', 'icon': Icons.directions_car, 'desc': 'Travel between cities with comfort and safety.'},
      {'label': 'Teens', 'icon': Icons.child_care, 'desc': 'Special rides and safety features for teenagers.'},
      {'label': 'Seniors', 'icon': Icons.elderly, 'desc': 'Convenient and safe rides for seniors.'},
      {'label': 'Transit', 'icon': Icons.train, 'desc': 'Connect to public transit options for longer journeys.'},
    ];

    final courier = [
      {'label': 'Courier', 'icon': Icons.delivery_dining, 'desc': 'Deliver packages to any address.'},
      {'label': 'Store pick-up', 'icon': Icons.local_grocery_store, 'desc': 'Get items picked up from stores and delivered.'},
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent default back
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Services'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (onTabSwitch != null) {
                onTabSwitch!(0);
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Go anywhere, get anything',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.12,
                children: services
                    .map(
                      (srv) => _ServiceTile(
                        label: srv['label'] as String,
                        icon: srv['icon'] as IconData,
                        description: srv['desc'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Text(
                'Get Courier to help',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: courier
                    .map(
                      (srv) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ServiceTile(
                            label: srv['label'] as String,
                            icon: srv['icon'] as IconData,
                            description: srv['desc'] as String,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 32),
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
          margin: EdgeInsets.zero,
          decoration: cardDecoration(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
}
