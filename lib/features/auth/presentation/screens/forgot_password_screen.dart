import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/auth_header.dart';
import 'package:text2tale_mobile/core/widgets/custom_text_field.dart';
import 'package:text2tale_mobile/core/widgets/primary_button.dart';

import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _securityKeyController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _handleResetPassword() async {
    final email = _emailController.text.trim();
    final securityKeyText = _securityKeyController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || securityKeyText.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء ملء جميع الحقول"), backgroundColor: Colors.orange),
      );
      return;
    }

    final securityKey = int.tryParse(securityKeyText);
    if (securityKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الكود السري يجب أن يكون رقماً"), backgroundColor: Colors.orange),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمتا المرور غير متطابقتين"), backgroundColor: Colors.orange),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final errorMessage = await authProvider.resetPassword(
      email: email,
      securityKey: securityKey,
      newPassword: newPassword,
      confirmNewPassword: confirmPassword,
    );

    if (!mounted) return;

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إعادة تعيين كلمة المرور بنجاح، يمكنك تسجيل الدخول الآن"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _securityKeyController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              icon: Icons.vpn_key_rounded,
              title: "استعادة الحساب",
              subtitle: "أدخل بريدك والكود السري الذي عيّنته عند التسجيل، ثم كلمة المرور الجديدة.",
              showBackButton: true,
            ),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      label: "البريد الإلكتروني",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: _securityKeyController,
                      label: "الكود السري",
                      icon: Icons.vpn_key_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 4),
                    Divider(color: AppColors.inputBorder.withOpacity(0.5)),
                    const SizedBox(height: 4),
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
                    const SizedBox(height: 28),
                    isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : PrimaryButton(text: "تحقق ومتابعة", onPressed: _handleResetPassword),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}