import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
// import 'firebase_options.dart'; // Will be added after user provides config

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CommunityShieldApp());
}

class CommunityShieldApp extends StatelessWidget {
  const CommunityShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Shield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // For now, we start at Login. In a real app with Firebase fully config'd, we'd use a StreamBuilder on authStateChanges
      home: const LoginScreen(),
    );
  }
}
