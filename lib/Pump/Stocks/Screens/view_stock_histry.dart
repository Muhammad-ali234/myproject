// import 'package:flutter/material.dart';
// import 'package:petrol_pump/Pump/Stocks/Widget/stock_histryitem.dart';

// import '../Models/stock_histry_Item.dart';

// class StockHistoryScreen extends StatelessWidget {
//   final List<StockHistoryItem> stockHistory;
//   final String historyType;

//   const StockHistoryScreen(
//       {Key? key, required this.stockHistory, required this.historyType})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<StockHistoryItem> filteredHistory = stockHistory
//         .where((item) => item.type.toLowerCase() == historyType.toLowerCase())
//         .toList();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$historyType History'),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // Responsive UI logic
//           if (constraints.maxWidth < 600) {
//             // Mobile layout
//             return buildMobileLayout(filteredHistory);
//           } else {
//             // Web layout
//             return buildWebLayout(context, filteredHistory);
//           }
//         },
//       ),
//     );
//   }

//   Widget buildWebLayout(
//       BuildContext context, List<StockHistoryItem> filteredHistory) {
//     return Row(
//       children: [
//         // Sidebar
//         Container(
//           width: 250,
//           color: Colors.blue,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Menu',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/dashboardScreen');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 25.0, horizontal: 50),
//                   foregroundColor: Colors.blue,
//                   backgroundColor: Colors.white,
//                 ),
//                 child: const Text('Dashboard'),
//               ),
//             ],
//           ),
//         ),
//         // Main Content
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text(
//                       'Stock History',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: filteredHistory.length,
//                         itemBuilder: (context, index) {
//                           return StockHistoryItemWidget(
//                             historyItem: filteredHistory[index],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildMobileLayout(List<StockHistoryItem> filteredHistory) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'Stock History',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredHistory.length,
//                   itemBuilder: (context, index) {
//                     return StockHistoryItemWidget(
//                       historyItem: filteredHistory[index],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
