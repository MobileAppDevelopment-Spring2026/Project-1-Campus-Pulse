import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';

class ExpenseDatabaseHelper {
  static ExpenseDatabaseHelper? _databaseHelper;
  static Database? _database;

  String expenseTable = 'expense_table';
  String colId = 'id';
  String colAmount = 'amount';
  String colDate = 'date';
  String colCategory = 'category';
  String colNotes = 'notes';
  String colIsReserved = 'is_reserved';

  String missionProgressTable = 'mission_progress_table';
  String colMissionId = 'mission_id';
  String colIsCompleted = 'is_completed';
  String colLinkedExpenseId = 'linked_expense_id';

  String teamAssignmentTable = 'team_assignment_table';
  String colAssignmentId = 'id';
  String colAssignmentTeamName = 'team_name';
  String colAssignmentEventId = 'event_id';
  String colAssignmentEventTitle = 'event_title';
  String colAssignmentEventDate = 'event_date';
  String colAssignmentMember = 'member_name';
  String colAssignmentRole = 'role';
  String colAssignmentResponsibility = 'responsibility';

  String teamMembershipTable = 'team_membership_table';
  String colMembershipTeamName = 'team_name';
  String colMembershipIsJoined = 'is_joined';

  ExpenseDatabaseHelper._();

  factory ExpenseDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = ExpenseDatabaseHelper._();
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
    String path = join(await getDatabasesPath(), 'expense.db');
    var expensesDatabase = await openDatabase(
      path,
      version: 5,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
    return expensesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $expenseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount REAL, $colDate TEXT, '
        '$colCategory TEXT, $colNotes TEXT, $colIsReserved INTEGER DEFAULT 0)');

    await db.execute(
        'CREATE TABLE $missionProgressTable($colMissionId INTEGER PRIMARY KEY, '
        '$colIsCompleted INTEGER DEFAULT 0, $colLinkedExpenseId INTEGER)');

    await db.execute(
        'CREATE TABLE $teamAssignmentTable($colAssignmentId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colAssignmentTeamName TEXT NOT NULL, $colAssignmentEventId INTEGER, '
        '$colAssignmentEventTitle TEXT, $colAssignmentEventDate TEXT, '
        '$colAssignmentMember TEXT, $colAssignmentRole TEXT, '
        '$colAssignmentResponsibility TEXT)');

    await db.execute(
        'CREATE TABLE $teamMembershipTable($colMembershipTeamName TEXT PRIMARY KEY, '
        '$colMembershipIsJoined INTEGER DEFAULT 0)');
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $expenseTable ADD COLUMN $colIsReserved INTEGER DEFAULT 0',
      );
    }

    if (oldVersion < 3) {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $missionProgressTable($colMissionId INTEGER PRIMARY KEY, '
          '$colIsCompleted INTEGER DEFAULT 0, $colLinkedExpenseId INTEGER)');
    }

    if (oldVersion < 4) {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $teamAssignmentTable($colAssignmentId INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$colAssignmentTeamName TEXT NOT NULL, $colAssignmentEventId INTEGER, '
          '$colAssignmentEventTitle TEXT, $colAssignmentEventDate TEXT, '
          '$colAssignmentMember TEXT, $colAssignmentRole TEXT, '
          '$colAssignmentResponsibility TEXT)');
    }

    if (oldVersion < 5) {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $teamMembershipTable($colMembershipTeamName TEXT PRIMARY KEY, '
          '$colMembershipIsJoined INTEGER DEFAULT 0)');
    }
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await this.database;
    var result = await db.insert(expenseTable, expense.toMap());
    return result;
  }

  Future<List<Expense>> getExpenseList() async {
    Database db = await this.database;
    var result = await db.query(expenseTable, orderBy: '$colDate DESC');
    List<Expense> expenseList =
        result.map((item) => Expense.fromMap(item)).toList();
    return expenseList;
  }

  Future<List<Expense>> getReservedExpenseList() async {
    Database db = await this.database;
    var result = await db.query(
      expenseTable,
      where: '$colIsReserved = ?',
      whereArgs: [1],
      orderBy: '$colDate DESC',
    );
    return result.map((item) => Expense.fromMap(item)).toList();
  }

  Future<int> markExpenseAsReserved(int id) async {
    Database db = await this.database;
    return await db.update(
      expenseTable,
      {colIsReserved: 1},
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> unmarkExpenseAsReserved(int id) async {
    Database db = await this.database;
    return await db.update(
      expenseTable,
      {colIsReserved: 0},
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    Database db = await this.database;
    return await db.delete(expenseTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<Set<int>> getCompletedMissionIds() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> result = await db.query(
      missionProgressTable,
      columns: [colMissionId],
      where: '$colIsCompleted = ?',
      whereArgs: [1],
    );

    return result.map((row) => row[colMissionId] as int).toSet();
  }

  Future<int?> getLinkedExpenseIdForMission(int missionId) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> result = await db.query(
      missionProgressTable,
      columns: [colLinkedExpenseId],
      where: '$colMissionId = ?',
      whereArgs: [missionId],
      limit: 1,
    );

    if (result.isEmpty || result.first[colLinkedExpenseId] == null) {
      return null;
    }
    return result.first[colLinkedExpenseId] as int;
  }

  Future<int?> getMissionIdByLinkedExpenseId(int linkedExpenseId) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> result = await db.query(
      missionProgressTable,
      columns: [colMissionId],
      where: '$colLinkedExpenseId = ?',
      whereArgs: [linkedExpenseId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }
    return result.first[colMissionId] as int;
  }

  Future<int> insertTeamAssignment({
    required String teamName,
    required int? eventId,
    required String eventTitle,
    required DateTime eventDate,
    required String member,
    required String role,
    required String responsibility,
  }) async {
    Database db = await database;
    return await db.insert(
      teamAssignmentTable,
      {
        colAssignmentTeamName: teamName,
        colAssignmentEventId: eventId,
        colAssignmentEventTitle: eventTitle,
        colAssignmentEventDate: eventDate.toIso8601String(),
        colAssignmentMember: member,
        colAssignmentRole: role,
        colAssignmentResponsibility: responsibility,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTeamAssignmentsByTeamName(
      String teamName) async {
    Database db = await database;
    return await db.query(
      teamAssignmentTable,
      where: '$colAssignmentTeamName = ?',
      whereArgs: [teamName],
      orderBy: '$colAssignmentId DESC',
    );
  }

  Future<int> deleteTeamAssignmentsByTeamName(String teamName) async {
    Database db = await database;
    return await db.delete(
      teamAssignmentTable,
      where: '$colAssignmentTeamName = ?',
      whereArgs: [teamName],
    );
  }

  Future<int> upsertTeamMembership({
    required String teamName,
    required bool isJoined,
  }) async {
    Database db = await database;
    return await db.insert(
      teamMembershipTable,
      {
        colMembershipTeamName: teamName,
        colMembershipIsJoined: isJoined ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, bool>> getAllTeamMemberships() async {
    Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(teamMembershipTable);
    final Map<String, bool> memberships = <String, bool>{};

    for (final Map<String, dynamic> row in rows) {
      final String? teamName = row[colMembershipTeamName] as String?;
      if (teamName == null) {
        continue;
      }
      memberships[teamName] = (row[colMembershipIsJoined] ?? 0) == 1;
    }

    return memberships;
  }

  Future<int> upsertMissionProgress({
    required int missionId,
    required bool isCompleted,
    int? linkedExpenseId,
  }) async {
    Database db = await this.database;
    return await db.insert(
      missionProgressTable,
      {
        colMissionId: missionId,
        colIsCompleted: isCompleted ? 1 : 0,
        colLinkedExpenseId: linkedExpenseId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> getTotalAmountSpentForCategory(
      String category, String startDate, String endDate) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT SUM($colAmount) AS total FROM $expenseTable WHERE $colCategory = ? AND $colDate BETWEEN ? AND ?',
        [category, startDate, endDate]);

    if (result.first['total'] == null) {
      return 0.0;
    }

    return result.first['total'] as double;
  }
}
