class Expense {
  int? id;
  double amount;
  DateTime date;
  String category;
  String notes;
  bool isReserved;

  // Constructor used by controllers before database insert and after reads.
  // Default isReserved=false means a new event is not RSVP'd until toggled.
  Expense({
    this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
    this.isReserved = false,
  });

  // Converts model data into a DB-friendly map for insert/update operations.
  // Key details:
  // - date becomes ISO text so SQLite can store it safely as TEXT.
  // - isReserved is normalized to int for SQLite compatibility.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'notes': notes,
      'is_reserved': isReserved ? 1 : 0,
    };
  }

  // Rebuilds an Expense model from a SQLite query row.
  // Key details:
  // - date string is parsed back into DateTime.
  // - missing/null is_reserved defaults to false for backward compatibility.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      notes: map['notes'],
      isReserved: (map['is_reserved'] ?? 0) == 1,
    );
  }
}
