import 'package:flutter/material.dart';
import 'accountdetailspage.dart';

class MobileAccount extends StatelessWidget {
  final String userName;
  final void Function(int i)? onTabSwitch;

  const MobileAccount({
    Key? key,
    required this.userName,
    required this.onTabSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Block system back button
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (onTabSwitch != null) {
                onTabSwitch!(0);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AccountDetailsPage(
                      userName: userName,
                      email: 'testuser@example.com', // Dummy email here
                      phoneNumber: '1234567890', // Dummy phone here
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                );
              },
            ),
          ],
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
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("4.9"),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
            Center(
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: 12,
    children: const [
      QuickCard(icon: Icons.help, label: "Help"),
      QuickCard(icon: Icons.account_balance_wallet, label: "Wallet"),
      QuickCard(icon: Icons.history, label: "Activity"),
    ],
  ),
),

            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                title: Text("Invite friends"),
                subtitle: Text("Earn credits"),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickCard({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        )
      ]),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
