import 'package:flutter/material.dart';
import 'common.dart';

class RideCards extends StatelessWidget {
  const RideCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Ride options',
      subtitle: 'Choose the ride that fits your needs',
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _RideCard(title: 'Orventus Go', description: 'Everyday rides at everyday prices.'),
            _RideCard(title: 'Orventus Premium', description: 'High-end cars for a little more comfort.'),
            _RideCard(title: 'Orventus XL', description: 'More room for groups up to 6.'),
          ],
        ),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final String title;
  final String description;
  const _RideCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.local_taxi, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 18),
          Row(
            children: [
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected $title'))),
                child: const Text('Request'),
              ),
              const SizedBox(width: 12),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('See details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
