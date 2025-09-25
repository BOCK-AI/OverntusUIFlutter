import 'package:flutter/material.dart';

class RecoveryPhonePage extends StatefulWidget {
  final String initialPhone;

  const RecoveryPhonePage(this.initialPhone, {super.key});

  @override
  State<RecoveryPhonePage> createState() => _RecoveryPhonePageState();
}

class _RecoveryPhonePageState extends State<RecoveryPhonePage> {
  late TextEditingController phoneController;
  String countryCode = '+91'; // Indian country code

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery phone'),
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
            const Text(
              'You’ll use this number to recover your account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Phone number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Implement country code picker (e.g., with a package)
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇮🇳', style: TextStyle(fontSize: 24)), // Indian flag emoji
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, size: 24, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefixText: countryCode,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'A verification code will be sent to this number',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Handle updating recovery phone here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.black,
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
