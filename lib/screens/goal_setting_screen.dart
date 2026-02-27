import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  double _goal = appState.weeklyGoal.toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('目標設定')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('週のジム通い回数: ${_goal.toInt()}回', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Slider(
              min: 1,
              max: 7,
              divisions: 6,
              value: _goal,
              label: _goal.toInt().toString(),
              onChanged: (value) => setState(() => _goal = value),
            ),
            const Spacer(),
            PrimaryCta(
              label: '次へ',
              onPressed: () {
                appState.updateGoal(_goal.toInt());
                Navigator.pushNamed(context, AppRouter.fineAgreement);
              },
            ),
          ],
        ),
      ),
    );
  }
}
