import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class FineAgreementScreen extends StatefulWidget {
  const FineAgreementScreen({super.key});

  @override
  State<FineAgreementScreen> createState() => _FineAgreementScreenState();
}

class _FineAgreementScreenState extends State<FineAgreementScreen> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('罰金システム同意')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '目標未達成時に罰金が発生します。これは自己責任のコミットメントペナルティです。金額は自分で自由に設定でき、いつでも変更/0円にして停止可能です。法的には私人間の契約に基づきます。同意しますか？',
              style: TextStyle(fontSize: 18, height: 1.5),
            ),
            CheckboxListTile(
              value: agreed,
              onChanged: (value) => setState(() => agreed = value ?? false),
              title: const Text('同意します'),
              contentPadding: EdgeInsets.zero,
            ),
            const Spacer(),
            PrimaryCta(
              label: '同意して次へ',
              onPressed: agreed
                  ? () {
                      appState.setAgreement(true);
                      Navigator.pushNamed(context, AppRouter.fineAmount);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
