import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EmployeeDutyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? uid;

  // Initialize UID during service instantiation
  EmployeeDutyService() {
    _initializeUID();
  }

  // Asynchronous method to initialize UID
  Future<void> _initializeUID() async {
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      print("User UID initialized: $uid");
    } else {
      throw Exception("User not authenticated");
    }
  }

  // Method to get employees stream with proper error handling
  Stream<QuerySnapshot> getEmployeesStream() {
    if (uid == null) {
      throw Exception("UID not initialized");
    }

    return _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid) // Validate this UID
        .collection('employees') // Ensure correct subcollection
        .snapshots();
  }

  // Method to handle errors and return custom error message
  Future<void> testFirestoreConnection() async {
    try {
      // Attempt to fetch a test document to ensure Firestore is accessible
      await _firestore.collection('test').doc('connectionTest').get();
      print("Firestore connection successful");
    } catch (e) {
      throw Exception("Failed to connect to Firestore: $e");
    }
  }

  // Utility method to handle common Firestore errors
  String handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return "Permission denied. Check Firestore security rules.";
        default:
          return "Firestore error: ${error.message}";
      }
    }
    return "Unexpected error: $error";
  }
}
