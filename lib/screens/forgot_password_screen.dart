import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _message = '';
  bool _isLoading = false;

  void requestReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      var url = Uri.parse('http://16.171.62.76:8081/api/forgot-password');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": _email.text}),
      );

      var res = json.decode(response.body);

      if (res['status'] == 'success') {
        setState(() {
          _message = res['message'] ?? 'OTP sent';
        });

        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(email: _email.text),
          ),
        );
      } else {
        setState(() {
          _message = res['message'] ?? res['error'] ?? 'Failed to send OTP';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Network error';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.directions_car, size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Reset your password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : requestReset,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Send OTP'),
                  ),
                  const SizedBox(height: 8),
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: TextStyle(
                        color: _message.toLowerCase().contains('success') ||
                                _message.toLowerCase().contains('sent')
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
