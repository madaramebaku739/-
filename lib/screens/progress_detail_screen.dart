import 'package:flutter/material.dart';

import '../services/service_locator.dart';

class ProgressDetailScreen extends StatelessWidget {
  const ProgressDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('進捗詳細')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ストリーク: ${appState.checkedInThisWeek}日', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('励ましメッセージ: ${appState.checkedInThisWeek > 0 ? '積み上がってます！' : '最初の1回が最強です。'}'),
            const SizedBox(height: 24),
            const Text('カレンダー（簡易）', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(14, (index) {
                final active = index < appState.checkedInThisWeek;
                final date = today.subtract(Duration(days: index));
                return Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? Colors.green : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${date.month}/${date.day}', style: TextStyle(color: active ? Colors.white : Colors.black87)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
