// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:myproject/Dashboared/barchart/service.dart';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BarChartScreen extends StatelessWidget {
//   final Map<String, Map<String, double>> monthlyReadings;

//   const BarChartScreen({super.key, required this.monthlyReadings});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 1000,
//         //_getMaxY(),
//         barGroups: _getBarGroups(),
//         titlesData: FlTitlesData(
//           leftTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (double value, TitleMeta meta) {
//                 final monthNames = monthlyReadings.keys.toList();
//                 if (value.toInt() < 0 || value.toInt() >= monthNames.length) {
//                   return const SizedBox.shrink();
//                 }
//                 return SideTitleWidget(
//                   axisSide: meta.axisSide,
//                   child: Text(monthNames[value.toInt()]),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // double _getMaxY() {
//   //   double maxY = 0;
//   //   monthlyReadings.forEach((key, value) {
//   //     maxY = maxY > value['petrol']! + value['diesel']!
//   //         ? maxY
//   //         : value['petrol']! + value['diesel']!;
//   //   });
//   //   return maxY;
//   // }

//   List<BarChartGroupData> _getBarGroups() {
//     int index = 0;
//     return monthlyReadings.keys.map((month) {
//       // final petrol = monthlyReadings[month]!['petrol']!;
//       // final diesel = monthlyReadings[month]!['diesel']!;
//       return BarChartGroupData(
//         x: index++,
//         barRods: [
//           BarChartRodData(
//               toY: 500
//               // petrol
//               ,
//               color: Colors.blue,
//               width: 15),
//           BarChartRodData(
//               toY: 500,
//               // diesel,
//               color: Colors.green,
//               width: 15),
//         ],
//       );
//     }).toList();
//   }
// }

// class MeterReadingsScreen extends StatefulWidget {
//   const MeterReadingsScreen({super.key});

//   @override
//   _MeterReadingsScreenState createState() => _MeterReadingsScreenState();
// }

// class _MeterReadingsScreenState extends State<MeterReadingsScreen> {

//   final BarChartService _dailyOverviewService = BarChartService();
//   late Future<Map<String, Map<String, double>>> _futureMonthlyReadings;

//   @override
//   void initState() {
//     super.initState();
//     _futureMonthlyReadings =
//         _dailyOverviewService.getTotalMeterReadingsForLast12Months();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return

//      FutureBuilder<Map<String, Map<String, double>>>(
//       future: _futureMonthlyReadings,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No data available'));
//         }

//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: BarChartScreen(monthlyReadings: snapshot.data!),
//         );
//       },
//     );
//   }
// }
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BarChartScreen extends StatelessWidget {
  final Map<String, Map<String, double>> monthlyReadings;

  const BarChartScreen({super.key, required this.monthlyReadings});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide(width: 1, color: Colors.black),
                        bottom: BorderSide(width: 1, color: Colors.black)),
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1000, // Adjust based on your data
                  barGroups: _getBarGroups(),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final monthNames = monthlyReadings.keys.toList();
                          if (value.toInt() < 0 ||
                              value.toInt() >= monthNames.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: FittedBox(
                              alignment: Alignment.topLeft,
                              child: Text(
                                monthNames[value.toInt()],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Petrol'),
                _buildLegendItem(Colors.green, 'Diesel'),
                _buildLegendItem(Colors.red, 'Credit'),
                _buildLegendItem(Colors.orange, 'Debit'),
                _buildLegendItem(Colors.purple, 'Expense'),
                _buildLegendItem(Colors.teal, 'Customer'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    int index = 0;
    return monthlyReadings.keys.map((month) {
      final petrol = monthlyReadings[month]!['petrol'] ?? 0.0;
      final diesel = monthlyReadings[month]!['diesel'] ?? 0.0;
      final credit = monthlyReadings[month]!['credit'] ?? 0.0;
      final debit = monthlyReadings[month]!['debit'] ?? 0.0;
      final expense = monthlyReadings[month]!['expense'] ?? 0.0;
      final customer = monthlyReadings[month]!['customer'] ?? 0.0;

      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(toY: petrol, color: Colors.blue),
          BarChartRodData(toY: diesel, color: Colors.green),
          BarChartRodData(toY: credit, color: Colors.orange),
          BarChartRodData(toY: debit, color: Colors.red),
          BarChartRodData(toY: expense, color: Colors.purple),
          BarChartRodData(toY: customer, color: Colors.teal),
        ],
      );
    }).toList();
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        SizedBox(
            width: 5,
            height: 5,
            child: DecoratedBox(decoration: BoxDecoration(color: color))),
        const SizedBox(width: 5), // Adjust spacing between color indicators
        Text(label, style: TextStyle(color: color)),
        const SizedBox(
            width: 10), // Adjust spacing between text and color indicators
      ],
    );
  }
}

class MeterReadingsScreen extends StatelessWidget {
  const MeterReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static data for demonstration
    final Map<String, Map<String, double>> monthlyReadings = {
      'January': {
        'petrol': 800.0,
        'diesel': 500.0,
        'credit': 300.0,
        'debit': 400.0,
        'expense': 200.0,
        'customer': 100.0
      },
      'February': {
        'petrol': 750.0,
        'diesel': 600.0,
        'credit': 350.0,
        'debit': 450.0,
        'expense': 220.0,
        'customer': 150.0
      },
      'March': {
        'petrol': 900.0,
        'diesel': 550.0,
        'credit': 400.0,
        'debit': 500.0,
        'expense': 250.0,
        'customer': 200.0
      },
      'April': {'petrol': 850.0, 'diesel': 700.0},
      'May': {'petrol': 800.0, 'diesel': 500.0},
      'June': {'petrol': 950.0, 'diesel': 600.0},
      'July': {'petrol': 1000.0, 'diesel': 650.0},
      'August': {'petrol': 800.0, 'diesel': 700.0},
      'September': {'petrol': 850.0, 'diesel': 600.0},
      'October': {'petrol': 900.0, 'diesel': 500.0},
      'November': {'petrol': 950.0, 'diesel': 600.0},
      'December': {'petrol': 1000.0, 'diesel': 550.0},
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChartScreen(monthlyReadings: monthlyReadings),
    );
  }
}
