import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/api_response_handler.dart';
import 'package:vet/main.dart';
import 'package:vet/utils/app_localizations.dart';

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
        successMessage: context.tr('password_reset_successfully'),
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ApiResponseHandler.handleException(
        context: context,
        exception: e,
        prefix: context.tr('failed_to_reset_password'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('verify_reset_code'))),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_your_email');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resetCodeController,
                decoration: InputDecoration(
                  labelText: context.tr('reset_code'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_reset_code');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.tr('new_password'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_new_password');
                  }
                  if (value.length < 8) {
                    return context.tr('password_length_error');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _verifyResetCode,
                title: context.tr('reset_password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
