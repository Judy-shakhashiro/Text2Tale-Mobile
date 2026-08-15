import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/custom_text_field.dart';
import 'package:text2tale_mobile/core/widgets/primary_button.dart';

import '../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _handleChangePassword() async {
    // 1. التحقق من أن الحقول غير فارغة قبل إرسال الطلب
    if (_oldPasswordController.text.isEmpty || 
        _newPasswordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء ملء جميع الحقول"), backgroundColor: Colors.orange),
      );
      return;
    }

    // 2. استدعاء الدالة من الـ Provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final errorMessage = await authProvider.changeUserPassword(
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
      _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    // 3. معالجة النتيجة
    if (errorMessage == null) {
      // نجاح العملية
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح! 🔒"), backgroundColor: Colors.green),
      );
      
      // تفريغ الحقول بعد النجاح
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      
      // يمكنك هنا إضافة كود للعودة للشاشة السابقة
      // Navigator.pop(context);
    } else {
      // فشل العملية (إظهار الخطأ القادم من الـ API مثل: كلمات المرور غير متطابقة)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الاستماع لحالة التحميل
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("تحديث الأمان", style: TextStyle(color: AppColors.secondary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "تغيير كلمة المرور",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _oldPasswordController,
                label: "كلمة المرور الحالية",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              CustomTextField(
                controller: _newPasswordController,
                label: "كلمة المرور الجديدة",
                icon: Icons.lock_reset,
                isPassword: true,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                label: "تأكيد كلمة المرور الجديدة",
                icon: Icons.check_circle_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              
              // إظهار دائرة التحميل أو زر الحفظ
              isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : PrimaryButton(
                      text: "حفظ التغييرات",
                      onPressed: _handleChangePassword,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}