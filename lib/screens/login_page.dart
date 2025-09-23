// lib/screens/login_page.dart

import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'dart:convert'; // Needed for jsonDecode

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _apiService = ApiService();
  bool _showOtpScreen = false;
  bool _isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _userType = 'customer';

  final _otpFormKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleRequestOtp() async {
    if (!_loginFormKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      await _apiService.requestOtp(_nameController.text, _phoneController.text, _userType);
      if (!mounted) return;
      setState(() { _showOtpScreen = true; _isLoading = false; });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      setState(() { _isLoading = false; });
    }
  }

  void _handleVerifyOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      final responseData = await _apiService.verifyOtpAndLogin(
        _phoneController.text,
        _otpController.text,
      );
      if (!mounted) return;
      
      final userRole = responseData['user']['role'];
      if (userRole == 'rider') {
        Navigator.of(context).pushReplacementNamed('/available_rides');
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showOtpScreen ? _buildOtpForm() : _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Card(
      key: const ValueKey('loginForm'),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome to Orventus', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Mobile number'), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'Please enter your mobile number' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(value: _userType, items: const [DropdownMenuItem(value: 'customer', child: Text('Customer')), DropdownMenuItem(value: 'rider', child: Text('Rider'))], onChanged: (v) => setState(() => _userType = v ?? 'customer'), decoration: const InputDecoration(labelText: 'I am a')),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isLoading ? null : _handleRequestOtp, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Continue'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpForm() {
    return Card(
      key: const ValueKey('otpForm'),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _otpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Verify OTP', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('An OTP was sent to ${_phoneController.text}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextFormField(controller: _otpController, decoration: const InputDecoration(labelText: '4-Digit OTP'), keyboardType: TextInputType.number, maxLength: 4, validator: (v) => (v == null || v.length < 4) ? 'Enter a valid OTP' : null),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isLoading ? null : _handleVerifyOtp, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Verify and Log In'))),
              TextButton(onPressed: _isLoading ? null : () => setState(() => _showOtpScreen = false), child: const Text('Go Back')),
            ],
          ),
        ),
      ),
    );
  }
}