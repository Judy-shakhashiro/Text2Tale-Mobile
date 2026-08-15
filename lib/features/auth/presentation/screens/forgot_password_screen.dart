import 'package:flutter/material.dart';
import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/custom_text_field.dart';
import 'package:text2tale_mobile/core/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "استعادة الحساب",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
              ),
              const SizedBox(height: 8),
              const Text(
                "الرجاء إدخال بريدك الإلكتروني والكود السري الذي قمت بتعيينه عند التسجيل لاستعادة الوصول لحسابك.",
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),
              const CustomTextField(
                label: "البريد الإلكتروني",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const CustomTextField(
                label: "الكود السري",
                icon: Icons.vpn_key_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "تحقق ومتابعة",
                onPressed: () {
                  // منطق التحقق
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}