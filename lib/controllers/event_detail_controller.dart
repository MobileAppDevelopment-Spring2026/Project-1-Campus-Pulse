import 'package:flutter/material.dart';
import '../data/social_missions_catalog.dart';
import '../database/event_database_helper.dart';
import '../models/event_model.dart';

class ExpenseDetailController {
  final Expense expense;
  final VoidCallback updateExpenses;
  final ExpenseDatabaseHelper _dbHelper = ExpenseDatabaseHelper();

  ExpenseDetailController(
      {required this.expense, required this.updateExpenses});

  bool get isSocialMission => expense.category == socialMissionsCategory;

  Future<void> _syncSocialMissionProgress(bool isCompleted) async {
    if (!isSocialMission || expense.id == null) {
      return;
    }

    final int? missionId =
        await _dbHelper.getMissionIdByLinkedExpenseId(expense.id!);
    if (missionId == null) {
      return;
    }

    await _dbHelper.upsertMissionProgress(
      missionId: missionId,
      isCompleted: isCompleted,
      linkedExpenseId: expense.id,
    );
  }

  Future<bool> reserveExpense(BuildContext context) async {
    if (expense.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to RSVP for this event yet.')),
      );
      return false;
    }

    if (expense.isReserved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already reserved this event.')),
      );
      return false;
    }

    await _dbHelper.markExpenseAsReserved(expense.id!);
    expense.isReserved = true;
    await _syncSocialMissionProgress(true);
    updateExpenses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSocialMission
              ? 'Mission marked as completed.'
              : 'RSVP confirmed. Added to your activity list.',
        ),
      ),
    );
    return true;
  }

  Future<bool> unreserveExpense(BuildContext context) async {
    if (expense.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update RSVP for this event.')),
      );
      return false;
    }

    if (!expense.isReserved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This event is not reserved yet.')),
      );
      return false;
    }

    await _dbHelper.unmarkExpenseAsReserved(expense.id!);
    expense.isReserved = false;
    await _syncSocialMissionProgress(false);
    updateExpenses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSocialMission
              ? 'Mission completion removed.'
              : 'RSVP removed. You can reserve this event again anytime.',
        ),
      ),
    );
    return true;
  }

  Future<void> deleteExpense(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
          title: const Center(
            child: Text(
              'Remove Event',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Text(
            'Are you sure you want to remove this event from the discovery list?',
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _dbHelper.deleteExpense(expense.id!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    updateExpenses();
                  },
                  child: Text(
                    'Remove',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
