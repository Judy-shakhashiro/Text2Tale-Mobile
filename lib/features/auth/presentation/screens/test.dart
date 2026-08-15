import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المستخدم لمعرفة من قام بتسجيل الدخول
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية (للاختبار)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "أهلاً بك في Text2Tale! 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "الإيميل: ${user?.email ?? 'غير معروف'}",
              style: const TextStyle(fontSize: 16, color: AppColors.secondary),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // تجربة الانتقال لشاشة تغيير كلمة السر
                Navigator.pushNamed(context, '/change-password');
              },
              child: const Text("اختبار تغيير كلمة السر"),
            ),
            TextButton(
              onPressed: () {
                // تسجيل الخروج والعودة لتسجيل الدخول
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}