
class Vaccine {
  final int id;
  final String name;
  final String description;
  final int vetId;
  final List<DateTime> doses;

  Vaccine({
    required this.id,
    required this.name,
    required this.description,
    required this.vetId,
    required this.doses,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      vetId: json['vetId'],
      doses: (json['doses'] as List).map((e) => DateTime.parse(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'vetId': vetId,
      'doses': doses.map((e) => e.toIso8601String()).toList(),
    };
  }
}
