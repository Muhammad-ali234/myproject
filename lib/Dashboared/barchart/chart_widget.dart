import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartScreen extends StatelessWidget {
  final Map<String, Map<String, double>> monthlyReadings;

  const BarChartScreen({super.key, required this.monthlyReadings});

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum value in your data
    double maxValue = 0;
    for (var entry in monthlyReadings.values) {
      for (var value in entry.values) {
        if (value > maxValue) {
          maxValue = value;
        }
      }
    }
    double maxY = maxValue + 100;

    return Card(
      color: Colors.white,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor:
                              const Color.fromARGB(255, 235, 233, 233))),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1, color: Colors.black),
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barGroups: _getBarGroups(context),
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
                        getTitlesWidget: (value, meta) {
                          final List<String> monthNames = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          if (value.toInt() < 0 ||
                              value.toInt() >= monthNames.length) {
                            return const Text('');
                          }
                          return SizedBox(
                            width: 15,
                            child: FittedBox(
                                child: Text(monthNames[value.toInt()])),
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
                // _buildLegendItem(Colors.orange, 'Debit'),
                // _buildLegendItem(Colors.purple, 'Expense'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.orange, 'Debit'),
                _buildLegendItem(Colors.purple, 'Expense'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(BuildContext context) {
    int index = 0;
    return monthlyReadings.entries.map((entry) {
      final data = entry.value;
      final petrol = data['petrol'] ?? 0.0;
      final diesel = data['diesel'] ?? 0.0;
      final credit = data['credit'] ?? 0.0;
      final debit = data['debit'] ?? 0.0;
      final expense = data['expense'] ?? 0.0;

      final double barWidth =
          (MediaQuery.of(context).size.width) >= 605 ? 10 : 3;
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(toY: petrol, color: Colors.blue, width: barWidth),
          BarChartRodData(toY: diesel, color: Colors.green, width: barWidth),
          BarChartRodData(toY: credit, color: Colors.red, width: barWidth),
          BarChartRodData(toY: debit, color: Colors.orange, width: barWidth),
          BarChartRodData(toY: expense, color: Colors.purple, width: barWidth),
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
          child: DecoratedBox(decoration: BoxDecoration(color: color)),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color)),
        const SizedBox(width: 10),
      ],
    );
  }
}
