import 'dart:convert';

abstract class UpdateInfoService {
  Future<UpdateInfoResponse> updateProfile(UpdateProfileRequest request);
}

class UpdateInfoResponse {
  final String message;
  final bool status;

  UpdateInfoResponse({required this.message, required this.status});
}

class UpdateProfileRequest {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? address;
  final String? profilePicUrl;
  final String phoneNumber; // Added phone number

  UpdateProfileRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber, // Required phone number
    this.address,
    this.profilePicUrl,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'profilePicUrl': profilePicUrl,
      'phoneNumber': phoneNumber, // Added phone number
    });
  }
}
