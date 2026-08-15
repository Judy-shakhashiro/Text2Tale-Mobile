import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text2tale_mobile/features/auth/presentation/screens/test.dart';

// استدعاء ملفات الثيم (الألوان)
import 'core/theme/app_colors.dart';

// استدعاء الـ Provider
import 'features/auth/presentation/providers/auth_provider.dart';

// استدعاء الشاشات
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/change_password_screen.dart';

void main() {
  // التأكد من تهيئة الفلتر قبل تشغيل التطبيق (مهم جداً عند استخدام SharedPreferences مستقبلاً في main)
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const Text2TaleApp());
}

class Text2TaleApp extends StatelessWidget {
  const Text2TaleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 1. حقن مزودي الخدمة (Providers) هنا
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // يمكنك إضافة مزودين آخرين هنا مستقبلاً (مثل StoryProvider)
      ],
      
      // 2. إعداد MaterialApp
      child: MaterialApp(
        title: 'Text2Tale',
        debugShowCheckedModeBanner: false, // إخفاء شريط الـ Debug
        
        // إعداد الهوية البصرية للتطبيق بالكامل
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Cairo', // يفضل إضافة خط مثل Cairo في pubspec.yaml
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
        ),
        
        // 3. تحديد الشاشة الافتراضية عند فتح التطبيق
        initialRoute: '/login',
        
        // 4. خريطة التوجيه (Routes) لتسهيل التنقل واختبار الواجهات
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/home': (context) => const TestHomeScreen(), // شاشة وهمية مؤقتة للاختبار
        },
      ),
    );
  }
}