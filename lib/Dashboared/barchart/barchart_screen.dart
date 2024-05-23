import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/barchart/service.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartScreen extends StatelessWidget {
  final Map<String, Map<String, double>> monthlyReadings;

  const BarChartScreen({super.key, required this.monthlyReadings});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barGroups: _getBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
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
                if (value.toInt() < 0 || value.toInt() >= monthNames.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(monthNames[value.toInt()]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxY = 0;
    monthlyReadings.forEach((key, value) {
      maxY = maxY > value['petrol']! + value['diesel']!
          ? maxY
          : value['petrol']! + value['diesel']!;
    });
    return maxY;
  }

  List<BarChartGroupData> _getBarGroups() {
    int index = 0;
    return monthlyReadings.keys.map((month) {
      final petrol = monthlyReadings[month]!['petrol']!;
      final diesel = monthlyReadings[month]!['diesel']!;
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(toY: petrol, color: Colors.blue, width: 15),
          BarChartRodData(toY: diesel, color: Colors.green, width: 15),
        ],
      );
    }).toList();
  }
}

class MeterReadingsScreen extends StatefulWidget {
  const MeterReadingsScreen({super.key});

  @override
  _MeterReadingsScreenState createState() => _MeterReadingsScreenState();
}

class _MeterReadingsScreenState extends State<MeterReadingsScreen> {
  final BarChartService _dailyOverviewService = BarChartService();
  late Future<Map<String, Map<String, double>>> _futureMonthlyReadings;

  @override
  void initState() {
    super.initState();
    _futureMonthlyReadings =
        _dailyOverviewService.getTotalMeterReadingsForLast12Months();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, double>>>(
      future: _futureMonthlyReadings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarChartScreen(monthlyReadings: snapshot.data!),
        );
      },
    );
  }
}
