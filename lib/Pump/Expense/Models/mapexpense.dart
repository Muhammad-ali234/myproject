class Expense {
  String name;
  int amount;
  String date;
  String detail;

  Expense(
      {required this.name,
      required this.amount,
      required this.date,
      required this.detail});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date,
      'detail': detail,
    };
  }
}
