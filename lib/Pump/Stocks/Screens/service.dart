import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String?> getCurrentUserUID() async {
    return _authService.getCurrentUserUID();
  }

  Future<String> addStockData({
    required String type,
    required Timestamp date,
    required double litres,
  }) async {
    try {
      String? uid = await getCurrentUserUID(); // Get the current user's UID
      if (uid != null) {
        // Use the type as the document ID to separate petrol and diesel documents

        DocumentReference docRef = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('stock')
            .doc(type.toLowerCase()); // Use the type as document ID
        await docRef.set({
          'type': type,
          'litres': litres,
          'date': date,
        }, SetOptions(merge: true)); // Use merge option to update existing data
        return docRef.id; // Return the document ID
      } else {
        throw Exception('User is not logged in!');
      }
    } catch (e) {
      throw Exception('Failed to add stock data: $e');
    }
  }

  Future<void> addStockHistry({
    required String type,
    required Timestamp date,
    required double litres,
  }) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        CollectionReference stockCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('stock histry');

        // Use a unique document ID for each stock history entry
        DocumentReference docRef = stockCollection.doc();

        // Set the data for the stock history entry
        await docRef.set(
          {
            'type': type,
            'litres': litres,
            'date': date,
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to add stock data: $e');
    }
  }

  // New method for adding meter reading data
  Future<void> addMeterReading({
    required String type,
    required Timestamp date,
    required double litres,
  }) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        DocumentReference meterReadingDoc = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('meter reading')
            .doc(type.toLowerCase()); // Fixed document name

        // Set the data for the meter reading entry
        await meterReadingDoc.set(
          {
            'type': type,
            'litres': litres,
            'date': date,
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to add meter reading data: $e');
    }
  }

  Future<void> addMeterReadingHistry({
    required String type,
    required Timestamp date,
    required double litres,
  }) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        CollectionReference stockCollection = _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('meter reading histry');

        // Use a unique document ID for each stock history entry
        DocumentReference docRef = stockCollection.doc();

        // Set the data for the stock history entry
        await docRef.set(
          {
            'type': type,
            'litres': litres,
            'date': date,
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to add meter reading histry data: $e');
    }
  }

  Future<Map<String, double>> fetchStockData() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid != null) {
        // Get petrol stock amount
        DocumentSnapshot petrolSnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('stock')
            .doc('petrol')
            .get();
        DocumentSnapshot dieselSnapshot = await _firestore
            .collection('users')
            .doc('Pump')
            .collection('Pump')
            .doc(uid)
            .collection('stock')
            .doc('diesel')
            .get();

        double petrolStock =
            petrolSnapshot.exists ? petrolSnapshot['litres'] : 0.0;
        double dieselStock =
            dieselSnapshot.exists ? dieselSnapshot['litres'] : 0.0;

        return {'petrol': petrolStock, 'diesel': dieselStock};
      }
      // Throw an exception if the UID is null
      throw Exception('User UID is null');
    } catch (e) {
      throw Exception('Failed to fetch stock data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchStockHistory() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }

      // Path to the user's stock history collection
      QuerySnapshot stockHistorySnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('stock histry')
          .get();

      // Convert the QuerySnapshot to a List of Maps for easier use in Flutter widgets
      List<Map<String, dynamic>> stockHistory = stockHistorySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return stockHistory;
    } catch (e) {
      throw Exception('Failed to fetch stock history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMeterReadingHistory() async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }

      // Path to the user's stock history collection
      QuerySnapshot stockHistorySnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('meter reading histry')
          .get();

      // Convert the QuerySnapshot to a List of Maps for easier use in Flutter widgets
      List<Map<String, dynamic>> stockHistory = stockHistorySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return stockHistory;
    } catch (e) {
      throw Exception('Failed to fetch meter history: $e');
    }
  }

  Future<double?> getPreviousMeterReading(String fuelType) async {
    try {
      String? uid = await getCurrentUserUID();
      if (uid == null) {
        throw Exception('User UID is null');
      }
      // Query the previous meter reading for the specified fuel type
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(uid)
          .collection('meter reading')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If documents are found, get the first document (latest reading)
        var documentSnapshot = querySnapshot.docs.first;

        // Cast the data to Map<String, dynamic>
        var data = documentSnapshot.data() as Map<String, dynamic>;

        // Extract and return the previous reading
        return data['litres'] ?? 0.0;
      } else {
        // If no previous reading is found, return null
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching previous meter reading: $e');
      return null;
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
