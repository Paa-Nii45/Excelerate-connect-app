import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';

class ExcelerateApp extends StatelessWidget {
  const ExcelerateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'Excelerate Connect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: authProvider.isAuthenticated ? '/home' : '/login',
          routes: AppRoutes.routes,
        );
      },
    );
  }
}