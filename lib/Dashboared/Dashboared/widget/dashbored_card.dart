import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final List<Point> dataPoints;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double chartWidth = screenWidth >= 600 ? 400 : screenWidth - 60;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: screenWidth > 600 ? 30.0 : 24.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 18.0 : 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              value,
              style: TextStyle(
                fontSize: screenWidth > 600 ? 24.0 : 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: chartWidth,
              height: 200,
              child: BarChartWidget(
                points: dataPoints,
                borderColor: Colors.transparent, // No borders to prevent lines
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Point> points;
  final Color? borderColor; // Add this parameter to control border color

  const BarChartWidget({super.key, required this.points, this.borderColor});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = screenWidth > 600 ? 2.0 : 1.5;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: BarChart(
          BarChartData(
            barGroups: _createBarGroups(),
            borderData: FlBorderData(
              border: const Border(
                  bottom: BorderSide(), // Keep bottom border
                  left: BorderSide() // Or no border
                  ),
            ),
            gridData: const FlGridData(show: false),
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
                  getTitlesWidget: _getMonthTitle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return points
        .map(
          (point) => BarChartGroupData(
            x: point.x.toInt(),
            barRods: [
              BarChartRodData(
                toY: point.y,
                color: Colors.blue,
              ),
            ],
          ),
        )
        .toList();
  }

  double _calculateYAxisInterval() {
    double maxY = points.fold(0, (max, point) => point.y > max ? point.y : max);
    return maxY > 100 ? 50 : 10;
  }

  Widget _getMonthTitle(double value, TitleMeta meta) {
    List<String> months = [
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

    return Text(
      months[value.toInt()],
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _getYAxisTitle(double value, TitleMeta meta) {
    return Text(
      '${value.toInt()}',
      style: const TextStyle(color: Colors.black),
    );
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}
