import 'package:flutter/material.dart';
import 'common.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Anchor(
      id: 'ride',
      child: Container(
        color: const Color(0xFF000000),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Go anywhere with Orventus', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      const Text('Request a ride, hop in, and relax.', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 20),
                      _PickupForm(),
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 24),
                if (isWide)
                  Expanded(
                    child: Container(
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Center(child: Icon(Icons.map_outlined, color: Colors.white70, size: 72)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickupForm extends StatefulWidget {
  const _PickupForm();

  @override
  State<_PickupForm> createState() => _PickupFormState();
}

class _PickupFormState extends State<_PickupForm> {
  final _pickup = TextEditingController();
  final _drop = TextEditingController();

  @override
  void dispose() {
    _pickup.dispose();
    _drop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
      ),
      child: Column(
        children: [
          TextField(
            controller: _pickup,
            decoration: const InputDecoration(
              labelText: 'Pickup location',
              prefixIcon: Icon(Icons.my_location, color: Colors.black),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _drop,
            decoration: const InputDecoration(
              labelText: 'Destination',
              prefixIcon: Icon(Icons.place_outlined, color: Colors.black),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  onPressed: () => showInfoDialog(context, 'Fare estimate',
                      'Estimated fare for route: ${_pickup.text} → ${_drop.text} (demo only).'),
                  child: const Text('See prices'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Log in to ride'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
