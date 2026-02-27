import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/firebase_service.dart';
import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class PaymentLinkScreen extends StatelessWidget {
  const PaymentLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final url = firebaseService.buildStripePayUrl(userId: appState.email, amount: appState.fineAmount);
    return Scaffold(
      appBar: AppBar(title: const Text('支払方法')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '罰金はアプリ外のWeb決済（Stripe）でお支払いください。お得に手数料を抑えるため、ブラウザで支払います。'
              '対応方法：クレジットカード、デビットカード、Apple Pay、Google Pay。'
              '罰金発生時はこの画面に戻って「Webで支払う」ボタンを押してください。',
              style: TextStyle(fontSize: 17, height: 1.5),
            ),
            const SizedBox(height: 16),
            SelectableText('ブラウザで「サボトレ 罰金支払い」と検索、またはこのURLをコピー：\n$url'),
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URLをコピーしました')));
                }
              },
              icon: const Icon(Icons.copy),
              label: const Text('URLをコピー'),
            ),
            const Spacer(),
            PrimaryCta(label: 'Webで支払う', onPressed: () => firebaseService.launchPayUrl(url)),
            const SizedBox(height: 12),
            PrimaryCta(
              label: '了解、次へ',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false),
            ),
          ],
        ),
      ),
    );
  }
}
