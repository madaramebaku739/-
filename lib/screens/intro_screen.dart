import 'package:flutter/material.dart';

import '../widgets/primary_cta.dart';
import 'app_router.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('サボトレ', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            const Text(
              '自分を変えられたくても変えられない人へ。このアプリは罰金であなたを変える救世主です。'
              '週のジム目標を設定し、達成できなければ自分で決めた罰金を支払います。さあ、一緒に変わりましょう！',
              style: TextStyle(fontSize: 18, height: 1.6),
            ),
            const SizedBox(height: 40),
            PrimaryCta(
              label: '始める',
              onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
            ),
          ],
        ),
      ),
    );
  }
}
