class SubjectModel {
  final int id;
  final String name;
  final bool isActive;

  SubjectModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'] ?? true,
    );
  }
}