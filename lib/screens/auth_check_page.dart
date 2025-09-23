// lib/screens/auth_check_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});
  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuthStatus());
  }

  // --- THIS IS THE CORRECTED FUNCTION ---
  Future<void> _checkAuthStatus() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final userRole = await storage.read(key: 'userRole');

    if (mounted) {
      if (accessToken != null) {
        if (userRole == 'rider') {
          Navigator.of(context).pushReplacementNamed('/available_rides');
        } else {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}