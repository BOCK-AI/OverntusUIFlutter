import 'package:flutter/material.dart';

class MobileActivity extends StatelessWidget {
  const MobileActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final past = [
      {
        'title': 'Mall to Home',
        'date': '27 Jul · 12:28 pm',
        'price': '₹0.00',
        'status': 'Cancelled',
      },
      {
        'title': 'Park to Office',
        'date': '22 Jul · 1:54 pm',
        'price': '₹57.20',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Upcoming',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('You have no upcoming trips'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Reserve'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Past',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...past
              .map(
                (p) => Card(
                  child: ListTile(
                    title: Text(p['title']!),
                    subtitle: Text(
                      '${p['date']} · ${p['price']} · ${p['status']}',
                    ),
                    trailing: TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Rebook ${p['title']}')),
                      ),
                      child: const Text('Rebook'),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
