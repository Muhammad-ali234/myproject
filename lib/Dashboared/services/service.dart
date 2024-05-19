import 'package:cloud_firestore/cloud_firestore.dart';

class GraphService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  GraphService() {
    initializeData();
  }

  void initializeData() async {
    // Get the current date
    final DateTime currentDate = DateTime.now();
    // Format the current date for Firestore query
    String formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";

    // Cumulative total litres for all pumps
    double totalPetrolLitre = 0;
    double totalDieselLitre = 0;

    // Fetching all pumps
    QuerySnapshot pumpSnapshot =
        await _db.collection('users').doc('Pump').collection('Pump').get();

    // Looping through each pump
    for (DocumentSnapshot pumpDoc in pumpSnapshot.docs) {
      String pumpId = pumpDoc.id;

      // Querying meter reading history for the current pump and current date
      QuerySnapshot salesSnapshot = await _db
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(pumpId)
          .collection('meter reading history')
          .where('date', isGreaterThanOrEqualTo: currentDate)
          .where('date', isLessThan: currentDate.add(const Duration(days: 1)))
          .get();

      // Calculating sales for each pump
      double pumpPetrolLitre = 0;
      double pumpDieselLitre = 0;

      for (DocumentSnapshot doc in salesSnapshot.docs) {
        String type =
            doc['type']; // Assuming 'type' field indicates petrol or diesel
        int litres = doc['litres']; // Assuming litres are stored as integers

        if (type.toLowerCase() == 'petrol') {
          pumpPetrolLitre += litres.toDouble();
        } else if (type.toLowerCase() == 'diesel') {
          pumpDieselLitre += litres.toDouble();
        }
      }

      // Accumulating total litres across all pumps
      totalPetrolLitre += pumpPetrolLitre;
      totalDieselLitre += pumpDieselLitre;

      print(
          'Total petrol litre for Pump $pumpId on $formattedDate: $pumpPetrolLitre');
      print(
          'Total diesel litre for Pump $pumpId on $formattedDate: $pumpDieselLitre');
    }

    print(
        'Total petrol litre across all pumps on $formattedDate: $totalPetrolLitre');
    print(
        'Total diesel litre across all pumps on $formattedDate: $totalDieselLitre');
  }
}
