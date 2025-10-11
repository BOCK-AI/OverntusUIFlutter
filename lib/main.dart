// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for teammate's theme

// Correctly import all pages using relative paths
import 'screens/auth_check_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_web.dart';
import 'screens/dashboard_mobile.dart';
import 'screens/home_page.dart';
import 'screens/ride_status.dart';
import 'screens/available_rides_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

// Renamed to MyApp for consistency
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orventus',
      
      // --- MERGED THEME DATA ---
      // We are using the better, modern theme from your teammate
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF97316)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // --- END MERGED THEME ---
      
      debugShowCheckedModeBanner: false,
      
      // --- YOUR SUPERIOR ROUTING LOGIC ---
      initialRoute: '/auth_check',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth_check':
            return MaterialPageRoute(builder: (_) => const AuthCheckPage());
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardWeb());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case '/available_rides':
            return MaterialPageRoute(builder: (_) => const AvailableRidesPage());
          case '/ride_status':
            if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              final rideId = args['rideId'] as int;
              final pickupLocation = args['pickupLocation'] as LatLng;
              final dropoffLocation = args['dropoffLocation'] as LatLng;
              return MaterialPageRoute(
                builder: (_) => RideStatus(
                  rideId: rideId,
                  pickupLocation: pickupLocation,
                  dropoffLocation: dropoffLocation,
                ),
              );
            }
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Error: Ride Data missing'))));
          default:
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('404: Page Not Found'))));
        }
      },
      // --- END YOUR ROUTING LOGIC ---
    );
  }
}