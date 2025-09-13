import 'package:flutter/material.dart';
import '../widgets/site_common.dart';

class MobileAccount extends StatelessWidget {
  final String userName;
  final void Function(int i)? onTabSwitch;

  const MobileAccount({
    super.key,
    required this.userName,
    required this.onTabSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // This blocks the system back button
  onPopInvokedWithResult: (didPop, result) {
    // Do nothing, so back button is blocked
  },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (onTabSwitch != null) {
                onTabSwitch!(0); // Switch to Home tab
              } else {
                Navigator.of(context).pop(); // Default back navigation
              }
            },
          ),
        ),
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
