import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import '../widgets/primary_cta.dart';
import 'app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = '非公開';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: '名前')),
          DropdownButtonFormField<String>(
            value: _gender,
            items: const ['男性', '女性', 'その他', '非公開']
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (value) => setState(() => _gender = value ?? '非公開'),
            decoration: const InputDecoration(labelText: '性別'),
          ),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'メールアドレス')),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: '電話番号')),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'パスワード')),
          const SizedBox(height: 24),
          PrimaryCta(
            label: '登録',
            onPressed: () {
              appState.registerProfile(
                newName: _nameController.text,
                newGender: _gender,
                newEmail: _emailController.text,
                newPhone: _phoneController.text,
              );
              Navigator.pushNamed(context, AppRouter.goal);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.login),
            child: const Text('既に登録済みの方はこちら'),
          ),
        ],
      ),
    );
  }
}
