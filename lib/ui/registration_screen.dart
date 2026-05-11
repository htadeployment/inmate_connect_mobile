import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../components/primary_button.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import 'otp_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _nameCtrl.dispose();
    _cnicCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = User(
        name: _nameCtrl.text.trim(),
        mobile: _mobileCtrl.text.trim(),
        cnic: _cnicCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Create account', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _mobileCtrl, label: 'Mobile No', keyboardType: TextInputType.phone, validator: Validators.validatePakMobile),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _nameCtrl, label: 'Full Name', validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _cnicCtrl, label: 'CNIC (13 digits)', keyboardType: TextInputType.number, validator: Validators.validateCNIC),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordCtrl,
                        label: 'Password',
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password required';
                          if (v.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(text: 'Register', onPressed: _submit),
                    ],
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
