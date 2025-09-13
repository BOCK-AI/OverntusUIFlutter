import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  String _role = 'Customer';
  late AnimationController _ani;

  @override
  void initState() {
    super.initState();
    _ani = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _ani.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Future.delayed(
        const Duration(milliseconds: 500),
        () => Navigator.of(context).pushReplacementNamed(
          '/dashboard',
          arguments: {
            'userType': _name.text,
            'isDriver': _role == 'Driver',
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _ani.drive(Tween(begin: 0.0, end: 1.0)),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome to Orventus',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                          ),
                          validator: (v) => (v == null || v.trim().length < 2)
                              ? 'Enter name'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _mobile,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().length < 7)
                              ? 'Enter mobile'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _role,
                          items: const [
                            DropdownMenuItem(
                              value: 'Customer',
                              child: Text('Customer'),
                            ),
                            DropdownMenuItem(
                              value: 'Driver',
                              child: Text('Driver'),
                            ),
                          ],
                          onChanged: (v) => setState(() => _role = v!),
                          decoration:
                              const InputDecoration(labelText: 'I am a'),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Continue'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
