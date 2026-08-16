import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/home_header.dart';
import 'package:text2tale_mobile/features/auth/presentation/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _handleMenuSelection(BuildContext context, String value) async {
    if (value == 'change_password') {
      Navigator.pushNamed(context, '/change-password');
    } else if (value == 'logout') {
      await context.read<AuthProvider>().logoutUser();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = (user?.firstName != null && user!.firstName!.trim().isNotEmpty)
        ? user.firstName!
        : (user?.email ?? 'صديقنا');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(
              greetingName: displayName,
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                  onSelected: (value) => _handleMenuSelection(context, value),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'change_password', child: Text('تغيير كلمة المرور')),
                    PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
                  ],
                ),
              ],
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
                    const Text(
                      "جاهز تبدأ قصة جديدة؟",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "حوّل دروسك المفضلة إلى قصص شيقة وسهلة الفهم في خطوات بسيطة.",
                      style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _CreateStoryCard(
                      onTap: () => Navigator.pushNamed(context, '/my-subjects'),
                    ),
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

class _CreateStoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateStoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إنشاء قصة",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "اختر مادتك وابدأ التحويل",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, size: 22, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}