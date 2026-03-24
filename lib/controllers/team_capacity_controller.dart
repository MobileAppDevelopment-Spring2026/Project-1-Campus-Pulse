import 'package:flutter/material.dart';
import '../database/team_budget_database_helper.dart';
import '../database/event_database_helper.dart';
import '../models/team_budget_model.dart';
import '../utils/status_dialog_widgets.dart';

class BudgetSetupController {
  final List<String> teamCategories = const [
    'Community Outreach',
    'Academic Mentoring',
    'Event Logistics',
    'Media & Promotions',
    'Sports Coordination'
  ];
  String selectedCategory = 'Community Outreach';
  final TextEditingController amountController = TextEditingController();
  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  final BudgetDatabaseHelper dbBudgetHelper = BudgetDatabaseHelper();
  final ExpenseDatabaseHelper dbExpenseHelper = ExpenseDatabaseHelper();

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate) {
      startDate = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != endDate) {
      endDate = picked;
    }
  }

  Future<void> saveBudget(BuildContext context) async {
    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid team capacity.')),
      );
      return;
    }

    Budget budget = Budget(
      category: selectedCategory,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
    );

    await dbBudgetHelper.insertBudget(budget);

    // Check if the total amount spent for the selected category exceeds the budget amount
    bool exceedsBudget = await _checkBudgetExceeded(
        selectedCategory, amount, startDate, endDate);

    if (exceedsBudget) {
      DialogWidgets.showExceedDialog(context, selectedCategory);
    } else {
      DialogWidgets.showNotExceedDialog(context, selectedCategory);
    }

    // Clear the text fields after saving
    amountController.clear();
    // Reset selected category
    selectedCategory = 'Community Outreach';
  }

  Future<bool> _checkBudgetExceeded(String category, double budgetAmount,
      DateTime startDate, DateTime endDate) async {
    double totalAmountSpent =
        await dbExpenseHelper.getTotalAmountSpentForCategory(
            category, startDate.toString(), endDate.toString());
    return totalAmountSpent > budgetAmount;
  }
}
