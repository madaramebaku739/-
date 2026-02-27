import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String name = '';
  String gender = '非公開';
  String email = '';
  String phone = '';
  int weeklyGoal = 3;
  int fineAmount = 500;
  bool agreedToFine = false;
  int checkedInThisWeek = 0;
  bool fineTriggered = false;

  void registerProfile({
    required String newName,
    required String newGender,
    required String newEmail,
    required String newPhone,
  }) {
    name = newName;
    gender = newGender;
    email = newEmail;
    phone = newPhone;
    notifyListeners();
  }

  void updateGoal(int value) {
    weeklyGoal = value;
    notifyListeners();
  }

  void setAgreement(bool value) {
    agreedToFine = value;
    notifyListeners();
  }

  void updateFine(int value) {
    fineAmount = value;
    notifyListeners();
  }

  void checkIn() {
    checkedInThisWeek += 1;
    fineTriggered = false;
    notifyListeners();
  }

  void evaluateWeeklyPenalty() {
    fineTriggered = checkedInThisWeek < weeklyGoal && fineAmount > 0;
    notifyListeners();
  }
}
