

class Expense {
  final String id; // Add an id property to uniquely identify each expense
  final String name;
  final int amount;
  final String date;
  final String detail;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.detail,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: map['date'],
      detail: map['detail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'detail': detail,
    };
  }
}
