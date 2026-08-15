import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/custom_text_field.dart';
import 'package:text2tale_mobile/core/widgets/primary_button.dart';

import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // تعريف متحكمات النصوص
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secretCodeController = TextEditingController();

  void _handleRegister() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final errorMessage = await authProvider.registerUser(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      // ملاحظة: الـ API لديك حالياً لا يستقبل الكود السري، لكننا نحتفظ به في الواجهة للغرض التصميمي.
    );

    if (!mounted) return;

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إنشاء الحساب بنجاح!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _secretCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "إنشاء حساب جديد",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
              ),
              const SizedBox(height: 8),
              const Text(
                "ابدأ بتحويل أفكارك ودروسك إلى قصص إبداعية.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      label: "الاسم الأول", 
                      icon: Icons.person_outline
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      label: "الاسم الأخير", 
                      icon: Icons.person_outline
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: _emailController,
                label: "البريد الإلكتروني",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                controller: _passwordController,
                label: "كلمة المرور",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              CustomTextField(
                controller: _secretCodeController,
                label: "الكود السري (للاسترداد)",
                icon: Icons.vpn_key_outlined,
                keyboardType: TextInputType.number,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warningText.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.warningText),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "يرجى حفظ الكود السري في مكان آمن، ستحتاجه لاستعادة حسابك.",
                        style: TextStyle(color: AppColors.warningText, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : PrimaryButton(
                      text: "إنشاء الحساب",
                      onPressed: _handleRegister,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}