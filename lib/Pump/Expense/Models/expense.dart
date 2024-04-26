// class Expense {
//   final String name;
//   final int amount;
//   final String date;
//   final String detail;

//   Expense({
//     required this.name,
//     required this.amount,
//     required this.date,
//     required this.detail,
//   });

//   factory Expense.fromMap(Map<String, dynamic> map) {
//     return Expense(
//       name: map['name'],
//       amount: map['amount'],
//       date: map['date'],
//       detail: map['detail'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'amount': amount,
//       'date': date,
//       'detail': detail,
//     };
//   }
// }

// // class Expense {
// //   String id; // Add an id property to uniquely identify each expense document
// //   String name;
// //   int amount;
// //   String date;
// //   String detail;

// //   Expense({
// //     required this.id, // Update the constructor to include the id parameter
// //     required this.name,
// //     required this.amount,
// //     required this.date,
// //     required this.detail,
// //   });

// //   // Factory constructor to create an Expense instance from a map
// //   factory Expense.fromMap(Map<String, dynamic> map) {
// //     return Expense(
// //       id: map['id'], // Populate the id property from the map
// //       name: map['name'],
// //       amount: map['amount'],
// //       date: map['date'],
// //       detail: map['detail'],
// //     );
// //   }

// //   // Method to convert Expense instance to a map
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id, // Include the id in the map when converting to map
// //       'name': name,
// //       'amount': amount,
// //       'date': date,
// //       'detail': detail,
// //     };
// //   }
// // }

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
