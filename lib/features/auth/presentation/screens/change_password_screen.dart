import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/auth_header.dart';
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
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء ملء جميع الحقول"), backgroundColor: Colors.orange),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final errorMessage = await authProvider.changeUserPassword(
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
      _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح! 🔒"), backgroundColor: Colors.green),
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else {
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
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              icon: Icons.shield_outlined,
              title: "تحديث الأمان",
              subtitle: "حافظ على أمان حسابك بتحديث كلمة المرور بشكل دوري.",
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
                    const SizedBox(height: 28),
                    isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : PrimaryButton(text: "حفظ التغييرات", onPressed: _handleChangePassword),
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