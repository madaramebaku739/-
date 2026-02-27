import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'メール')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'パスワード')),
            const SizedBox(height: 16),
            PrimaryCta(
              label: 'ログイン',
              onPressed: () => Navigator.pushNamed(context, AppRouter.goal),
            ),
            const SizedBox(height: 12),
            PrimaryCta(
              label: 'Googleでログイン',
              onPressed: firebaseService.loginWithGoogle,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
              child: const Text('新規登録はこちら'),
            ),
          ],
        ),
      ),
    );
  }
}
