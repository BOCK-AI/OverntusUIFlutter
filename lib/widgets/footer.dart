import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_taxi, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Text('Orventus', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 32,
                runSpacing: 10,
                children: const [
                  _FooterLink('Safety'),
                  _FooterLink('Help'),
                  _FooterLink('Careers'),
                  _FooterLink('Developers'),
                  _FooterLink('Newsroom'),
                  _FooterLink('Privacy'),
                  _FooterLink('Terms'),
                  _FooterLink('Accessibility'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.facebook, color: Colors.white70),
                  const SizedBox(width: 12),
                  Icon(Icons.alternate_email, color: Colors.white70), // Twitter alt
                  const SizedBox(width: 12),
                  Icon(Icons.camera_alt, color: Colors.white70), // Instagram alt
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text('© 2025 Orventus', style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white70)),
    );
  }
}
