import 'package:flutter/material.dart';
import 'package:vet/screens/login/login_box.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
 
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Image.asset(
              'assets/images/logo.png',
              width: size.width * 0.4,
            ),
            SizedBox(height: size.height * 0.1),
            LoginBox()
          ],
        ),
      ),
    );
  }
}
