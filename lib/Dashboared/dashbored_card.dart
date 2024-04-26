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
                  size: 30.0,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            // Bar Chart Widget
            SizedBox(
              width: 400,
              height: 200,
              child: BarChartWidget(points: dataPoints),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  final List<Point> points;

  const BarChartWidget({super.key, required this.points});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              barGroups: _chartGroups(),
              borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide()),
              ),
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                leftTitles: AxisTitles(sideTitles: _leftTitles),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _chartAmountTexts() {
    return widget.points.map((point) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0), // Adjust as needed
        child: Text(
          '\$${point.y.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.black), // Add style as needed
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _chartGroups() {
    return widget.points
        .map((point) => BarChartGroupData(
              x: point.x.toInt(),
              barRods: [BarChartRodData(toY: point.y)],
            ))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String month = '';
          switch (value.toInt()) {
            case 0:
              month = 'Jan';
              break;
            case 1:
              month = 'Feb';
              break;
            case 2:
              month = 'Mar';
              break;
            case 3:
              month = 'Apr';
              break;
            case 4:
              month = 'May';
              break;
            case 5:
              month = 'Jun';
              break;
            case 6:
              month = 'Jul';
              break;
            case 7:
              month = 'Aug';
              break;
            case 8:
              month = 'Sep';
              break;
            case 9:
              month = 'Oct';
              break;
            case 10:
              month = 'Nov';
              break;
            case 11:
              month = 'Dec';
              break;
          }

          return Text(month);
        },
      );
  SideTitles get _leftTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          int index = value.toInt();
          if (index >= 0 && index < widget.points.length) {
            // Assuming you want to display values like 10, 20, 30, 40, etc.
            // Adjust this logic according to your needs
            int customValue =
                (index + 1) * 10; // Assuming you want increments of 10
            return Text(
                '$customValue'); // Return a Text widget with the custom value
          }
          return const SizedBox(); // Return an empty SizedBox if index is out of range
        },
      );
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}
