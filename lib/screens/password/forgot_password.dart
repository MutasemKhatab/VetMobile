import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/api_response_handler.dart';
import 'package:vet/utils/app_localizations.dart';

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
        successMessage: context.tr('reset_code_sent'),
      );

      if (success) {
        Navigator.pushNamed(context, '/verifyResetCode');
      }
    } catch (e) {
      ApiResponseHandler.handleException(
        context: context,
        exception: e,
        prefix: context.tr('failed_send_reset_code'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('forgot_password'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: context.tr('email'),
                  border: OutlineInputBorder(),
                ),
                validator: (email) => Validators.emailValidator(email, context),
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _sendResetCode,
                title: context.tr('send_reset_code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
