class Expense {
  int? id;
  double amount;
  DateTime date;
  String category;
  String notes;
  bool isReserved;

  Expense({
    this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
    this.isReserved = false,
  });

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
