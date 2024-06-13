// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myproject/Pump/Customer/customer_data.dart';

// class CustomerService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuthService _authService = FirebaseAuthService();

//   Future<void> addCustomer(Customer customer) async {
//     try {
//       final uid = await _authService.getCurrentUserUID();
//       if (uid != null) {
//         CollectionReference customerCollection = _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('customer');

//         await customerCollection
//             .doc(customer.id)
//             .set(customer.toMap()); // Add customer data to Firestore
//       } else {
//         throw Exception("User UID is null");
//       }
//     } catch (error) {
//       throw Exception("Failed to add customer: $error");
//     }
//   }

//   Future<void> updateCustomer(Customer customer) async {
//     try {
//       final uid = await _authService.getCurrentUserUID();
//       if (uid != null) {
//         CollectionReference customerCollection = _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('customer');

//         await customerCollection
//             .doc(customer.id)
//             .update(customer.toMap()); // Update customer data in Firestore
//       } else {
//         throw Exception("User UID is null");
//       }
//     } catch (error) {
//       throw Exception("Failed to update customer: $error");
//     }
//   }

//   Future<void> deleteCustomer(String customerId) async {
//     try {
//       final uid = await _authService.getCurrentUserUID();
//       if (uid != null) {
//         CollectionReference customerCollection = _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('customer');

//         await customerCollection
//             .doc(customerId)
//             .delete(); // Delete customer from Firestore
//       } else {
//         throw Exception("User UID is null");
//       }
//     } catch (error) {
//       throw Exception("Failed to delete customer: $error");
//     }
//   }

//   Future<List<Customer>> getCustomers() async {
//     try {
//       final uid = await _authService.getCurrentUserUID();
//       if (uid != null) {
//         QuerySnapshot snapshot = await _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(uid)
//             .collection('customer')
//             .get();

//         List<Customer> customers = [];
//         for (var doc in snapshot.docs) {
//           // Cast doc.data() to Map<String, dynamic>
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           customers.add(Customer.fromMap(data));
//         }
//         return customers;
//       } else {
//         throw Exception("User UID is null");
//       }
//     } catch (error) {
//       throw Exception("Failed to fetch customers: $error");
//     }
//   }
// }

// class FirebaseAuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   // Method to get the current user's UID
//   Future<String?> getCurrentUserUID() async {
//     final User? user = _firebaseAuth.currentUser;
//     return user?.uid;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> addCustomer(Customer customer) async {
    try {
      final uid = await _authService.getCurrentUserUID();
      if (uid != null) {
        CollectionReference customerCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer');

        await customerCollection
            .doc(customer.id)
            .set(customer.toMap()); // Add customer data to Firestore
      } else {
        throw Exception("User UID is null");
      }
    } catch (error) {
      throw Exception("Failed to add customer: $error");
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      final uid = await _authService.getCurrentUserUID();
      if (uid != null) {
        CollectionReference customerCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer');

        await customerCollection
            .doc(customer.id)
            .update(customer.toMap()); // Update customer data in Firestore
      } else {
        throw Exception("User UID is null");
      }
    } catch (error) {
      throw Exception("Failed to update customer: $error");
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      final uid = await _authService.getCurrentUserUID();
      if (uid != null) {
        CollectionReference customerCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer');

        await customerCollection
            .doc(customerId)
            .delete(); // Delete customer from Firestore
      } else {
        throw Exception("User UID is null");
      }
    } catch (error) {
      throw Exception("Failed to delete customer: $error");
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      final uid = await _authService.getCurrentUserUID();
      if (uid != null) {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('customer')
            .get();

        List<Customer> customers = [];
        for (var doc in snapshot.docs) {
          // Cast doc.data() to Map<String, dynamic> and handle potential null values
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          customers.add(Customer.fromMap(data));
        }
        return customers;
      } else {
        throw Exception("User UID is null");
      }
    } catch (error) {
      throw Exception("Failed to fetch customers: $error");
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
