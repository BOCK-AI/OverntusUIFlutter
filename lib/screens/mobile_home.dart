import 'package:flutter/material.dart';
import '../api/api_service.dart'; // Import ApiService

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});
  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
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
      appBar: AppBar(title: const Text("Home")),
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
          return Center(child: Text("Hi, $userName"));
        },
      ),
    );
  }
}