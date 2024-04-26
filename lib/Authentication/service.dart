import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerOwner(String uid, String email, String contact) {
    return _firestore
        .collection('users')
        .doc('Owner')
        .collection('Owner')
        .doc(uid)
        .set({
      'uid': uid,
      'email': email,
      'contact': contact,
    });
  }

  Future<void> registerPump(
      String uid, String email, String contact, String ownerEmail) {
    return _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .set({
      'uid': uid,
      'email': email,
      'contact': contact,
      'ownerEmail': ownerEmail,
      'status': 'unconfirmed',
    });
  }

  Future<void> confirmAccount(String uid) async {
    await _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .set({'status': 'confirmed'});
  }

  Stream<List<DocumentSnapshot>> getUnconfirmedAccounts() {
    return _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .where('status', isEqualTo: 'unconfirmed')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<DocumentSnapshot> getUserData(String collection, String uid) {
    return _firestore
        .collection('users')
        .doc(collection)
        .collection(collection)
        .doc(uid)
        .get();
  }
}
