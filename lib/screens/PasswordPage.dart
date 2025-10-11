import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  bool get _canUpdate {
    final np = newPasswordController.text;
    final cp = confirmPasswordController.text;
    if (np.length < 8) return false;
    if (!RegExp(r'\d').hasMatch(np)) return false; // at least one digit
    if (!RegExp(r'\W').hasMatch(np)) return false; // at least one non-digit
    return np == cp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
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
              'Your password must be at least 8 characters long, and contain at least one digit and one non-digit character',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: newPasswordController,
              obscureText: !newPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(newPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => newPasswordVisible = !newPasswordVisible),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: !confirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm new password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _canUpdate ? () {
                // Handle password update logic here
                Navigator.pop(context);
              } : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
