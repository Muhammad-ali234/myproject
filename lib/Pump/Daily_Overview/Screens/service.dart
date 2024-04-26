import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getAllCustomersTransactionHistory() async {
    try {
      final String? uid = await FirebaseAuthService().getCurrentUserUID();
      if (uid != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .get();

        // Calculate total credits and total debits for all customers
        double totalCredit = 0.0;
        double totalDebit = 0.0;
        List<Map<String, dynamic>> allTransactionHistory = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          String customerId = document.id;
          QuerySnapshot<Map<String, dynamic>> customerTransactionsSnapshot =
              await _firestore
                  .collection('users')
                  .doc('Pump')
                  .collection('Pump')
                  .doc(uid)
                  .collection('customer')
                  .doc(customerId)
                  .collection('transaction_history')
                  .orderBy('timestamp', descending: true)
                  .get();

          List<Map<String, dynamic>> customerTransactionHistory =
              customerTransactionsSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            if (data['isCredit'] == true) {
              totalCredit += (data['amount'] ?? 0.0);
            } else {
              totalDebit += (data['amount'] ?? 0.0);
            }
            return data;
          }).toList();

          allTransactionHistory.addAll(customerTransactionHistory);
        }

        // Return transaction history with totals
        return {
          'transactionHistory': allTransactionHistory,
          'totalCredit': totalCredit,
          'totalDebit': totalDebit,
        };
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction history: $e');
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
