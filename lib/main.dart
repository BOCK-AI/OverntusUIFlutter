import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_web.dart';
import 'screens/dashboard_mobile.dart';
import 'screens/ride_status.dart';
import 'screens/driver_dashboard.dart';

void main() => runApp(const OrventusApp());

class OrventusApp extends StatelessWidget {
  const OrventusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFf97316),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

      final home = kIsWeb ? const HomePageWeb() : const LoginPage();

    return MaterialApp(
      title: 'Orventus',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: home,
      routes: {
        '/home': (c) => const HomePageWeb(),
      
        '/login': (c) => const LoginPage(),
        '/dashboard': (c) {
          final args = ModalRoute.of(c)?.settings.arguments as Map<String, dynamic>?;

          final String userType = (args?['userType'] ?? 'Rider') as String;
          final bool isDriver = (args?['isDriver'] ?? false) as bool;

          if (isDriver) return DriverDashboard(userType: userType);

          return kIsWeb
              ? DashboardWeb(userType: userType)
              : DashboardMobile(userType: userType);
        },
        '/ride-status': (c) => const RideStatus(rideId: 'demo-ride'),
      },
    );
  }
}