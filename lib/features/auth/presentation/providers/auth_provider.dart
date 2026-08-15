import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // تسجيل الدخول
  Future<String?> loginUser(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _repository.login(email, password);
      await _saveTokens(response.accessToken!, response.refreshToken!);
      _currentUser = response.user;
      _setLoading(false);
      return null; // لا يوجد خطأ (نجاح)
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', ''); // إرجاع رسالة الخطأ للواجهة
    }
  }

  // إنشاء حساب
  Future<String?> registerUser(String firstName, String lastName, String email, String password) async {
    _setLoading(true);
    try {
      final response = await _repository.register(firstName, lastName, email, password);
      await _saveTokens(response.accessToken!, response.refreshToken!);
      _currentUser = response.user;
      _setLoading(false);
      return null; // نجاح
    } catch (e) {
      _setLoading(false);
      return e.toString().replaceAll('Exception: ', '');
    }
  }
  // دالة تغيير كلمة السر
  Future<String?> changeUserPassword(String oldPassword, String newPassword, String confirmPassword) async {
    _setLoading(true);
    try {
      // جلب التوكن من الذاكرة المحلية
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        _setLoading(false);
        return "جلسة المستخدم منتهية، يرجى تسجيل الدخول مجدداً.";
      }

      // استدعاء الـ API من الـ Repository
      await _repository.changePassword(oldPassword, newPassword, confirmPassword, token);
      
      _setLoading(false);
      return null; // null تعني أنه لا يوجد خطأ (العملية نجحت)
    } catch (e) {
      _setLoading(false);
      // إرجاع رسالة الخطأ القادمة من الباك إند
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  // حفظ التوكنز
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}