import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'search_screen.dart';

class OtpScreen extends StatefulWidget {
  final dynamic user;
  const OtpScreen({super.key, this.user});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _digits = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < 4; i++) {
      _digits[i].addListener(() => _handleDigitChange(i));
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _handleDigitChange(int index) {
    final text = _digits[index].text;
    if (text.length == 1) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _verify();
      }
    } else if (text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    for (var c in _digits) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _verify() {
    final code = _digits.map((c) => c.text).join();
    if (code.length == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 4-digit code')));
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
                    Text('OTP Verification', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    const Text('Enter 4-digit code sent to your mobile'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) {
                        return SizedBox(
                          width: 60,
                          child: TextField(
                            focusNode: _focusNodes[i],
                            controller: _digits[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: const InputDecoration(counterText: ''),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: _verify, child: const Text('Verify')),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _secondsLeft == 0 ? _startTimer : null,
                      child: Text(_secondsLeft == 0 ? 'Resend' : 'Resend in $_secondsLeft s'),
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
