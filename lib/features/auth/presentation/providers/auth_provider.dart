import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // true أثناء التحقق من وجود جلسة محفوظة عند بدء تشغيل التطبيق
  bool _isCheckingAuth = true;
  bool get isCheckingAuth => _isCheckingAuth;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  String? _accessToken;
  bool get isLoggedIn => _accessToken != null;

  // تُستدعى مرة واحدة عند بدء تشغيل التطبيق (من AuthGate) للتحقق من وجود توكن محفوظ
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final userJson = prefs.getString('current_user');

      if (token != null && token.isNotEmpty) {
        _accessToken = token;
        if (userJson != null) {
          _currentUser = UserModel.fromJson(jsonDecode(userJson));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  // تسجيل الدخول
  Future<String?> loginUser(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _repository.login(email, password);
      await _saveSession(response.accessToken!, response.refreshToken!, response.user);
      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  // إنشاء حساب
  Future<String?> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    int securityKey,
  ) async {
    _setLoading(true);
    try {
      final response = await _repository.register(
        firstName,
        lastName,
        email,
        password,
        securityKey,
      );
      await _saveSession(response.accessToken!, response.refreshToken!, response.user);
      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  // تغيير كلمة السر
  Future<String?> changeUserPassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _setLoading(false);
        return "جلسة المستخدم منتهية، يرجى تسجيل الدخول مجدداً.";
      }

      await _repository.changePassword(oldPassword, newPassword, confirmPassword, token);

      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  // تسجيل الخروج: مسح كل بيانات الجلسة المحفوظة
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('current_user');
    _accessToken = null;
    _currentUser = null;
    notifyListeners();
  }

  // حفظ التوكنز وبيانات المستخدم معًا محليًا
  Future<void> _saveSession(String accessToken, String refreshToken, UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    if (user != null) {
      await prefs.setString('current_user', jsonEncode(user.toJson()));
    }
    _accessToken = accessToken;
    _currentUser = user;
  }
  // إعادة تعيين كلمة المرور المنسية
  Future<String?> resetPassword({
    required String email,
    required int securityKey,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _setLoading(true);
    try {
      await _repository.resetPassword(
        email: email,
        securityKey: securityKey,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      _setLoading(false);
      return null; // نجاح
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}