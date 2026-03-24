import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database/event_database_helper.dart';
import '../models/event_model.dart';
import '../screens/event_detail_screen.dart';
import '../utils/category_aggregate.dart';

class ReportsAndChartsController {
  List<Expense> expenseList = [];
  final dbHelper = ExpenseDatabaseHelper();

  Future<void> getExpenses() async {
    List<Expense> expenses = await dbHelper.getReservedExpenseList();
    expenseList = expenses;
  }

  Widget buildEmptyState() {
    return Center(
      child: Text(
        'No engagement records yet.',
        style: GoogleFonts.rubik(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildCharts(BuildContext context, VoidCallback updateExpenses) {
    Map<String, double> categoryTotalMap = _calculateCategoryTotal(expenseList);
    final int participationCount = expenseList.length;
    final int streak = _calculateAttendanceStreak(expenseList);
    final int badges = _calculateBadgeCount(participationCount, streak);
    final double totalEngagementPoints =
        _calculateTotalEngagementPoints(expenseList);

    List<charts.Series<CategoryTotal, String>> seriesList = [
      charts.Series(
        id: 'EngagementByTrack',
        data: categoryTotalMap.entries
            .map((entry) => CategoryTotal(entry.key, entry.value))
            .toList(),
        domainFn: (CategoryTotal categoryTotal, _) => categoryTotal.category,
        measureFn: (CategoryTotal categoryTotal, _) => categoryTotal.total,
      )
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Participation', '$participationCount events')),
              SizedBox(width: 8),
              Expanded(child: _buildStatCard('Streak', '$streak days')),
              SizedBox(width: 8),
              Expanded(child: _buildStatCard('Badges', '$badges earned')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Engagement Points',
                  totalEngagementPoints.toStringAsFixed(0),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: SizedBox(
            height: 200,
            child: charts.BarChart(
              seriesList,
              animate: true,
              vertical: false,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: expenseList.length,
            itemBuilder: (context, index) {
              Expense expense = expenseList[index];
              Color? backgroundColor = Colors.pinkAccent.shade100;
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: ListTile(
                  title: Text(
                    'Track: ${expense.category}',
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    'Engagement points: ${expense.amount.toStringAsFixed(0)} - ${DateFormat.yMd().format(expense.date)}',
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    _navigateToExpenseDetailScreen(
                        context, expense, updateExpenses);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToExpenseDetailScreen(
      BuildContext context, Expense expense, VoidCallback updateExpenses) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(
          expense: expense,
          updateExpenses: updateExpenses,
          canRemoveEvent: false,
        ),
      ),
    );
  }

  Map<String, double> _calculateCategoryTotal(List<Expense> expenses) {
    Map<String, double> categoryTotalMap = {};

    for (Expense expense in expenses) {
      if (categoryTotalMap.containsKey(expense.category)) {
        categoryTotalMap[expense.category] =
            (categoryTotalMap[expense.category] ?? 0) + expense.amount;
      } else {
        categoryTotalMap[expense.category] = expense.amount;
      }
    }

    return categoryTotalMap;
  }

  double _calculateTotalEngagementPoints(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style:
                GoogleFonts.archivo(fontSize: 14, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.rubik(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _calculateAttendanceStreak(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return 0;
    }

    final List<DateTime> uniqueDates = expenses
        .map((expense) =>
            DateTime(expense.date.year, expense.date.month, expense.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    int currentStreak = 1;
    int maxStreak = 1;

    for (int i = 1; i < uniqueDates.length; i++) {
      if (uniqueDates[i].difference(uniqueDates[i - 1]).inDays == 1) {
        currentStreak++;
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  int _calculateBadgeCount(int participationCount, int streak) {
    int badges = participationCount ~/ 3;
    if (streak >= 3) {
      badges += 1;
    }
    return badges;
  }
}
