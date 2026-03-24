import 'package:flutter/material.dart';
import '../data/social_missions_catalog.dart';
import '../database/event_database_helper.dart';
import '../models/event_model.dart';

class ExpenseEntryController {
  final TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final List<String> eventCategories = const [
    'Arts & Culture',
    'STEM',
    'Career Growth',
    'Sports & Wellness',
    'Community Service'
  ];
  final List<String> filterOptions = const [
    'All Tracks',
    'Arts & Culture',
    'STEM',
    'Career Growth',
    'Sports & Wellness',
    'Community Service'
  ];
  String selectedCategory = 'Arts & Culture';
  String selectedFilter = 'All Tracks';
  final TextEditingController notesController = TextEditingController();
  final dbHelper = ExpenseDatabaseHelper();
  List<Expense> expenseList = [];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }

  Future<void> getExpenses() async {
    expenseList = await dbHelper.getExpenseList();
  }

  List<Expense> getFilteredEvents() {
    final List<Expense> visibleEvents = expenseList
        .where((event) => event.category != socialMissionsCategory)
        .toList();

    if (selectedFilter == 'All Tracks') {
      return visibleEvents;
    }
    return visibleEvents
        .where((event) => event.category == selectedFilter)
        .toList();
  }

  Future<bool> saveExpense(BuildContext context) async {
    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid participant count.')),
      );
      return false;
    }
    String notes = notesController.text;

    Expense expense = Expense(
      amount: amount,
      date: selectedDate,
      category: selectedCategory,
      notes: notes,
    );

    await dbHelper.insertExpense(expense);
    await getExpenses();

    amountController.clear();
    notesController.clear();
    selectedCategory = 'Arts & Culture';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event saved to discovery list.')),
    );
    return true;
  }
}
