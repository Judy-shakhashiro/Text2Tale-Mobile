import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/custom_text_field.dart';
import 'package:text2tale_mobile/core/widgets/primary_button.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // تعريف متحكمات النصوص
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // استدعاء دالة تسجيل الدخول
    final errorMessage = await authProvider.loginUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تسجيل الدخول بنجاح!"), backgroundColor: Colors.green),
      );
     Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    // تنظيف المتحكمات من الذاكرة
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "مرحباً بعودتك!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
                const SizedBox(height: 8),
                const Text(
                  "سجل دخولك لمتابعة مشاريعك وقصصك.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController, // ربط الإيميل
                  label: "البريد الإلكتروني",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passwordController, // ربط الباسورد
                  label: "كلمة المرور",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // انتقال لشاشة نسيت كلمة السر
                    },
                    child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: AppColors.primary)),
                  ),
                  
                ),
                Align(alignment: Alignment.centerRight,
                child: TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup'); // يذهب لشاشة التسجيل
      },
      child: const Text("طالب جديد؟ أنشئ حسابك من هنا"),
    ),),
                const SizedBox(height: 24),
                isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : PrimaryButton(
                      text: "تسجيل الدخول",
                      onPressed: _handleLogin,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}