import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:myproject/Pump/Expense/Models/expense.dart';

class DailyOverviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

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
