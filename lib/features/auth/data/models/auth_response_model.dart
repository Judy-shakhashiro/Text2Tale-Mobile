import 'user_model.dart';

class AuthResponseModel {
  final String message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  AuthResponseModel({
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] ?? 'Success',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}