class Budget {
  int? id;
  String category;
  double amount;
  DateTime startDate;
  DateTime endDate;

  Budget({this.id, required this.category, required this.amount, required this.startDate, required this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }
}
