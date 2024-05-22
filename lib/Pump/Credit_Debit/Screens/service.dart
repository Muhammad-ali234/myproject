import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/Pump/Credit_Debit/Widgets/widget_path_selection.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CreditDebitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateCustomerTransaction(
      String customerId, double amount, bool isCredit) async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid != null) {
        DocumentReference customerRef = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .doc(customerId);

        DocumentSnapshot customerSnapshot = await customerRef.get();

        double currentCredit = customerSnapshot['credit'] ?? 0;

        if (isCredit) {
          currentCredit += amount;
        } else {
          currentCredit -= amount;
        }

        await customerRef.update({
          'credit': currentCredit,
        });
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> addTransactionToHistory(
      String customerId, double amount, bool isCredit) async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid != null) {
        CollectionReference historyRef = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .doc(customerId)
            .collection('transaction_history');

        await historyRef.add({
          'amount': amount,
          'isCredit': isCredit,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Failed to add transaction to history: $e');
    }
  }

  Future<void> TransactionToHistory(
      String customerId, double amount, bool isCredit) async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid != null) {
        CollectionReference historyRef = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('transaction_history');

        await historyRef.add({
          'amount': amount,
          'isCredit': isCredit,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Failed to add transaction to history: $e');
    }
  }

  Future<String?> getCustomerName(String customerId) async {
    final String? uid = await FirebaseAuthService().getCurrentUserUID();
    if (uid != null) {
      DocumentReference customerRef = _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('customer')
          .doc(customerId);

      DocumentSnapshot customerSnapshot = await customerRef.get();
      return customerSnapshot['name'];
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory(
      String customerId) async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .doc(customerId)
            .collection('transaction_history')
            .orderBy('timestamp', descending: true)
            .get();

        return querySnapshot.docs.map((doc) => doc.data()).toList();
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction history: $e');
    }
  }

  Future<File?> generatePDF(String customerId, BuildContext context) async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid == null) {
        throw Exception('User is not logged in');
      }

      final String? customerName = await getCustomerName(customerId);
      if (customerName == null) {
        throw Exception('Customer not found');
      }

      List<Map<String, dynamic>> transactionHistory =
          await getTransactionHistory(customerId);

      String? selectedPath = await showDialog<String?>(
        context: context,
        builder: (context) => const PathSelectorPopup(),
      );

      if (selectedPath == null) {
        return null;
      }

      final pdf = pw.Document();
      double totalCredit = 0;
      double totalDebit = 0;

      for (final transaction in transactionHistory) {
        if (transaction['isCredit']) {
          totalCredit += transaction['amount'];
        } else {
          totalDebit += transaction['amount'];
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('Transaction History for Customer $customerName',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Table.fromTextArray(
                headers: ['Date', 'Type', 'Amount'],
                data: transactionHistory.map((transaction) {
                  return [
                    transaction['timestamp']?.toDate().toString() ??
                        'Unknown Date',
                    transaction['isCredit'] ? 'Credit' : 'Debit',
                    '\$${transaction['amount']}',
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellPadding: const pw.EdgeInsets.all(8),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Summary',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Total Credit: \$${totalCredit.toStringAsFixed(2)}'),
              pw.Text('Total Debit: \$${totalDebit.toStringAsFixed(2)}'),
            ];
          },
        ),
      );

      final File file =
          File('$selectedPath/customer_${customerId}_transaction_history.pdf');
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      print("Failed to generate PDF: $e");
      throw Exception('Failed to generate PDF: $e');
    }
  }

  Future<Uint8List> generatePDFForWeb(
      String customerId, BuildContext context, PdfPageFormat format) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User is not logged in');
      }

      final String? customerName = await getCustomerName(customerId);
      if (customerName == null) {
        throw Exception('Customer not found');
      }

      List<Map<String, dynamic>> transactionHistory =
          await getTransactionHistory(customerId);

      double totalCredit = 0;
      double totalDebit = 0;

      for (final transaction in transactionHistory) {
        if (transaction['isCredit']) {
          totalCredit += transaction['amount'];
        } else {
          totalDebit += transaction['amount'];
        }
      }

      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('Transaction History for Customer $customerName',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Table.fromTextArray(
                headers: ['Date', 'Type', 'Amount'],
                data: transactionHistory.map((transaction) {
                  return [
                    transaction['timestamp']?.toDate().toString() ??
                        'Unknown Date',
                    transaction['isCredit'] ? 'Credit' : 'Debit',
                    '\$${transaction['amount']}',
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellPadding: const pw.EdgeInsets.all(8),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Summary',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Total Credit: \$${totalCredit.toStringAsFixed(2)}'),
              pw.Text('Total Debit: \$${totalDebit.toStringAsFixed(2)}'),
            ];
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      print("Failed to generate PDF: $e");
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Method to get the current user's UID
  Future<String?> getCurrentUserUID() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }
}
