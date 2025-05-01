import 'package:vet/main.dart';
import 'package:vet/services/auth/login_service.dart';
import 'package:http/http.dart' as http;
import 'package:vet/utils/error_parser.dart';

class Login implements LoginService {
  static final url = '$baseUrl/api/auth/login';
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: request.toJson(),
    );
    if (response.statusCode == 200) {
      return LoginResponse(
        message: 'Login successful',
        success: true,
        body: response.body,
      );
    } else {
      return LoginResponse(
          message: ErrorParser.parseErrorResponse(response.body),
          success: false);
    }
  }
}

/*
  Request
    {
      "email": "string",
      "password": "string"
    }
*/
