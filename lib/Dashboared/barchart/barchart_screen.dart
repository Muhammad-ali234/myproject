import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Barchart/chart_widget.dart';
import 'package:myproject/Dashboared/services/bar_service.dart';


// meter_readings_screen.dart

class GraphScreen extends StatelessWidget {
  final BarChartService _firestoreService = BarChartService();

  GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, double>>>(
      future: _firestoreService.fetchTotalMonthlyRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, Map<String, double>> monthlyReadings =
              snapshot.data ?? {};

          // Display BarChartScreen with monthlyReadings data
          return BarChartScreen(monthlyReadings: monthlyReadings);
        }
      },
    );
  }
}
