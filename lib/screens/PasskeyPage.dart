import 'package:flutter/material.dart';

class PasskeyPage extends StatelessWidget {
  const PasskeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passkeys'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.black,
                child: const Icon(Icons.person_pin, size: 46, color: Colors.white),
              ),
            ),
            const SizedBox(height: 36),
            const Text(
              'Create a passkey',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(height: 16),
            const Text(
              'Passkeys are easier and more secure than passwords.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'With passkeys, you can log in to Orventus with:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Face Unlock'),
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Fingerprint Unlock'),
            ),
            ListTile(
              leading: const Icon(Icons.pin),
              title: const Text('Device pin or pattern'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle create passkey logic here
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Create passkey'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not now'),
            ),
          ],
        ),
      ),
    );
  }
}
