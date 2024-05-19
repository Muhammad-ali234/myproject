import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/Pump/Expense/Models/expense.dart'; // Import the Expense class

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String?> getCurrentUserUID() async {
    return _authService.getCurrentUserUID();
  }

  Future<void> addExpense(Expense expense, String expenseId) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        CollectionReference expenseCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('expenses');
        await expenseCollection.doc().set(expense.toMap());
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error adding expense: $e");
      rethrow;
    }
  }

  Future<int> getTotalExpense() async {
    try {
      // Fetch total expenses from Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc('total_expense')
          .get();

      return snapshot.exists
          ? (snapshot.data() as Map<String, dynamic>)['total'] ?? 0
          : 0;
    } catch (e) {
      print("Error fetching total expense: $e");
      rethrow;
    }
  }

  // Future<void> saveTotalExpense(int totalExpense) async {
  //   try {
  //     String? uid = await getCurrentUserUID();
  //     if (uid != null) {
  //       await _firestore
  //           .collection('users')
  //           .doc('Pump')
  //           .collection('Pump')
  //           .doc(uid)
  //           .collection('total_expense')
  //           .doc('total')
  //           .set({
  //         'total': totalExpense,
  //         'date': DateTime.now(), // Save the current date and time
  //       });
  //     } else {
  //       throw Exception('User is not logged in!');
  //     }
  //   } catch (e) {
  //     print("Error saving total expense: $e");
  //     rethrow;
  //   }
  // }

  Future<void> saveTotalExpense(int totalExpense) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('total_expense')
            .add({
          'total': totalExpense,
          'date': DateTime.now(), // Save the current date and time
        });
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error saving total expense: $e");
      rethrow;
    }
  }

  Future<List<Expense>> fetchExpenses() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('expenses')
            .get();
        return querySnapshot.docs
            .map((doc) => Expense.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error fetching expenses: $e");
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('expenses')
            .doc(expenseId) // Use the expenseId parameter
            .delete();
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error deleting expense: $e");
      rethrow;
    }
  }

  Future<void> updateExpense(
    String expenseId,
    Expense updatedExpense,
  ) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('expenses')
            .doc(expenseId)
            .update(updatedExpense.toMap());
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      print("Error updating expense: $e");
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
