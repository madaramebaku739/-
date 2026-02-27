import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = (appState.checkedInThisWeek / appState.weeklyGoal).clamp(0, 1).toDouble();
    return Scaffold(
      appBar: AppBar(title: const Text('サボトレ ホーム')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('メニュー')),
            ListTile(title: const Text('規約表示'), onTap: () {}),
            ListTile(title: const Text('目標確認/変更'), onTap: () => Navigator.pushNamed(context, AppRouter.goal)),
            ListTile(title: const Text('支払方法'), onTap: () => Navigator.pushNamed(context, AppRouter.paymentLink)),
            ListTile(title: const Text('進捗詳細'), onTap: () => Navigator.pushNamed(context, AppRouter.progress)),
            ListTile(title: const Text('アカウント削除'), onTap: () {}),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (appState.fineTriggered)
              Card(
                color: Colors.red.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('罰金発生！Webで支払ってください', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
            PrimaryCta(
              label: 'チェックイン（カメラ起動）',
              onPressed: () async {
                await firebaseService.uploadCheckInPhoto();
                appState.checkIn();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('達成！ナイスチェックイン')));
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            Text('今週の達成度 ${appState.checkedInThisWeek}/${appState.weeklyGoal}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(minHeight: 24, value: progress),
            const SizedBox(height: 12),
            Text(progress >= 1 ? '最高！目標達成です。' : '継続中。今日も小さく1歩。', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() => appState.evaluateWeeklyPenalty());
        },
        label: const Text('週末判定'),
        icon: const Icon(Icons.gavel),
      ),
    );
  }
}
