import 'package:flutter/material.dart';
import 'mobile_home.dart';
import 'mobile_services.dart';
import 'mobile_activity.dart';
import 'mobile_account.dart';
import 'mobile_car.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});
  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  int _idx = 0;
  void _switchTab(int i) => setState(() => _idx = i);

  @override
  Widget build(BuildContext context) {
    // Correctly initialize pages without parameters
    final pages = <Widget>[
      const MobileHome(),
      const MobileCar(),
      const MobileServices(),
      const MobileActivity(),
      const MobileAccount(),
    ];
    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.directions_car), label: 'Car'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Services'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Activity'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
        selectedIndex: _idx,
        onDestinationSelected: _switchTab,
      ),
    );
  }
}