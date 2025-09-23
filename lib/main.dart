// lib/main.dart

import 'package:flutter/material.dart';
import 'package:orventus_web/screens/available_rides_page.dart';
import 'package:orventus_web/screens/ride_status.dart';
import 'screens/auth_check_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_web.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart'; // The new profile page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orventus',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth_check',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth_check':
            return MaterialPageRoute(builder: (_) => const AuthCheckPage());
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePageWeb());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());

          // --- THIS IS THE CORRECTED ROUTE ---
          case '/dashboard':
            // The /dashboard route now points to our new ProfilePage
            return MaterialPageRoute(builder: (_) => const DashboardWeb());
          // --- END CORRECTION ---
          case '/profile': return MaterialPageRoute(builder: (_) => const ProfilePage());
          
          case '/available_rides':
            return MaterialPageRoute(builder: (_) => const AvailableRidesPage());
            
          case '/ride_status':
            if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              final rideId = args['rideId'] as int;
              return MaterialPageRoute(builder: (_) => RideStatus(rideId:rideId ));
            }
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Error: Ride ID missing'))));

          default:
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('404: Page Not Found'))));
        }
      },
    );
  }
}