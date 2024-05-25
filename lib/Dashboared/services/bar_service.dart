// // firestore_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarChartService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<Map<String, Map<String, double>>> fetchTotalMonthlyRecord() async {
//     // Initialize total monthly record
//     Map<String, Map<String, double>> totalMonthlyRecord = {};

//     // Get data for each month
//     for (int month = 1; month <= 12; month++) {
//       String monthKey = '${DateTime.now().year}-$month';

//       QuerySnapshot pumpSnapshots = await _firestore
//           .collection('users')
//           .doc('Pump')
//           .collection('Pump')
//           .get();

//       // Aggregate data from all pumps
//       for (DocumentSnapshot pumpSnapshot in pumpSnapshots.docs) {
//         String pumpId = pumpSnapshot.id;
//         DocumentSnapshot monthlyOverviewSnapshot = await _firestore
//             .collection('users')
//             .doc('Pump')
//             .collection('Pump')
//             .doc(pumpId)
//             .collection('monthly_overview')
//             .doc(monthKey)
//             .get();

//         Map<String, dynamic> monthlyOverviewData =
//             monthlyOverviewSnapshot.data() as Map<String, dynamic>? ?? {};

//         // Initialize monthly record for the current pump
//         Map<String, double> monthlyRecord = {
//           'credit': monthlyOverviewData['credit']?.toDouble() ?? 0,
//           'debit': monthlyOverviewData['debit']?.toDouble() ?? 0,
//           'diesel': monthlyOverviewData['diesel']?.toDouble() ?? 0,
//           'expense': monthlyOverviewData['expense']?.toDouble() ?? 0,
//           'petrol': monthlyOverviewData['petrol']?.toDouble() ?? 0,
//         };

//         // Add or merge the monthly record to the total monthly record
//         if (totalMonthlyRecord.containsKey(monthKey)) {
//           totalMonthlyRecord[monthKey]!
//               .update('credit', (value) => value + monthlyRecord['credit']!);
//           totalMonthlyRecord[monthKey]!
//               .update('debit', (value) => value + monthlyRecord['debit']!);
//           totalMonthlyRecord[monthKey]!
//               .update('diesel', (value) => value + monthlyRecord['diesel']!);
//           totalMonthlyRecord[monthKey]!
//               .update('expense', (value) => value + monthlyRecord['expense']!);
//           totalMonthlyRecord[monthKey]!
//               .update('petrol', (value) => value + monthlyRecord['petrol']!);
//         } else {
//           totalMonthlyRecord[monthKey] = monthlyRecord;
//         }
//       }
//     }

//     return totalMonthlyRecord;
//   }

// }
import 'package:cloud_firestore/cloud_firestore.dart';

class BarChartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, Map<String, double>>> fetchTotalMonthlyRecord() async {
    // Initialize total monthly record
    Map<String, Map<String, double>> totalMonthlyRecord = {};

    // Get data for each month in parallel
    List<Future<void>> futures = [];
    for (int month = 1; month <= 12; month++) {
      futures.add(_fetchMonthlyData(totalMonthlyRecord, month));
    }

    // Await all futures
    await Future.wait(futures);

    return totalMonthlyRecord;
  }

  Future<void> _fetchMonthlyData(
      Map<String, Map<String, double>> totalMonthlyRecord, int month) async {
    String monthKey = '${DateTime.now().year}-$month';

    QuerySnapshot pumpSnapshots = await _firestore
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .get();

    // Create a list of futures for fetching monthly overview data for all pumps
    List<Future<void>> pumpFutures =
        pumpSnapshots.docs.map((pumpSnapshot) async {
      String pumpId = pumpSnapshot.id;
      DocumentSnapshot monthlyOverviewSnapshot = await _firestore
          .collection('users')
          .doc('Pump')
          .collection('Pump')
          .doc(pumpId)
          .collection('monthly_overview')
          .doc(monthKey)
          .get();

      Map<String, dynamic> monthlyOverviewData =
          monthlyOverviewSnapshot.data() as Map<String, dynamic>? ?? {};

      // Initialize monthly record for the current pump
      Map<String, double> monthlyRecord = {
        'credit': monthlyOverviewData['credit']?.toDouble() ?? 0,
        'debit': monthlyOverviewData['debit']?.toDouble() ?? 0,
        'diesel': monthlyOverviewData['diesel']?.toDouble() ?? 0,
        'expense': monthlyOverviewData['expense']?.toDouble() ?? 0,
        'petrol': monthlyOverviewData['petrol']?.toDouble() ?? 0,
      };

      // Synchronize the update of the total monthly record
      totalMonthlyRecord.update(monthKey, (existing) {
        existing['credit'] = existing['credit']! + monthlyRecord['credit']!;
        existing['debit'] = existing['debit']! + monthlyRecord['debit']!;
        existing['diesel'] = existing['diesel']! + monthlyRecord['diesel']!;
        existing['expense'] = existing['expense']! + monthlyRecord['expense']!;
        existing['petrol'] = existing['petrol']! + monthlyRecord['petrol']!;
        return existing;
      }, ifAbsent: () => monthlyRecord);
    }).toList();

    // Await all pump futures
    await Future.wait(pumpFutures);
  }
}
