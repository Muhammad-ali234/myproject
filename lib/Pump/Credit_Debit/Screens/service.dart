import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';

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
            .collection('customer') // Assuming 'customer' is a subcollection
            .doc(customerId);

        DocumentSnapshot customerSnapshot = await customerRef.get();

        double currentDebit = customerSnapshot['debit'] ?? 0;
        double currentCredit = customerSnapshot['credit'] ?? 0;

        double newDebit = currentDebit;
        double newCredit = currentCredit;

        if (isCredit) {
          newCredit += amount;
        } else {
          newDebit += amount;
        }

        await customerRef.update({
          'debit': newDebit,
          'credit': newCredit,
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
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Method to get the current user's UID
  Future<String?> getCurrentUserUID() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }
}
