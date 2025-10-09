import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          case '/auth_check': return MaterialPageRoute(builder: (_) => const AuthCheckPage());
          case '/': return MaterialPageRoute(builder: (_) => const HomePage());
          case '/login': return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/dashboard': return MaterialPageRoute(builder: (_) => kIsWeb ? const DashboardWeb() : const DashboardMobile());
          case '/profile': return MaterialPageRoute(builder: (_) => const ProfilePage());
          case '/available_rides': return MaterialPageRoute(builder: (_) => const AvailableRidesPage());
          case '/ride_status':
            if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              final rideId = args['rideId'] as int;
              final pickupLocation = args['pickupLocation'] as LatLng;
              final dropoffLocation = args['dropoffLocation'] as LatLng; // <-- Get the new argument

              return MaterialPageRoute(
                builder: (_) => RideStatus(
                  rideId: rideId,
                  pickupLocation: pickupLocation,
                  dropoffLocation: dropoffLocation, // <-- Pass it to the widget
      ),
    );            }
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Error: Ride Data missing'))));
          default: return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('404: Page Not Found'))));
        }
      },
    );
  }
}