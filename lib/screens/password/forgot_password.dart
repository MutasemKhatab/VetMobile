import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/api_response_handler.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/password/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"email": "${_emailController.text}"}',
      );

      final success = ApiResponseHandler.handleResponse(
        response: response,
        context: context,
        successMessage: 'Reset code sent to your email.',
      );

      if (success) {
        Navigator.pushNamed(context, '/verifyResetCode');
      }
    } catch (e) {
      ApiResponseHandler.handleException(
        context: context,
        exception: e,
        prefix: 'Failed to send reset code',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
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
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _sendResetCode,
                title: 'Send Reset Code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
