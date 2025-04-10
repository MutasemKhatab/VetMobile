class VetOwner {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String? profilePicUrl;

  String get fullName => '$firstName $lastName';

  VetOwner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.profilePicUrl,
  });

  factory VetOwner.fromJson(Map<String, dynamic> json) {
    return VetOwner(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      profilePicUrl: json['profilePicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'profilePicUrl': profilePicUrl,
    };
  }
}
