import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add an employee to a specific pump's subcollection
  Future<String> addEmployeeToPump(
      Map<String, dynamic> employeeData, String pumpName) async {
    try {
      // Query the Firestore collection for a pump with the given name
      var pumpQuery = await _firestore
          .collection('users') // Primary collection
          .doc('Pump') // Document ID (ensure this is correct)
          .collection('Pump') // Subcollection
          .where('email', isEqualTo: pumpName) // Query by pump name
          .get(); // Execute the query

      if (pumpQuery.docs.isEmpty) {
        // If no pump is found, return an appropriate message
        return "Pump '$pumpName' not found";
      }

      // Get the UID of the first matching pump
      String pumpUID = pumpQuery.docs.first.id;

      // Add the employee to the specified pump's subcollection
      await _firestore
          .collection('users') // Main collection
          .doc('Pump') // Main document
          .collection('Pump') // Subcollection
          .doc(pumpUID) // Use the pump's UID
          .collection('employees') // Subcollection for employees
          .add(employeeData); // Add employee data

      return "Employee added to pump '$pumpName'";
    } catch (error) {
      // If there's an error, return an error message
      return "Error adding employee to pump '$pumpName': $error";
    }
  }

//   // Stream to fetch registered employees
//  Stream<QuerySnapshot> getRegisteredEmployeesStream(String selectedPump) {
//     return _firestore
//         .collection('users') // Top-level collection
//         .doc('Pump') // Main document within the top-level collection
//         .collection('Pump') // Subcollection within 'Pump'
//         .where('pump', isEqualTo: selectedPump) // Filter by 'selectedPump'
//         .collection('employees') // Subcollection to get employees
//         .snapshots(); // Return the Stream of QuerySnapshot
//   }

  Future<DocumentReference> getPumpDocumentByEmail(String email) async {
    var querySnapshot = await _firestore
        .collection('users')
        .doc('Pump') // Main document within 'users'
        .collection('Pump') // Subcollection within 'Pump'
        .where('email', isEqualTo: email) // Filter based on email
        .get(); // Execute the query to get the snapshot

    if (querySnapshot.docs.isEmpty) {
      throw Exception("No Pump found with the specified email.");
    }

    return querySnapshot.docs.first.reference; // Return the DocumentReference
  }

  Stream<QuerySnapshot> getEmployeesStream(DocumentReference pumpDocument) {
    return pumpDocument
        .collection('employees') // Navigate to the 'employees' subcollection
        .snapshots(); // Return the Stream of the QuerySnapshot
  }

  // Fetch list of pumps from Firestore
  Stream<List<String>> getRegisteredPumpsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc['email'] as String)
          .toList(); // Map to a list of pump names
    });
  }

  Future<void> setEmployeeDutyTiming(
      String employeeId,
      DateTime startDateTime,
      DateTime endDateTime,
      String additionalParameter,
      DocumentReference
          pumpDocument // This might be the extra argument expected
      ) async {
    await pumpDocument.collection('employees').doc(employeeId).update({
      'duty_start': startDateTime,
      'duty_end': endDateTime,
      'additional_field': additionalParameter, // Save additional parameter
    });
  }

  // Function to delete an employee based on ID
  Future<void> deleteEmployee(
      String employeeId, DocumentReference pumpDocument) async {
    try {
      await pumpDocument
          .collection('employees') // Navigate to the 'employees' subcollection
          .doc(employeeId) // Select the specific employee document
          .delete(); // Delete the document
    } catch (e) {
      throw Exception("Error deleting employee: ${e.toString()}");
    }
  }

  addEmployee(Map<String, Object> employeeData, String s) {}
}
