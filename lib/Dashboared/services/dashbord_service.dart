import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboredService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all pumps from the Firestore collection 'pumps'
  Stream<QuerySnapshot> getPumpStream() {
    // You can add security to ensure the stream is only accessible to authenticated users
    return _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .snapshots();
  }
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user ID
  Future<String?> getCurrentUserUID() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }
}
