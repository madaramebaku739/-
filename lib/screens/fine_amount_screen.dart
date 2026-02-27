import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class FineAmountScreen extends StatefulWidget {
  const FineAmountScreen({super.key});

  @override
  State<FineAmountScreen> createState() => _FineAmountScreenState();
}

class _FineAmountScreenState extends State<FineAmountScreen> {
  final controller = TextEditingController(text: '500');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('罰金額設定')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('100円以上で設定できます（0円で停止）。', style: TextStyle(fontSize: 18)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '罰金額（円）'),
            ),
            const Spacer(),
            PrimaryCta(
              label: '設定完了',
              onPressed: () {
                appState.updateFine(int.tryParse(controller.text) ?? 0);
                Navigator.pushNamed(context, AppRouter.paymentLink);
              },
            ),
          ],
        ),
      ),
    );
  }
}
