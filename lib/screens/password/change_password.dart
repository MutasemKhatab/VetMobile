import 'package:flutter/material.dart';
import 'package:vet/services/auth/change_password_service.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/api_response_handler.dart';
import 'package:vet/utils/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await ServiceProvider.changePasswordService
          .changePassword(ChangePasswordRequest(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text));

      if (response.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('password_changed_successfully'))),
        );
        Navigator.pop(context);
      } else {
        // Handle error from the service response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ApiResponseHandler.handleException(
        context: context,
        exception: e,
        prefix: context.tr('failed_to_change_password'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('change_password')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.tr('current_password'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.passwordValidator(value, context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.tr('new_password'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.passwordValidator(value, context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.tr('confirm_new_password'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return context.tr('passwords_do_not_match');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _changePassword,
                title: context.tr('change_password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
