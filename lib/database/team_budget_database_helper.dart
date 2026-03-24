import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/team_budget_model.dart';

class BudgetDatabaseHelper {
  static BudgetDatabaseHelper? _databaseHelper;
  static Database? _database;

  String budgetTable = 'budget_table';
  String colId = 'id';
  String colCategory = 'category';
  String colAmount = 'amount';
  String colStartDate = 'start_date';
  String colEndDate = 'end_date';

  BudgetDatabaseHelper._();

  factory BudgetDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = BudgetDatabaseHelper._();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'budget.db');
    var budgetDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return budgetDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $budgetTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCategory TEXT, $colAmount REAL, '
            '$colStartDate TEXT, $colEndDate TEXT)');
  }

  Future<int> insertBudget(Budget budget) async {
    Database db = await this.database;
    var result = await db.insert(budgetTable, budget.toMap());
    return result;
  }

  Future<List<Budget>> getBudgetList() async {
    Database db = await this.database;
    var result = await db.query(budgetTable);
    List<Budget> budgetList =
    result.map((item) => Budget.fromMap(item)).toList();
    return budgetList;
  }
}
