import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/services/auth/change_password_service.dart';
import 'package:vet/services/auth/service_provider.dart';

class ChangePassword extends ChangePasswordService {
  static final url = '$baseUrl/api/password/change-password';

  @override
  Future<bool> changePassword(ChangePasswordRequest request) async {
    final token = await ServiceProvider.tokenService.getToken();

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      final changePasswordResponse = ChangePasswordResponse(
        message: response.body,
        status: true,
      );

      return changePasswordResponse.status;
    } else {
      throw Exception('Failed to change password: ${response.body}');
    }
  }
}
