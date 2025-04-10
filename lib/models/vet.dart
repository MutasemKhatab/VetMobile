class Vet {
  final int id;
  final String name;
  final String gender;
  final String species;
  final DateTime? dateOfBirth;
  final String? picUrl;
  final String? ownerId;

  Vet({
    required this.id,
    required this.name,
    required this.gender,
    required this.species,
    this.dateOfBirth,
    this.picUrl,
    this.ownerId,
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      species: json['species'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      picUrl: json['profilePicUrl'],
      ownerId: json['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'species': species,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profilePicUrl': picUrl,
      'ownerId': ownerId,
    };
  }
}
