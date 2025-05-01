import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/services/auth/change_password_service.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/error_parser.dart';

class ChangePassword extends ChangePasswordService {
  static final url = '$baseUrl/api/password/change-password';

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest request) async {
    final token = await ServiceProvider.tokenService.getToken();

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ChangePasswordResponse(
          message: 'Password changed successfully',
          status: true,
        );
      } else {
        return ChangePasswordResponse(
          message: ErrorParser.parseErrorResponse(response.body),
          status: false,
        );
      }
    } catch (e) {
      return ChangePasswordResponse(
        message: 'Failed to change password: $e',
        status: false,
      );
    }
  }
}
