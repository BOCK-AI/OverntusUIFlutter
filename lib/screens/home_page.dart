import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';
import '../widgets/rider_dashboard_view.dart';
import '../widgets/ride_options_dialog.dart';

// Changed to StatefulWidget
class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  // --- STATE MANAGEMENT & CONTROLLERS ---
  final ApiService _apiService = ApiService();
  String? _accessToken;
  String? _userRole;
  bool _isLoading = true;
  bool _isFetchingEstimates = false;
  final _pickup = TextEditingController();
  final _dropoff = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _pickup.dispose();
    _dropoff.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  Future<void> _checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');
    final role = await storage.read(key: 'userRole');
    if (mounted) {
      setState(() {
        _accessToken = token;
        _userRole = role;
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth_check', (route) => false);
    }
  }

  void _handleSeePrices() async {
    if (_accessToken == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }
    if (_pickup.text.trim().isEmpty || _dropoff.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter pickup and dropoff locations.'), backgroundColor: Colors.red));
      return;
    }
    setState(() { _isFetchingEstimates = true; });
    try {
      final estimates = await _apiService.getRideEstimates(_pickup.text, _dropoff.text);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => RideOptionsDialog(
          estimates: estimates,
          onRideSelected: (selectedEstimate) {
            _handleCreateRide(selectedEstimate);
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() { _isFetchingEstimates = false; });
      }
    }
  }

  void _handleCreateRide(Map<String, dynamic> selectedEstimate) async {
    try {
      final result = await _apiService.createRide(
        _pickup.text,
        _dropoff.text,
        selectedEstimate['vehicle'],
        (selectedEstimate['fare'] as num).toDouble(),
      );
      final newRide = result['ride'];
      final int newRideId = newRide['id'];
      if (!mounted) return;
      Navigator.of(context).pushNamed('/ride_status', arguments: {'rideId': newRideId});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  // --- ORIGINAL UI HELPER METHODS ---

  double _maxBodyWidth(BoxConstraints c) => c.maxWidth.clamp(320.0, 1280.0);
  Widget _spacerH(double h) => SizedBox(height: h);

  Widget _pillButton({
    required String label,
    required VoidCallback onTap,
    Color? bg,
    Color? fg,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg ?? const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: fg ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: padding,
        elevation: 0,
        textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(label),
    );
  }

  InputDecoration _searchDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none
      ),
    );
  }

  Widget _imagePlaceholder({double? height, BorderRadius? radius}) {
    return Container(
      height: height ?? 320,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: radius ?? BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: const Text('TODO: Add Image', style: TextStyle(color: Colors.black54)),
    );
  }

  Widget _suggestionCard({
    required String title,
    required String subtitle,
    VoidCallback? onDetails,
  }) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.35)),
                const SizedBox(height: 16),
                _pillButton(
                  label: 'Details',
                  onTap: onDetails ?? () => Navigator.pushNamed(context, '/login'),
                  bg: Colors.white,
                  fg: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _imagePlaceholder(height: 120, radius: BorderRadius.circular(14))),
        ],
      ),
    );
  }

  Widget _imageTextSection({
    required bool imageLeft,
    required String title,
    required String subtitle,
    required String cta,
    VoidCallback? onCta,
    String? secondaryLinkText,
    VoidCallback? onSecondary,
  }) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = _maxBodyWidth(c);
        return Center(
          child: Container(
            width: w,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageLeft) Expanded(child: _imagePlaceholder(height: 420)),
                if (imageLeft) const SizedBox(width: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.15)),
                        const SizedBox(height: 14),
                        Text(subtitle, style: TextStyle(fontSize: 18, color: Colors.grey.shade800, height: 1.4)),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            _pillButton(label: cta, onTap: onCta ?? () => Navigator.pushNamed(context, '/login')),
                            if (secondaryLinkText != null) ...[
                              const SizedBox(width: 22),
                              TextButton(
                                onPressed: onSecondary ?? () => Navigator.pushNamed(context, '/login'),
                                style: TextButton.styleFrom(foregroundColor: Colors.black, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(secondaryLinkText),
                                    const SizedBox(width: 8),
                                    Container(height: 1, width: 80, color: Colors.black.withOpacity(0.25)),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!imageLeft) const SizedBox(width: 40),
                if (!imageLeft) Expanded(child: _imagePlaceholder(height: 420)),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _benefitRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
      ],
    );
  }

  Widget _benefitDivider() => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Colors.black12));

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final bool isLoggedIn = _accessToken != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildTopNav(context, isLoggedIn), // Using a helper for the AppBar
      body: SingleChildScrollView(
        child: (isLoggedIn && _userRole == 'rider')
            ? const RiderDashboardView()
            : _buildCustomerView(context, isLoggedIn),
      ),
    );
  }

  // --- DYNAMIC APPBAR HELPER ---
  AppBar _buildTopNav(BuildContext context, bool isLoggedIn) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Orventus', style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.w800)),
      ),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Ride', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: const Text('Drive', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: const Text('Business', style: TextStyle(color: Colors.white))),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18), label: const Text('About'), style: TextButton.styleFrom(foregroundColor: Colors.white)),
        const Spacer(),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.public, color: Colors.white, size: 16), label: const Text('EN'), style: TextButton.styleFrom(foregroundColor: Colors.white)),
        TextButton(onPressed: () {}, child: const Text('Help', style: TextStyle(color: Colors.white))),
        if (isLoggedIn) ...[
          if (_userRole == 'rider')
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/available_rides'),
              child: const Text('View Available Rides', style: TextStyle(color: Colors.amber)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/dashboard'),
            child: const Text('My Profile', style: TextStyle(color: Colors.white)),
          ),
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _logout, tooltip: 'Log Out'),
        ] else ...[
          TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Log In', style: TextStyle(color: Colors.white))),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
              child: const Text('Sign up'),
            ),
          ),
        ],
        const SizedBox(width: 16),
      ],
    );
  }

  // --- CUSTOMER VIEW HELPER ---
  Widget _buildCustomerView(BuildContext context, bool isLoggedIn) {
    return Column(
      children: [
        // HERO
        LayoutBuilder(builder: (context, c) {
          final w = _maxBodyWidth(c);
          return Center(
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _spacerH(56),
                  const Text('Travel with Orventus', textAlign: TextAlign.center, style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, height: 1.1)),
                  _spacerH(32),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _pickup, decoration: _searchDecoration(hint: 'Pickup location', icon: Icons.radio_button_checked))),
                      const SizedBox(width: 14),
                      Expanded(child: TextField(controller: _dropoff, decoration: _searchDecoration(hint: 'Dropoff location', icon: Icons.stop_circle_outlined))),
                      const SizedBox(width: 14),
                      _pillButton(
                        label: 'See prices',
                        onTap: _handleSeePrices,
                        isLoading: _isFetchingEstimates,
                      ),
                    ],
                  ),
                  _spacerH(80),
                  if (!isLoggedIn)
                    Container(
                      width: 560,
                      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text('Log in to see your recent activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                          _pillButton(label: 'Log in', onTap: () => Navigator.pushNamed(context, '/login')),
                        ],
                      ),
                    ),
                  _spacerH(56),
                ],
              ),
            ),
          );
        }),

        // SUGGESTIONS GRID
        LayoutBuilder(builder: (context, c) {
          final w = _maxBodyWidth(c);
          final isWide = c.maxWidth >= 1100;
          final cross = isWide ? 3 : 2;
          return Center(
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Suggestions', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 22),
                  GridView.count(
                    crossAxisCount: cross,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _suggestionCard(title: 'Ride', subtitle: 'Go anywhere with Orventus. Request a ride, hop in, and go.', onDetails: () => Navigator.pushNamed(context, '/login')),
                      _suggestionCard(title: 'Reserve', subtitle: 'Reserve your ride in advance so you can relax on the day of your trip.', onDetails: () => Navigator.pushNamed(context, '/login')),
                      _suggestionCard(title: 'Intercity', subtitle: 'Get convenient, affordable outstation cabs anytime at your door.', onDetails: () => Navigator.pushNamed(context, '/login')),
                      _suggestionCard(title: 'Shuttle', subtitle: 'Lower-cost shared rides on professionally driven buses and vans.', onDetails: () => Navigator.pushNamed(context, '/login')),
                      _suggestionCard(title: 'Courier', subtitle: 'Same-day item delivery made easy with Orventus.', onDetails: () => Navigator.pushNamed(context, '/login')),
                      _suggestionCard(title: 'Rentals', subtitle: 'Request a trip for a block of time and make multiple stops.', onDetails: () => Navigator.pushNamed(context, '/login')),
                    ],
                  ),
                  _spacerH(40),
                ],
              ),
            ),
          );
        }),

        // ACCOUNT DETAILS SECTION
        if (!isLoggedIn)
          LayoutBuilder(builder: (context, c) {
            final w = _maxBodyWidth(c);
            return Center(
              child: Container(
                width: w,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Log in to see your account details', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 14),
                            Text('View past trips, tailored suggestions, support resources, and more.', style: TextStyle(fontSize: 18, color: Colors.grey.shade800)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _pillButton(label: 'Log in to your account', onTap: () => Navigator.pushNamed(context, '/login')),
                                const SizedBox(width: 18),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, '/login'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Create an account'),
                                      const SizedBox(width: 8),
                                      Container(height: 1, width: 110, color: Colors.black.withOpacity(0.3)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 28),
                      Expanded(child: _imagePlaceholder(height: 360)),
                    ],
                  ),
                ),
              ),
            );
          }),

        _spacerH(28),

        // RESERVE SECTION
        LayoutBuilder(builder: (context, c) {
          final w = _maxBodyWidth(c);
          return Center(
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFFD0EBF0), borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Get your ride right with Orventus Reserve', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 22),
                          const Text('Choose date and time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: TextField(readOnly: true, decoration: InputDecoration(prefixIcon: const Icon(Icons.calendar_today), hintText: 'Date', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
                              const SizedBox(width: 12),
                              Expanded(child: TextField(readOnly: true, decoration: InputDecoration(prefixIcon: const Icon(Icons.access_time), hintText: 'Time', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _pillButton(label: 'Next', onTap: () => Navigator.pushNamed(context, '/login')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black12)),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Benefits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 14),
                          _benefitRow(Icons.event_available, 'Choose your exact pickup time up to 90 days in advance.'),
                          _benefitDivider(),
                          _benefitRow(Icons.schedule, 'Extra wait time included to meet your ride.'),
                          _benefitDivider(),
                          _benefitRow(Icons.horizontal_rule, 'Cancel at no charge up to 60 minutes in advance.'),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(foregroundColor: Colors.black87),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('See terms'),
                                const SizedBox(width: 8),
                                Container(height: 1, width: 70, color: Colors.black.withOpacity(0.25)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        _spacerH(24),

        _imageTextSection(imageLeft: true, title: 'Drive when you want, make what you need', subtitle: 'Make money on your schedule with deliveries or rides—or both. You can use your own car or choose a rental through Orventus.', cta: 'Get started', onCta: () => Navigator.pushNamed(context, '/login'), secondaryLinkText: 'Already have an account? Sign in', onSecondary: () => Navigator.pushNamed(context, '/login')),
        _imageTextSection(imageLeft: false, title: 'The Orventus you know, reimagined for business', subtitle: 'Orventus for Business is a platform for managing global rides and meals, and local deliveries, for companies of any size.', cta: 'Get started', onCta: () => Navigator.pushNamed(context, '/login'), secondaryLinkText: 'Check out our solutions', onSecondary: () {}),
        _imageTextSection(imageLeft: true, title: 'Make money by renting out your car', subtitle: 'Connect with thousands of drivers and earn more per week with Orventus fleet management tools.', cta: 'Get started', onCta: () => Navigator.pushNamed(context, '/login')),
        _spacerH(40),

        // FOOTER
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: LayoutBuilder(builder: (context, c) {
            final w = _maxBodyWidth(c);
            return Center(
              child: Container(
                width: w,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Orventus', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 18),
                    const Wrap(spacing: 32, runSpacing: 12, children: [_FooterLink('About'), _FooterLink('Help'), _FooterLink('Careers'), _FooterLink('Privacy'), _FooterLink('Terms')]),
                    const SizedBox(height: 20),
                    const Text('© 2025 Orventus. All rights reserved.', style: TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500));
  }
}