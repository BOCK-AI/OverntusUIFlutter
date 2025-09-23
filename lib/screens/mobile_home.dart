 import 'package:flutter/material.dart';
//import '../widgets/site_common.dart';

class MobileHome extends StatefulWidget {
  final String userName;
  const MobileHome({super.key, required this.userName});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final _pickup = TextEditingController();
  final _drop = TextEditingController();
  String _rideType = 'Go Sedan';
  String _payment = 'Cash';

  @override
  void dispose() {
    _pickup.dispose();
    _drop.dispose();
    super.dispose();
  }

  void _book() {
    if (_pickup.text.trim().isEmpty || _drop.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter pickup and destination')),
      );
      return;
    }
    Navigator.pushNamed(context, '/ride-status');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Orventus",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map placeholder background
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text("Map Placeholder",
                  style: TextStyle(color: Colors.black54)),
            ),
          ),

          // Bottom booking panel (like Uber)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Hi, ${widget.userName}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pickup field
                  TextField(
                    controller: _pickup,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.my_location),
                      hintText: 'Enter pickup location',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Destination field
                  TextField(
                    controller: _drop,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      hintText: 'Enter destination',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ride type chips with icons
                  Wrap(
                    spacing: 8,
                    children: [
                      _RideChip(
                        label: "Go Sedan",
                        icon: Icons.local_taxi,
                        selected: _rideType == 'Go Sedan',
                        onTap: () => setState(() => _rideType = 'Go Sedan'),
                      ),
                      _RideChip(
                        label: "XL",
                        icon: Icons.airport_shuttle,
                        selected: _rideType == 'XL',
                        onTap: () => setState(() => _rideType = 'XL'),
                      ),
                      _RideChip(
                        label: "Premier",
                        icon: Icons.car_rental,
                        selected: _rideType == 'Premier',
                        onTap: () => setState(() => _rideType = 'Premier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _payment = 'Cash'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _payment == 'Cash'
                                ? Colors.black
                                : Colors.grey,
                            side: BorderSide(
                                color: _payment == 'Cash'
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                          icon: const Icon(Icons.money),
                          label: const Text("Cash"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _payment = 'UPI'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _payment == 'UPI'
                                ? Colors.black
                                : Colors.grey,
                            side: BorderSide(
                                color: _payment == 'UPI'
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                          icon: const Icon(Icons.account_balance_wallet),
                          label: const Text("UPI"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Book Ride Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _book,
                      child: const Text(
                        'Confirm Ride',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RideChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: selected,
      selectedColor: Colors.black,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) => onTap(),
    );
  }
}

