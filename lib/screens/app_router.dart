import 'package:flutter/material.dart';

import 'auth_login_screen.dart';
import 'fine_agreement_screen.dart';
import 'fine_amount_screen.dart';
import 'goal_setting_screen.dart';
import 'home_screen.dart';
import 'intro_screen.dart';
import 'payment_link_screen.dart';
import 'progress_detail_screen.dart';
import 'signup_screen.dart';

class AppRouter {
  static const splash = '/';
  static const signup = '/signup';
  static const login = '/login';
  static const goal = '/goal';
  static const fineAgreement = '/fine-agreement';
  static const fineAmount = '/fine-amount';
  static const paymentLink = '/payment-link';
  static const home = '/home';
  static const progress = '/progress';

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const IntroScreen(),
    signup: (_) => const SignupScreen(),
    login: (_) => const AuthLoginScreen(),
    goal: (_) => const GoalSettingScreen(),
    fineAgreement: (_) => const FineAgreementScreen(),
    fineAmount: (_) => const FineAmountScreen(),
    paymentLink: (_) => const PaymentLinkScreen(),
    home: (_) => const HomeScreen(),
    progress: (_) => const ProgressDetailScreen(),
  };
}
