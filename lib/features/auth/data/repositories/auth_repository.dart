import 'package:dio/dio.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://text2tale-backend.alllahhham.com/api',
    headers: {'Content-Type': 'application/json'},
  ));

  // تسجيل الدخول
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        // معالجة حالة: "User is inactive"
        if (data['detail'] != null) {
          throw Exception(data['detail']);
        }
      }
      throw Exception('فشل الاتصال بالخادم، يرجى المحاولة لاحقاً');
    }
  }

  // إنشاء حساب
  Future<AuthResponseModel> register(String firstName, String lastName, String email, String password) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('فشل إنشاء الحساب، قد يكون البريد مستخدماً بالفعل.');
    }
  }

  // تغيير كلمة المرور
  Future<String> changePassword(String oldPassword, String newPassword, String confirmPassword, String token) async {
    try {
      final response = await _dio.post(
        '/change-password', // افترضت أن المسار هو /change-password
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_new_password": confirmPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        // معالجة رسائل الخطأ الخاصة بكلمة المرور
        if (data['new_password'] != null) {
          throw Exception(data['new_password'][0]);
        }
        if (data['old_password'] != null) {
          throw Exception(data['old_password'][0]);
        }
      }
      throw Exception('حدث خطأ أثناء تغيير كلمة المرور');
    }
  }
}