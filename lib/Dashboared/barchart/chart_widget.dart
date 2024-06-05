import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartScreen extends StatelessWidget {
  final Map<String, Map<String, double>> monthlyReadings;

  const BarChartScreen({super.key, required this.monthlyReadings});

  @override
  Widget build(BuildContext context) {
    double maxValue = 0;
    for (var entry in monthlyReadings.values) {
      for (var value in entry.values) {
        if (value > maxValue) {
          maxValue = value;
        }
      }
    }
    double maxY = maxValue + 100;

    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = screenWidth < 600 ? 5 : 15;
    double fontSize = screenWidth < 600 ? 10 : 14;
    double reservedSize = screenWidth < 600 ? 22 : 28;

    return Card(
      color: Colors.white,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade200,
                    ),
                  ),
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
                  barGroups: _getBarGroups(barWidth),
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
                        reservedSize: reservedSize,
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
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              monthNames[value.toInt()],
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              children: [
                _buildLegendItem(Colors.blue, 'Petrol'),
                _buildLegendItem(Colors.green, 'Diesel'),
                _buildLegendItem(Colors.red, 'Credit'),
                _buildLegendItem(Colors.orange, 'Debit'),
                _buildLegendItem(Colors.purple, 'Expense'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(double barWidth) {
    int index = 0;
    return monthlyReadings.entries.map((entry) {
      final data = entry.value;
      final petrol = data['petrol'] ?? 0.0;
      final diesel = data['diesel'] ?? 0.0;
      final credit = data['credit'] ?? 0.0;
      final debit = data['debit'] ?? 0.0;
      final expense = data['expense'] ?? 0.0;

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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
