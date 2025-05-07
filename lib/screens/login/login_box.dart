import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/services/auth/login_service.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/app_localizations.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/custom_input_field.dart';
import 'package:vet/widgets/future_button.dart';

class LoginBox extends StatefulWidget {
  const LoginBox({super.key});

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final res = await ServiceProvider.loginService.login(
      LoginRequest(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
    if (res.success) {
      await _getUserInfo();
      await _getVets();
      _getVaccines4Vets();
      Navigator.pushReplacementNamed(context, AppRoutes.splash);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res.message)),
    );
  }

  Future<void> _getVaccines4Vets() async {
    final vetProvider = Provider.of<VetProvider>(context, listen: false);
    for (var vet in vetProvider.vets) {
      await Provider.of<VaccineProvider>(context, listen: false)
          .fetchVaccinesForVet(vet.id);
    }
  }

  Future<void> _getUserInfo() async {
    await Provider.of<VetOwnerProvider>(context, listen: false).fetchVetOwner();
  }

  Future<void> _getVets() async {
    await Provider.of<VetProvider>(context, listen: false).fetchVets();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              context.tr('login'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            CustomInputField(
              labelText: context.tr('email'),
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) => Validators.emailValidator(value, context),
            ),
            SizedBox(height: 20),
            CustomInputField(
              labelText: context.tr('password'),
              icon: Icons.lock,
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              validator: (value) => Validators.passwordValidator(value, context),
            ),
            SizedBox(height: 20),
            FutureButton(onTap: _submitForm, title: context.tr('login')),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: Text(context.tr('forgot_password')),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.tr('dont_have_account')),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: Text(context.tr('sign_up')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
