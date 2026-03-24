import 'package:flutter/material.dart';
import '../utils/app_screen_widgets.dart';

class DashboardController {
  static void navigateToExpenseEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseEntryScreen()),
    );
  }

  static void navigateToBudgetSetup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BudgetSetupScreen()),
    );
  }

  static void navigateToSocialMissions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SocialMissionsScreen()),
    );
  }

  static void navigateToReportsAndCharts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportsAndChartsScreen()),
    );
  }
}
