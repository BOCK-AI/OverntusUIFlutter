import 'package:flutter/material.dart';
import '../api/api_service.dart';

class MobileAccount extends StatefulWidget {
  const MobileAccount({super.key});
  @override
  State<MobileAccount> createState() => _MobileAccountState();
}

class _MobileAccountState extends State<MobileAccount> {
  final ApiService _apiService = ApiService();
  Future<Map<String, dynamic>>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _apiService.getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final userName = snapshot.data?['user']?['name'] ?? 'User';
          return ListView(
            children: [
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(userName),
                subtitle: const Text("View Profile"),
                onTap: () => Navigator.of(context).pushNamed('/profile'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log Out"),
                onTap: () async {
                  await _apiService.logout();
                  if (mounted) Navigator.of(context).pushReplacementNamed('/auth_check');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}