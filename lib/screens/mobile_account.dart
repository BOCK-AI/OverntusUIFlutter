import 'package:flutter/material.dart';
import '../widgets/site_common.dart';

class MobileAccount extends StatelessWidget {
  final String userName;
  const MobileAccount({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('★ 4.9'),
                ],
              ),
              const CircleAvatar(
                radius: 28,
                child: Icon(Icons.person),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: const [
              _QuickCard(icon: Icons.help, label: 'Help'),
              _QuickCard(icon: Icons.account_balance_wallet, label: 'Wallet'),
              _QuickCard(icon: Icons.history, label: 'Activity'),
            ],
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              title: Text('Invite friends'),
              subtitle: Text('Earn credits'),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: cardDecoration(context),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      );
}
