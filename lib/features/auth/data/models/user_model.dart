class UserModel {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'] ?? 'customer',
    );
  }
}