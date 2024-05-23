// ignore_for_file: non_constant_identifier_names

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

  Future<void> registerOwner(
      String uid, String email, String contact, String name) {
    return _firestore
        .collection('users')
        .doc('Owner')
        .collection('Owner')
        .doc(uid)
        .set({
      'uid': uid,
      'name': name,
      'email': email,
      'contact': contact,
    });
  }

  Future<void> registerPump(
      {required String uid,
      required String email,
      required String contact,
      required String ownerEmail,
      required String name}) {
    return _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(uid)
        .set({
      'uid': uid,
      'name': name,
      'email': email,
      'contact': contact,
      'ownerEmail': ownerEmail,
      'status': 'unconfirmed',
    });
  }

  Future pumpregistrationFromAdmin(
      {required String uid,
      required String email,
      required String contact,
      required String ownerEmail,
      required String name}) {
    return _firestore.collection('pumps_registration').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'contact': contact,
      'ownerEmail': ownerEmail,
      'status': 'pending',
    });
  }

  Future<void> confirmAccount(String uid) async {
    await _firestore
        .collection('pumps_registration')
        .doc(uid)
        .update({'status': 'confirmed'});
  }

  Future<void> cancelAccount(String uid) async {
    await _firestore
        .collection('pumps_registration')
        .doc(uid)
        .update({'status': 'un_confirmed'});
  }

  Stream<List<DocumentSnapshot>> getUnconfirmedAccounts({required String uid}) {
    return _firestore
        .collection('pumps_registration')
        .where('status', isEqualTo: 'pending')
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