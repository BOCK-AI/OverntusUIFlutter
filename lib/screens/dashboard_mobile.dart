import 'package:flutter/material.dart';
import 'mobile_home.dart';
import 'mobile_services.dart';
import 'mobile_activity.dart';
import 'mobile_account.dart';

class DashboardMobile extends StatefulWidget {
  final String userType;
  const DashboardMobile({super.key, required this.userType});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  int _idx = 0;

  void _switchTab(int i) {
    setState(() => _idx = i);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MobileHome(userName: widget.userType, onTabSwitch: _switchTab),
      MobileServices(onTabSwitch: _switchTab),
      MobileActivity(onTabSwitch: _switchTab),
      MobileAccount(userName: widget.userType, onTabSwitch: _switchTab),
    ];

    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        selectedIndex: _idx,
        onDestinationSelected: _switchTab,
      ),
    );
  }
}
