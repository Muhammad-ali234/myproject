import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:myproject/Pump/Expense/Models/expense.dart';

class BarChartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //1. Fetching Total Meter Readings on a Monthly Basis for All Pumps
 Future<Map<String, Map<String, double>>> getTotalMeterReadingsForLast12Months() async {
  try {
    DateTime now = DateTime.now();
    Map<String, Map<String, double>> monthlyReadings = {};

    // Initialize months map
    for (int i = 0; i < 12; i++) {
      DateTime monthStart = DateTime(now.year, now.month - i, 1);
      String monthKey = DateFormat('MMMM').format(monthStart);
      monthlyReadings[monthKey] = {'petrol': 0.0, 'diesel': 0.0};
    }

    // Get all pump documents
    QuerySnapshot pumpSnapshot = await _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .get();

    for (var pumpDoc in pumpSnapshot.docs) {
      String pumpId = pumpDoc.id;

      for (int i = 0; i < 12; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        DateTime monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);
        String monthKey = DateFormat('MMMM').format(monthStart);

        QuerySnapshot meterReadingHistorySnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(pumpId)
            .collection('meter reading histry')
            .where('date', isGreaterThanOrEqualTo: monthStart)
            .where('date', isLessThanOrEqualTo: monthEnd)
            .get();

        for (var doc in meterReadingHistorySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          double litres = data['litres'] ?? 0.0; // Use 0.0 if 'litres' is null
          if (data.containsKey('type') && data['type'] == 'Petrol') {
            monthlyReadings[monthKey]!['petrol'] = (monthlyReadings[monthKey]!['petrol'] ?? 0) + litres;
          } else if (data.containsKey('type') && data['type'] == 'Diesel') {
            monthlyReadings[monthKey]!['diesel'] = (monthlyReadings[monthKey]!['diesel'] ?? 0) + litres;
          }
        }
      }
    }

    return monthlyReadings;
  } catch (e) {
    throw Exception('Failed to fetch total meter readings: $e');
  }
}


//2. Fetching Total Credit and Debit for Each Month for All Pumps
Future<Map<String, Map<String, double>>> getTotalCreditAndDebitForLast12Months() async {
  try {
    DateTime now = DateTime.now();
    Map<String, Map<String, double>> monthlyTransactions = {};

    // Initialize months map
    for (int i = 0; i < 12; i++) {
      DateTime monthStart = DateTime(now.year, now.month - i, 1);
      String monthKey = DateFormat('MMMM').format(monthStart);
      monthlyTransactions[monthKey] = {'totalCredit': 0.0, 'totalDebit': 0.0};
    }

    // Get all pump documents
    QuerySnapshot pumpSnapshot = await _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .get();

    for (var pumpDoc in pumpSnapshot.docs) {
      String pumpId = pumpDoc.id;

      for (int i = 0; i < 12; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        DateTime monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);
        String monthKey = DateFormat('MMMM').format(monthStart);

        QuerySnapshot<Map<String, dynamic>> customersSnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(pumpId)
            .collection('customer')
            .get();

        for (final customerDoc in customersSnapshot.docs) {
          final String customerId = customerDoc.id;

          QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
              .collection('users')
              .doc('Pump')
              .collection('Pump')
              .doc(pumpId)
              .collection('customer')
              .doc(customerId)
              .collection('transaction_history')
              .where('timestamp', isGreaterThanOrEqualTo: monthStart)
              .where('timestamp', isLessThanOrEqualTo: monthEnd)
              .get();

          for (final transactionDoc in querySnapshot.docs) {
            final transaction = transactionDoc.data();
            double amount = transaction['amount'] ?? 0.0; // Use 0.0 if 'amount' is null
            if (transaction['isCredit']) {
              monthlyTransactions[monthKey]!['totalCredit'] = (monthlyTransactions[monthKey]!['totalCredit'] ?? 0) + amount;
            } else {
              monthlyTransactions[monthKey]!['totalDebit'] = (monthlyTransactions[monthKey]!['totalDebit'] ?? 0) + amount;
            }
          }
        }
      }
    }

    return monthlyTransactions;
  } catch (e) {
    throw Exception('Failed to fetch transactions: $e');
  }
}


//3. Fetching Total Expense for Each Month for All Pumps
Future<Map<String, double>> fetchTotalExpenseForLast12Months() async {
  try {
    DateTime now = DateTime.now();
    Map<String, double> monthlyExpenses = {};

    // Initialize months map
    for (int i = 0; i < 12; i++) {
      DateTime monthStart = DateTime(now.year, now.month - i, 1);
      String monthKey = DateFormat('MMMM').format(monthStart);
      monthlyExpenses[monthKey] = 0.0;
    }

    // Get all pump documents
    QuerySnapshot pumpSnapshot = await _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .get();

    for (var pumpDoc in pumpSnapshot.docs) {
      String pumpId = pumpDoc.id;

      for (int i = 0; i < 12; i++) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        DateTime monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);
        String monthKey = DateFormat('MMMM').format(monthStart);

        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(pumpId)
            .collection('total_expense')
            .where('date', isGreaterThanOrEqualTo: monthStart)
            .where('date', isLessThanOrEqualTo: monthEnd)
            .get();

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          double expense = doc['total'] as double; // assuming 'total' is stored as a double
          monthlyExpenses[monthKey] =(monthlyExpenses![monthKey] ??0) + expense;
        }
      }
    }

    return monthlyExpenses;
  } catch (e) {
    print("Error fetching total expense: $e");
    rethrow;
  }
}


}


