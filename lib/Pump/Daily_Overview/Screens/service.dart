import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class DailyOverviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Constructor
  DailyOverviewService() {
    _initListeners();
  }

  // Initialize all listeners
  Future<void> _initListeners() async {
    await _initExpenseListener();
    await _initCreditDebitListener();
    await _initPetrolDieselListener();
    await _initLoadDataListener();
  }

  Future<void> _initExpenseListener() async {
    String? uid = await _auth.getCurrentUserUID();
    if (uid == null) {
      throw Exception('User UID is null');
    }

    _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .collection('total_expense')
        .snapshots()
        .listen((querySnapshot) async {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          // Check if the change is for the current date
          Timestamp timestamp = change.doc['timestamp'];
          DateTime expenseDate = timestamp.toDate();
          DateTime now = DateTime.now();
          if (expenseDate.year == now.year &&
              expenseDate.month == now.month &&
              expenseDate.day == now.day) {
            await updateDailyAndMonthlyOverview();
          }
        }
      }
    });
  }

  // Real-time listener for credit and debit changes
  Future<void> _initCreditDebitListener() async {
    String? uid = await _auth.getCurrentUserUID();
    if (uid == null) {
      throw Exception('User UID is null');
    }

    // Get a reference to the customers collection
    CollectionReference customersRef = _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .collection('customer');

    // Fetch all customer documents
    QuerySnapshot customersSnapshot = await customersRef.get();

    // Set up listeners for each customer's transaction_history collection
    for (var customerDoc in customersSnapshot.docs) {
      String customerId = customerDoc.id;

      customersRef
          .doc(customerId)
          .collection('transaction_history')
          .snapshots()
          .listen((querySnapshot) async {
        for (var change in querySnapshot.docChanges) {
          if (change.type == DocumentChangeType.modified) {
            // Check if the change is for the current date
            Timestamp timestamp = change.doc['timestamp'];
            DateTime transactionDate = timestamp.toDate();
            DateTime now = DateTime.now();
            if (transactionDate.year == now.year &&
                transactionDate.month == now.month &&
                transactionDate.day == now.day) {
              // Handle credit and debit changes here
              await updateDailyAndMonthlyOverview();
            }
          }
        }
      });
    }
  }

  // Real-time listener for petrol and diesel changes
  Future<void> _initPetrolDieselListener() async {
    String? uid = await _auth.getCurrentUserUID();
    if (uid == null) {
      throw Exception('User UID is null');
    }

    _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .collection('meter reading histry')
        .snapshots()
        .listen((querySnapshot) async {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          // Check if the change is for the current date
          Timestamp timestamp = change.doc['timestamp'];
          DateTime readingDate = timestamp.toDate();
          DateTime now = DateTime.now();
          if (readingDate.year == now.year &&
              readingDate.month == now.month &&
              readingDate.day == now.day) {
            await updateDailyAndMonthlyOverview();
          }
        }
      }
    });
  }

  // Real-time listener for daily overview data changes
  Future<void> _initLoadDataListener() async {
    String? uid = await _auth.getCurrentUserUID();
    if (uid == null) {
      throw Exception('User UID is null');
    }

    _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .collection('daily_overview')
        .snapshots()
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          // Handle daily overview data changes here
          loadDataFromFirestore();
        }
      }
    });
  }

  Future<void> updateDailyAndMonthlyOverview() async {
    try {
      String? uid = await _auth.getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      String monthKey = "${now.year}-${now.month}";

      // Get today's data
      Map<String, double> meterReadings =
          await getTotalMeterReadingsOnCurrentDate();
      Map<String, double> creditDebit =
          await getTodaysTotalCreditAndDebitForAllCustomers();
      double totalExpense = await fetchTotalExpenseForToday();

      // Update daily overview
      DocumentReference dailyOverviewRef = _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('daily_overview')
          .doc(startOfDay.toIso8601String());

      await dailyOverviewRef.set({
        'date': startOfDay,
        'petrol': meterReadings['petrol'],
        'diesel': meterReadings['diesel'],
        'credit': creditDebit['totalCredit'],
        'debit': creditDebit['totalDebit'],
        'expense': totalExpense,
      });

      // Update monthly overview
      DocumentReference monthlyOverviewRef = _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('monthly_overview')
          .doc(monthKey);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot monthlySnapshot =
            await transaction.get(monthlyOverviewRef);

        if (!monthlySnapshot.exists) {
          transaction.set(monthlyOverviewRef, {
            'month': monthKey,
            'petrol': meterReadings['petrol'],
            'diesel': meterReadings['diesel'],
            'credit': creditDebit['totalCredit'],
            'debit': creditDebit['totalDebit'],
            'expense': totalExpense,
          });
        } else {
          transaction.update(monthlyOverviewRef, {
            'petrol': FieldValue.increment(meterReadings['petrol']!),
            'diesel': FieldValue.increment(meterReadings['diesel']!),
            'credit': FieldValue.increment(creditDebit['totalCredit']!),
            'debit': FieldValue.increment(creditDebit['totalDebit']!),
            'expense': FieldValue.increment(totalExpense),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to update daily and monthly overview: $e');
    }
  }

  Future<Map<String, dynamic>> loadDataFromFirestore() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      String? uid = await _auth.getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }

      // Reference to the Firestore collection
      CollectionReference dailyOverviewCollection = FirebaseFirestore.instance
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('daily_overview');

      // Reference to the specific document using its ID (startOfDay.toIso8601String())
      DocumentSnapshot documentSnapshot =
          await dailyOverviewCollection.doc(startOfDay.toIso8601String()).get();

      if (documentSnapshot.exists) {
        // Document exists, extract data
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          DateTime date =
              data['date'].toDate(); // Convert Firestore Timestamp to DateTime

          // Extract other fields
          double petrol = data['petrol'];
          double diesel = data['diesel'];
          double credit = data['credit'];
          double debit = data['debit'];
          double expense = data['expense'];

          // Now you can use the extracted data as needed
          print('Date: $date');
          print('Petrol: $petrol');
          print('Diesel: $diesel');
          print('Credit: $credit');
          print('Debit: $debit');
          print('Expense: $expense');

          // Return the extracted data
          return data;
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error loading data from Firestore: $e');
    }

    // If an error occurs or if the document does not exist, return an empty map
    return {};
  }

  Future<Map<String, double>> getTotalMeterReadingsOnCurrentDate() async {
    try {
      String? uid = await _auth.getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }

      // Get the current date
      DateTime now = DateTime.now();
      DateTime currentDate = DateTime(now.year, now.month, now.day);

      // Get the start of the current day (midnight)
      DateTime startOfDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      // Get the end of the current day (23:59:59)
      DateTime endOfDay = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

      // Path to the user's meter reading history collection
      QuerySnapshot meterReadingHistorySnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('meter reading histry')
          .where('date',
              isGreaterThanOrEqualTo: startOfDay) // Filter by current day start
          // Filter by current day end
          .get();

      // Initialize total petrol and diesel
      double totalPetrol = 0;
      double totalDiesel = 0;

      // Calculate total meter readings for petrol and diesel
      // Calculate total meter readings for petrol and diesel
      // Calculate total meter readings for petrol and diesel
      for (var doc in meterReadingHistorySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Document data: $data'); // Print the data of each document
        // Check if 'type' field exists and matches 'petrol' or 'diesel'
        if (data.containsKey('type') && data['type'] == 'Petrol') {
          totalPetrol += data['litres'];
        } else if (data.containsKey('type') && data['type'] == 'Diesel') {
          totalDiesel += data['litres'];
        }

        print('total petrol: $totalPetrol diesel: $totalDiesel');
      }

      return {'petrol': totalPetrol, 'diesel': totalDiesel};
    } catch (e) {
      throw Exception('Failed to fetch total meter readings: $e');
    }
  }

  Future<Map<String, double>>
      getTodaysTotalCreditAndDebitForAllCustomers() async {
    try {
      final String? uid = await _auth.getCurrentUserUID();
      if (uid == null) {
        throw Exception('User is not logged in');
      }

      // Get the current date range
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      final DateTime endOfDay =
          DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Fetch all customers
      QuerySnapshot<Map<String, dynamic>> customersSnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('customer')
          .get();

      double totalCredit = 0;
      double totalDebit = 0;

      for (final customerDoc in customersSnapshot.docs) {
        final String customerId = customerDoc.id;

        // Fetch transactions for today for the current customer
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .doc(customerId)
            .collection('transaction_history')
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('timestamp', isLessThanOrEqualTo: endOfDay)
            .get();

        for (final transactionDoc in querySnapshot.docs) {
          final transaction = transactionDoc.data();
          if (transaction['isCredit']) {
            totalCredit += transaction['amount'];
          } else {
            totalDebit += transaction['amount'];
          }
        }
      }

      print(totalDebit);
      print(totalCredit);

      return {
        'totalCredit': totalCredit,
        'totalDebit': totalDebit,
      };
    } catch (e) {
      throw Exception('Failed to fetch today\'s transactions: $e');
    }
  }

  Future<double> fetchTotalExpenseForToday() async {
    try {
      String? uid = await _auth.getCurrentUserUID();
      if (uid != null) {
        DateTime now = DateTime.now();

        final DateTime startOfDay = DateTime(now.year, now.month, now.day);
        final DateTime endOfDay =
            DateTime(now.year, now.month, now.day, 23, 59, 59);

        double totalExpenses = 0.0;

        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('total_expense')
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThanOrEqualTo: endOfDay)
            .get();

        if (snapshot.docs.isEmpty) {
          print("No expenses found for today.");
        } else {
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            print("Expense: ${doc['total']}, Date: ${doc['date']}");
            double expense = doc['total']
                as double; // assuming 'total' is stored as a double
            totalExpenses += expense;
          }
        }
        return totalExpenses;
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error fetching total expense: $e");
      rethrow;
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> getCurrentUserUID() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// class DailyOverviewService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuthService _auth = FirebaseAuthService();

//   // Constructor
//   DailyOverviewService() {
//     updateDailyAndMonthlyOverview();
//     // Initialize real-time listeners
//     _initExpenseListener();
//     _initCreditDebitListener();

//     _initPetrolDieselListener();
//   }

//   // Real-time listener for expense changes
//   void _initExpenseListener() async {
//     String? uid = await _auth.getCurrentUserUID();
//     if (uid == null) {
//       throw Exception('User UID is null');
//     }
//     _firestore
//         .collection('users')
//         .doc('Pump')
//         .collection('Pump')
//         .doc(uid)
//         .collection('total_expense')
//         .snapshots()
//         .listen((querySnapshot) {
//       for (var change in querySnapshot.docChanges) {
//         if (change.type == DocumentChangeType.modified) {
//           updateDailyAndMonthlyOverview();
//         }
//       }
//     });
//   }

//   // Real-time listener for credit and debit changes
//   void _initCreditDebitListener() async {
//     String? uid = await _auth.getCurrentUserUID();
//     if (uid == null) {
//       throw Exception('User UID is null');
//     }
//     _firestore
//         .collection('users')
//         .doc('Pump')
//         .collection('Pump')
//         .doc(uid)
//         .collection('customer')
//         .snapshots()
//         .listen((querySnapshot) {
//       for (var change in querySnapshot.docChanges) {
//         if (change.type == DocumentChangeType.modified) {
//           updateDailyAndMonthlyOverview();
//         }
//       }
//     });
//   }

//   // Real-time listener for petrol and diesel changes
//   void _initPetrolDieselListener() async {
//     String? uid = await _auth.getCurrentUserUID();
//     if (uid == null) {
//       throw Exception('User UID is null');
//     }
//     _firestore
//         .collection('users')
//         .doc('Pump')
//         .collection('Pump')
//         .doc(uid)
//         .collection('meter reading history')
//         .snapshots()
//         .listen((querySnapshot) {
//       for (var change in querySnapshot.docChanges) {
//         if (change.type == DocumentChangeType.modified) {
//           updateDailyAndMonthlyOverview();
//         }
//       }
//     });
//   }

//   Future<void> updateDailyAndMonthlyOverview() async {
//     try {
//       String? uid = await _auth.getCurrentUserUID();
//       if (uid == null) {
//         throw Exception('User UID is null');
//       }

//       DateTime now = DateTime.now();
//       DateTime startOfDay = DateTime(now.year, now.month, now.day);
//       DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//       String monthKey = "${now.year}-${now.month}";

//       // Get today's data
//       Map<String, double> meterReadings =
//           await getTotalMeterReadingsOnCurrentDate();
//       Map<String, double> creditDebit =
//           await getTodaysTotalCreditAndDebitForAllCustomers();
//       double totalExpense = await fetchTotalExpenseForToday();

//       // Check if daily overview document already exists for the current date
//       DocumentSnapshot dailyOverviewSnapshot = await _firestore
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .doc(uid)
//           .collection('daily_overview')
//           .doc(startOfDay.toIso8601String())
//           .get();

//       if (dailyOverviewSnapshot.exists) {
//         // Update existing document
//         await dailyOverviewSnapshot.reference.update({
//           'date': startOfDay,
//           'petrol': meterReadings['petrol'],
//           'diesel': meterReadings['diesel'],
//           'credit': creditDebit['totalCredit'],
//           'debit': creditDebit['totalDebit'],
//           'expense': totalExpense,
//         });
//       } else {
//         // Create new document
//         await _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('daily_overview')
//             .doc(startOfDay.toIso8601String())
//             .set({
//           'date': startOfDay,
//           'petrol': meterReadings['petrol'],
//           'diesel': meterReadings['diesel'],
//           'credit': creditDebit['totalCredit'],
//           'debit': creditDebit['totalDebit'],
//           'expense': totalExpense,
//         });
//       }

//       // Update monthly overview
//       DocumentReference monthlyOverviewRef = _firestore
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .doc(uid)
//           .collection('monthly_overview')
//           .doc(monthKey);

//       await _firestore.runTransaction((transaction) async {
//         DocumentSnapshot monthlySnapshot =
//             await transaction.get(monthlyOverviewRef);

//         if (!monthlySnapshot.exists) {
//           transaction.set(monthlyOverviewRef, {
//             'month': monthKey,
//             'petrol': meterReadings['petrol'],
//             'diesel': meterReadings['diesel'],
//             'credit': creditDebit['totalCredit'],
//             'debit': creditDebit['totalDebit'],
//             'expense': totalExpense,
//           });
//         } else {
//           transaction.update(monthlyOverviewRef, {
//             'petrol': FieldValue.increment(meterReadings['petrol']!),
//             'diesel': FieldValue.increment(meterReadings['diesel']!),
//             'credit': FieldValue.increment(creditDebit['totalCredit']!),
//             'debit': FieldValue.increment(creditDebit['totalDebit']!),
//             'expense': FieldValue.increment(totalExpense),
//           });
//         }
//       });
//     } catch (e) {
//       throw Exception('Failed to update daily and monthly overview: $e');
//     }
//   }

//   Future<Map<String, dynamic>> loadDataFromFirestore() async {
//     try {
//       DateTime now = DateTime.now();
//       DateTime startOfDay = DateTime(now.year, now.month, now.day);

//       String? uid = await _auth.getCurrentUserUID();
//       if (uid == null) {
//         throw Exception('User UID is null');
//       }

//       // Reference to the Firestore collection
//       CollectionReference dailyOverviewCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .doc(uid)
//           .collection('daily_overview');

//       // Reference to the specific document using its ID (startOfDay.toIso8601String())
//       DocumentSnapshot documentSnapshot =
//           await dailyOverviewCollection.doc(startOfDay.toIso8601String()).get();

//       if (documentSnapshot.exists) {
//         // Document exists, extract data
//         Map<String, dynamic>? data =
//             documentSnapshot.data() as Map<String, dynamic>?;

//         if (data != null) {
//           DateTime date =
//               data['date'].toDate(); // Convert Firestore Timestamp to DateTime

//           // Extract other fields
//           double petrol = data['petrol'];
//           double diesel = data['diesel'];
//           double credit = data['credit'];
//           double debit = data['debit'];
//           double expense = data['expense'];

//           // Now you can use the extracted data as needed
//           print('Date: $date');
//           print('Petrol: $petrol');
//           print('Diesel: $diesel');
//           print('Credit: $credit');
//           print('Debit: $debit');
//           print('Expense: $expense');

//           // Return the extracted data
//           return data;
//         }
//       } else {
//         print('Document does not exist');
//       }
//     } catch (e) {
//       print('Error loading data from Firestore: $e');
//     }

//     // If an error occurs or if the document does not exist, return an empty map
//     return {};
//   }

//   Future<Map<String, double>> getTotalMeterReadingsOnCurrentDate() async {
//     try {
//       String? uid = await _auth.getCurrentUserUID();
//       if (uid == null) {
//         throw Exception('User UID is null');
//       }

//       // Get the current date
//       DateTime now = DateTime.now();
//       DateTime currentDate = DateTime(now.year, now.month, now.day);

//       // Get the start of the current day (midnight)
//       DateTime startOfDay =
//           DateTime(currentDate.year, currentDate.month, currentDate.day);

//       // Get the end of the current day (23:59:59)
//       DateTime endOfDay = DateTime(
//           currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

//       // Path to the user's meter reading history collection
//       QuerySnapshot meterReadingHistorySnapshot = await _firestore
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .doc(uid)
//           .collection('meter reading histry')
//           .where('date',
//               isGreaterThanOrEqualTo: startOfDay) // Filter by current day start
//           // Filter by current day end
//           .get();

//       // Initialize total petrol and diesel
//       double totalPetrol = 0;
//       double totalDiesel = 0;

//       // Calculate total meter readings for petrol and diesel
//       for (var doc in meterReadingHistorySnapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         // Check if 'type' field exists and matches 'petrol' or 'diesel'
//         //   if (data.containsKey('type') && data['type'] == '
//         // Check if 'type' field exists and matches 'petrol' or 'diesel'
//         if (data.containsKey('type') && data['type'] == 'Petrol') {
//           totalPetrol += data['litres'];
//         } else if (data.containsKey('type') && data['type'] == 'Diesel') {
//           totalDiesel += data['litres'];
//         }
//       }

//       return {'petrol': totalPetrol, 'diesel': totalDiesel};
//     } catch (e) {
//       throw Exception('Failed to fetch total meter readings: $e');
//     }
//   }

//   Future<Map<String, double>>
//       getTodaysTotalCreditAndDebitForAllCustomers() async {
//     try {
//       final String? uid = await _auth.getCurrentUserUID();
//       if (uid == null) {
//         throw Exception('User is not logged in');
//       }

//       // Get the current date range
//       final DateTime now = DateTime.now();
//       final DateTime startOfDay = DateTime(now.year, now.month, now.day);
//       final DateTime endOfDay =
//           DateTime(now.year, now.month, now.day, 23, 59, 59);

//       // Fetch all customers
//       QuerySnapshot<Map<String, dynamic>> customersSnapshot = await _firestore
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .doc(uid)
//           .collection('customer')
//           .get();

//       double totalCredit = 0;
//       double totalDebit = 0;

//       for (final customerDoc in customersSnapshot.docs) {
//         final String customerId = customerDoc.id;

//         // Fetch transactions for today for the current customer
//         QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('customer')
//             .doc(customerId)
//             .collection('transaction_history')
//             .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
//             .where('timestamp', isLessThanOrEqualTo: endOfDay)
//             .get();

//         for (final transactionDoc in querySnapshot.docs) {
//           final transaction = transactionDoc.data();
//           if (transaction['isCredit']) {
//             totalCredit += transaction['amount'];
//           } else {
//             totalDebit += transaction['amount'];
//           }
//         }
//       }

//       return {
//         'totalCredit': totalCredit,
//         'totalDebit': totalDebit,
//       };
//     } catch (e) {
//       throw Exception('Failed to fetch today\'s transactions: $e');
//     }
//   }

//   Future<double> fetchTotalExpenseForToday() async {
//     try {
//       String? uid = await _auth.getCurrentUserUID();
//       if (uid != null) {
//         DateTime now = DateTime.now();

//         final DateTime startOfDay = DateTime(now.year, now.month, now.day);
//         final DateTime endOfDay =
//             DateTime(now.year, now.month, now.day, 23, 59, 59);

//         double totalExpenses = 0.0;

//         QuerySnapshot snapshot = await _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('total_expense')
//             .where('date', isGreaterThanOrEqualTo: startOfDay)
//             .where('date', isLessThanOrEqualTo: endOfDay)
//             .get();

//         if (snapshot.docs.isEmpty) {
//           print("No expenses found for today.");
//         } else {
//           for (QueryDocumentSnapshot doc in snapshot.docs) {
//             print("Expense: ${doc['total']}, Date: ${doc['date']}");
//             double expense = doc['total']
//                 as double; // assuming 'total' is stored as a double
//             totalExpenses += expense;
//           }
//         }
//         return totalExpenses;
//       } else {
//         throw Exception('User is not logged in!');
//       }
//     } catch (e) {
//       print("Error fetching total expense: $e");
//       rethrow;
//     }
//   }
// }

// class FirebaseAuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<String?> getCurrentUserUID() async {
//     final User? user = _firebaseAuth.currentUser;
//     return user?.uid;
//   }
// }
