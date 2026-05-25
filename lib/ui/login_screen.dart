import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../components/primary_button.dart';
import '../utils/validators.dart';
import 'registration_screen.dart';
import 'search_screen.dart';

//login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text('Welcome to Inmate Connect', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Login with your mobile and password', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(controller: _mobileCtrl, label: 'Mobile No', keyboardType: TextInputType.phone, validator: Validators.validatePakMobile),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _passwordCtrl,
                            label: 'Password',
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password required';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(text: 'Login', onPressed: _continue),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen())), child: const Text('Register')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
