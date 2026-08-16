import 'package:dio/dio.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://text2tale-backend.alllahhham.com/api',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // تسجيل الدخول
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login/',
        data: {"email": email, "password": password},
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  // إنشاء حساب
  Future<AuthResponseModel> register(
    String firstName,
    String lastName,
    String email,
    String password,
    int securityKey,
  ) async {
    try {
      final response = await _dio.post(
        '/register/',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "security_key": securityKey,
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  // تغيير كلمة المرور
  Future<String> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
    String token,
  ) async {
    try {
      final response = await _dio.patch(
        '/change_password/',
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_new_password": confirmPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['message']?.toString() ?? 'تم تغيير كلمة المرور بنجاح';
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }
  // نسيت كلمة المرور / إعادة تعيينها بالكود السري
  Future<String> resetPassword({
    required String email,
    required int securityKey,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final response = await _dio.patch(
        '/forgot password/',
        data: {
          "email": email,
          "security_key": securityKey,
          "new_password": newPassword,
          "confirm_new_password": confirmNewPassword,
        },
      );
      return response.data['message']?.toString() ?? 'تم إعادة تعيين كلمة المرور بنجاح';
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }
  

  // دالة موحّدة: بتستخرج رسالة خطأ واحدة بسيطة ومفهومة من أي شكل رد يرجعه السيرفر،
  // ومهما كان الرد (صفحة HTML، نص فاضي، شكل غير متوقع) ما بتعرضش محتواه الخام أبداً.
  String _extractErrorMessage(DioException e) {
    if (e.response == null) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'انتهت مهلة الاتصال، تحقق من اتصالك بالإنترنت';
        case DioExceptionType.connectionError:
          return 'تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت';
        default:
          return 'حدث خطأ غير متوقع، حاول مرة أخرى';
      }
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map) {
      // {"error": "Invalid email or password"}
      if (data['error'] != null) return data['error'].toString();

      // {"detail": "..."}
      if (data['detail'] != null) return data['detail'].toString();

      // {"errors": {"email": ["user with this email already exists."]}}
      // أو شكل مسطّح زي {"new_password": ["..."]}
      final errorsContainer = data['errors'] is Map ? data['errors'] as Map : data;
      for (final value in errorsContainer.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      if (data['message'] != null) return data['message'].toString();
    }

    if (data is List && data.isNotEmpty) {
      return data.first.toString();
    }

    // أي شكل تاني غير متوقع (زي صفحة الـ Debug اللي شفناها) — رسالة عامة بس، بدون تفاصيل
    if (statusCode != null && statusCode >= 500) {
      return 'حدث خطأ في الخادم، حاول مرة أخرى لاحقاً';
    }
    return 'حدث خطأ غير متوقع، حاول مرة أخرى';
  }
}