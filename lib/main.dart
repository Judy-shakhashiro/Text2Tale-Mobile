import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text2tale_mobile/features/auth/auth_gate.dart';
import 'package:text2tale_mobile/features/auth/presentation/screens/test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_colors.dart';

import 'features/auth/presentation/providers/auth_provider.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/change_password_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Text2TaleApp());
}

class Text2TaleApp extends StatelessWidget {
  const Text2TaleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Text2Tale',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Cairo',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
        ),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // AuthGate بيقرر تلقائيًا: لو فيه جلسة محفوظة يدخل على طول للرئيسية، غير كده يعرض تسجيل الدخول
        home: const AuthGate(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/home': (context) => const TestHomeScreen(),
        },
      ),
    );
  }
}