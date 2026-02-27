import 'package:flutter/material.dart';

import 'screens/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SabotoreApp());
}

class SabotoreApp extends StatelessWidget {
  const SabotoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'サボトレ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0057FF),
          brightness: Brightness.light,
          primary: const Color(0xFF0057FF),
          secondary: const Color(0xFFFFB100),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
        useMaterial3: true,
      ),
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
