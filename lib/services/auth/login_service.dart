import 'dart:convert';

import 'package:vet/services/auth/service_provider.dart';

abstract class LoginService {
  Future<LoginResponse> login(LoginRequest request);
}

class LoginResponse {
  final String message;
  final bool success;
  final String? body;

  LoginResponse({required this.message, required this.success, this.body}) {
    if (success) _saveToken();
  }

  void _saveToken() {
    final token = jsonDecode(body!)['token'];
    ServiceProvider.tokenService.saveToken(token);
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  String toJson() {
    return jsonEncode({'email': email, 'password': password});
  }
}
