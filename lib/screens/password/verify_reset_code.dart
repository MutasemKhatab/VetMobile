import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/api_response_handler.dart';
import 'package:vet/main.dart';

class VerifyResetCode extends StatefulWidget {
  const VerifyResetCode({super.key});

  @override
  State<VerifyResetCode> createState() => _VerifyResetCodeState();
}

class _VerifyResetCodeState extends State<VerifyResetCode> {
  final _emailController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _verifyResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/password/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: '''
        {
          "email": "${_emailController.text}",
          "resetCode": "${_resetCodeController.text}",
          "newPassword": "${_newPasswordController.text}"
        }
        ''',
      );

      final success = ApiResponseHandler.handleResponse(
        response: response,
        context: context,
        successMessage: 'Password reset successfully.',
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ApiResponseHandler.handleException(
        context: context,
        exception: e,
        prefix: 'Failed to reset password',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Reset Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resetCodeController,
                decoration: const InputDecoration(
                  labelText: 'Reset Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reset code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _verifyResetCode,
                title: 'Reset Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
