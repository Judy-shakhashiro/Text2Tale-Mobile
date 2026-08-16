import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:text2tale_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:text2tale_mobile/features/auth/presentation/screens/test.dart';


class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isCheckingAuth) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return authProvider.isLoggedIn ? const TestHomeScreen() : const LoginScreen();
  }
}