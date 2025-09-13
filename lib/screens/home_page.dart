import 'package:flutter/material.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final _pickup = TextEditingController();
  final _dropoff = TextEditingController();

  @override
  void dispose() {
    _pickup.dispose();
    _dropoff.dispose();
    super.dispose();
  }

  // --- Helpers --------------------------------------------------------------

  double _maxBodyWidth(BoxConstraints c) => c.maxWidth.clamp(320.0, 1280.0);

  Widget _spacerH(double h) => SizedBox(height: h);

  Widget _pillButton({
    required String label,
    required VoidCallback onTap,
    Color? bg,
    Color? fg,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg ?? const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: fg ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: padding,
        elevation: 0,
        textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(label),
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
        borderSide: BorderSide.none,
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
      child: const Text(
        'TODO: Add Image (see notes below)',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  // Suggestion card as in screenshot (text left, illustration right)
  Widget _suggestionCard({
    required String title,
    required String subtitle,
    VoidCallback? onDetails,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          // Left: text
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    )),
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
          // Right: image placeholder
          Expanded(
            flex: 2,
            child: _imagePlaceholder(height: 120, radius: BorderRadius.circular(14)),
          ),
        ],
      ),
    );
  }

  // Alternating big sections (image/text)
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
                        Text(title,
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w800, height: 1.15)),
                        const SizedBox(height: 14),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade800, height: 1.4),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            _pillButton(
                              label: cta,
                              onTap: onCta ?? () => Navigator.pushNamed(context, '/login'),
                              // keep black like screenshot
                            ),
                            if (secondaryLinkText != null) ...[
                              const SizedBox(width: 22),
                              TextButton(
                                onPressed: onSecondary ?? () => Navigator.pushNamed(context, '/login'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(secondaryLinkText),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 1,
                                      width: 80,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
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

  // --- Build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary; // your 0xFFf97316

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _TopNav(onLogin: () => Navigator.pushNamed(context, '/login')),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                            const Text(
                              'Ride Autonomously with Orventus',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            _spacerH(20),
                            const Text(
                              'India’s first Autonomous Driver built using Bock AVT.\n Safer, more accessible, and more sustainable rides — with no one in the driver’s seat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35),
                            ),
                            _spacerH(32),

                            // search bar row
                            Row(
                              children: [
                                // pickup
                                Expanded(
                                  child: TextField(
                                    controller: _pickup,
                                    decoration: _searchDecoration(
                                      hint: 'Pickup location',
                                      icon: Icons.radio_button_checked,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // dropoff
                                Expanded(
                                  child: TextField(
                                    controller: _dropoff,
                                    decoration: _searchDecoration(
                                      hint: 'Dropoff location',
                                      icon: Icons.stop_circle_outlined,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                _pillButton(
                                  label: 'Try Autonomous Ride',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/login',
                                      arguments: {
                                        'pickup': _pickup.text,
                                        'dropoff': _dropoff.text,
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),

                            _spacerH(80),

                            // small login CTA card
                            Container(
                              width: 560,
                              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Log in to see your autonomous ride history',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _pillButton(
                                    label: 'Log in',
                                    onTap: () => Navigator.pushNamed(context, '/login'),
                                  ),
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
                            const Text('Suggestions',
                                style: TextStyle(
                                    fontSize: 44, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 22),
                            GridView.count(
                              crossAxisCount: cross,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _suggestionCard(
                                  title: 'Autonomous Ride',
                                  subtitle:
                                      'Go anywhere with Bock AVT. Request an autonomous ride and experience true freedom.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                                _suggestionCard(
                                  title: 'Reserve',
                                  subtitle:
                                      'Reserve an autonomous ride in advance — relax knowing your vehicle will arrive precisely when you need.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                                _suggestionCard(
                                  title: 'Intercity',
                                  subtitle:
                                      'Convenient, affordable outstation autonomous vehicles for long-distance journeys.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                                _suggestionCard(
                                  title: 'Shuttle',
                                  subtitle:
                                      'Shared autonomous shuttles for efficient, lower-cost travel.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                                _suggestionCard(
                                  title: 'Courier',
                                  subtitle:
                                      'Same-day delivery powered by Bock AVT’s autonomous technology.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                                _suggestionCard(
                                  title: 'Fleet Rental',
                                  subtitle:
                                      'Book an autonomous vehicle by the hour and make multiple stops.',
                                  onDetails: () => Navigator.pushNamed(context, '/login'),
                                ),
                              ],
                            ),
                            _spacerH(40),
                          ],
                        ),
                      ),
                    );
                  }),

                  // ACCOUNT DETAILS SECTION
                  LayoutBuilder(builder: (context, c) {
                    final w = _maxBodyWidth(c);
                    return Center(
                      child: Container(
                        width: w,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Log in to manage your autonomous journeys',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'View past rides, tailored suggestions, and discover the benefits of driverless technology.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        _pillButton(
                                          label: 'Log in to your account',
                                          onTap: () => Navigator.pushNamed(context, '/login'),
                                        ),
                                        const SizedBox(width: 18),
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(context, '/login'),
                                          style: TextButton.styleFrom(foregroundColor: Colors.black),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Create an account'),
                                              const SizedBox(width: 8),
                                              Container(
                                                height: 1,
                                                width: 110,
                                                color: Colors.black.withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 28),
                              Expanded(
                                child: _imagePlaceholder(height: 360),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  _spacerH(28),

                  // RESERVE SECTION (Plan for later) - split
                  LayoutBuilder(builder: (context, c) {
                    final w = _maxBodyWidth(c);
                    return Center(
                      child: Container(
                        width: w,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left teal card
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD0EBF0),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Plan Ahead with Bock AVT Autonomous Reservation',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    const Text('Choose date and time',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.calendar_today),
                                              hintText: 'Date',
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: TextField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.access_time),
                                              hintText: 'Time',
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    _pillButton(
                                      label: 'Next',
                                      onTap: () => Navigator.pushNamed(context, '/login'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 22),
                            // Right benefits card
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.black12),
                                ),
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Benefits',
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 14),
                                    _benefitRow(Icons.event_available,
                                        'Choose your exact autonomous pickup time up to 90 days in advance.'),
                                    _benefitDivider(),
                                    _benefitRow(Icons.schedule,
                                        'Extra wait time included to seamlessly meet your autonomous vehicle.'),
                                    _benefitDivider(),
                                    _benefitRow(Icons.horizontal_rule,
                                        'Cancel at no charge up to 60 minutes in advance.'),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black87),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('See terms'),
                                          const SizedBox(width: 8),
                                          Container(
                                            height: 1,
                                            width: 70,
                                            color: Colors.black.withOpacity(0.25),
                                          ),
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

                  // Alternating hero-like sections
                  _imageTextSection(
                    imageLeft: true,
                    title: 'Experience Autonomous Freedom: Go Where You Want, When You Want',
                    subtitle:
                        'Bock AVT leverages next-gen AI to deliver safe, accessible trips for everyone. Our vehicles make driving concerns a thing of the past.',
                    cta: 'Get started',
                    onCta: () => Navigator.pushNamed(context, '/login',
                        arguments: {'isDriver': true}),
                    secondaryLinkText: 'Already have an account? Sign in',
                    onSecondary: () => Navigator.pushNamed(context, '/login'),
                  ),

                  _imageTextSection(
                    imageLeft: false,
                    title: 'Bock AVT for Business: Autonomous Mobility Management',
                    subtitle:
                        'Manage global autonomous rides and deliveries for your organization — seamless, safe, and sustainable.',
                    cta: 'Get started',
                    onCta: () => Navigator.pushNamed(context, '/login'),
                    secondaryLinkText: 'Check out our solutions',
                    onSecondary: () {},
                  ),

                  _imageTextSection(
                    imageLeft: true,
                    title: 'Earn with Autonomous Fleet Management',
                    subtitle:
                        'Connect your vehicles to our autonomous platform and maximize weekly earnings.',
                    cta: 'Get started',
                    onCta: () => Navigator.pushNamed(context, '/login'),
                  ),

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
                              Text('Bock AVT',
                                  style: TextStyle(
                                      color: primary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 32,
                                runSpacing: 12,
                                children: const [
                                  _FooterLink('About'),
                                  _FooterLink('Help'),
                                  _FooterLink('Careers'),
                                  _FooterLink('Privacy'),
                                  _FooterLink('Terms'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text('© 2025 Bock AVT. All rights reserved.',
                                  style: TextStyle(color: Colors.white60)),
                              const SizedBox(height: 24),
                              // Safety/Impact Footer info
                              Text(
                                '1.19 million deaths worldwide due to vehicle crashes each year\n'
                                'Bock AVT\'s autonomous vehicles demonstrate up to 88% fewer serious injury crashes than the average human driver.\n'
                                'Our mission: Be the world’s most trusted autonomous driver.',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _benefitDivider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: Colors.black12),
      );
}

// Top black nav like Uber
class _TopNav extends StatelessWidget {
  final VoidCallback onLogin;
  const _TopNav({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    Widget navBtn(String label, {VoidCallback? onTap, bool bold = false}) {
      return TextButton(
        onPressed: onTap ?? () {},
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        child: Text(label),
      );
    }

    return Container(
      height: 64,
      color: Colors.black,
      child: Center(
        child: LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth.clamp(320.0, 1280.0);
          return SizedBox(
            width: w,
            child: Row(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Bock AVT',
                    style: TextStyle(
                      color: primary, // brand accent
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                navBtn('Ride', onTap: onLogin),
                navBtn('Drive', onTap: onLogin),
                navBtn('Business', onTap: onLogin),

                // About Button -> Popup
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("About Bock AVT"),
                        content: const Text(
                            "Bock AVT (Autonomous Vehicle Technology) is the world’s most trusted autonomous mobility platform. "
                            "Our mission is to create safer, more sustainable, and more accessible rides by replacing the driver’s seat with advanced AI technology."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Close"),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                  label: const Text('About'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),

                const Spacer(),

                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.public, color: Colors.white, size: 16),
                  label: const Text('EN'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                ),

                // Help Button -> Popup
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Help & Support"),
                        content: const Text(
                            "Need assistance? Explore our FAQ, contact support, or report issues with autonomous rides—all right here."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Got it"),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Help",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                navBtn('Log in', onTap: onLogin),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 0,
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Sign up'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
