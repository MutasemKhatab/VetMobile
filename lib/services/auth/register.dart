import 'package:vet/main.dart';
import 'package:vet/services/auth/register_service.dart';
import 'package:http/http.dart' as http;

class Register implements RegisterService {
  static final url = '$baseUrl/api/auth/register';

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );
    if (response.statusCode == 200) {
      return RegisterResponse(message: 'Registration successful', status: true);
    } else {
      return RegisterResponse(message: response.body, status: false);
    }
  }
}
