import 'dart:convert';

abstract class RegisterService {
  Future<RegisterResponse> register(RegisterRequest request);
}

class RegisterResponse {
  final String message;
  final bool status;

  RegisterResponse({required this.message, required this.status});
}

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  static const String userType = 'VetOwner';
  final String? address;
  final String? profilePicUrl;
  final String phoneNumber; // Added phone number

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber, // Required phone number
    this.address,
    this.profilePicUrl,
  });

  String toJson() {
    return jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'userType': userType,
      'address': address,
      'profilePicUrl': profilePicUrl,
      'phoneNumber': phoneNumber, // Added phone number
    });
  }
}
