import 'package:vet/main.dart';
import 'package:vet/services/auth/register_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      try {
        // Try to parse the error response as a JSON array
        List<dynamic> errorList = jsonDecode(response.body);
        if (errorList.isNotEmpty) {
          // Format all errors into a readable message
          String errorMessage = errorList.map((error) {
            if (error is Map &&
                error.containsKey('code') &&
                error.containsKey('description')) {
              return "${error['description']}";
            }
            return error.toString();
          }).join('\n');

          return RegisterResponse(message: errorMessage, status: false);
        }
      } catch (e) {
        // If parsing fails, return the raw response body
        print("Error parsing response: $e");
      }

      // Default case if parsing fails
      return RegisterResponse(message: response.body, status: false);
    }
  }
}
