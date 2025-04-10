import 'dart:convert';

abstract class ChangePasswordService {
  Future<bool> changePassword(ChangePasswordRequest request);
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest(
      {required this.currentPassword, required this.newPassword});

  String toJson() {
    return jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }
}

class ChangePasswordResponse {
  final String message;
  final bool status;

  ChangePasswordResponse({required this.message, required this.status});
}
