import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myproject/Common/constant.dart';
import 'package:myproject/Pump/Daily_Overview/Screens/service.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class DailyOverviewScreen extends StatelessWidget {
  const DailyOverviewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor
              .dashbordWhiteColor, 
        ),
        title: Text(
          'Daily Overview',
          style: TextStyle(color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: Row(
        children: [
          if (width >= 600)
            SideBar(
              menuItems: getMenuItems(context),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _fetchData(), // Asynchronously fetch data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is being fetched, show a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If an error occurs during data fetching, display an error message
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Data has been successfully fetched, display the UI
                    final Map<String, dynamic> data = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSalesInfo(data),
                          const SizedBox(height: 20),
                          _buildBarChart(data, width),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchData() async {
    // Create an instance of the service
    DailyOverviewService service = DailyOverviewService();

    // Fetch data from service
    Map<String, double> totalMeterReadings =
        await service.getTotalMeterReadingsOnCurrentDate();
    Map<String, double> totalTransactions =
        await service.getTodaysTotalCreditAndDebitForAllCustomers();
    double totalExpenses = await service.fetchTotalExpenseForToday();

    // Combine all data into one map
    Map<String, dynamic> data = {
      'totalPetrolSales': totalMeterReadings['petrol'] ?? 0.0,
      'totalDieselSales': totalMeterReadings['diesel'] ?? 0.0,
      'totalCredit': totalTransactions['totalCredit'] ?? 0.0,
      'totalDebit': totalTransactions['totalDebit'] ?? 0.0,
      'totalExpenses': totalExpenses ?? 0.0,
    };

    return data;
  }

  Widget _buildSalesInfo(Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSalesRow('Total Petrol Sales:', data['totalPetrolSales'],
                AppColor.dashbordSBlueColor),
            _buildSalesRow('Total Diesel Sales:', data['totalDieselSales'],
                AppColor.dashbordGreenColor),
            _buildSalesRow('Total Credit:', data['totalCredit'],
                AppColor.dashbordYellowColor),
            _buildSalesRow(
                'Total Debit:', data['totalDebit'], AppColor.dashbordRedColor),
            _buildSalesRow('Total Expenses:', data['totalExpenses'],
                AppColor.dashbordPurpleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesRow(String title, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value.toString(), style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, dynamic> data, double width) {
    return AspectRatio(
      aspectRatio: width >= 600 ? 4 : 1.5,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _buildBarGroup(0, data['totalPetrolSales'],
                          AppColor.dashbordSBlueColor),
                      _buildBarGroup(1, data['totalDieselSales'],
                          AppColor.dashbordGreenColor),
                      _buildBarGroup(
                          2, data['totalCredit'], AppColor.dashbordYellowColor),
                      _buildBarGroup(
                          3, data['totalDebit'], AppColor.dashbordRedColor),
                      _buildBarGroup(4, data['totalExpenses'],
                          AppColor.dashbordPurpleColor),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
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
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Petrol');
                              case 1:
                                return const Text('Diesel');
                              case 2:
                                return const Text('Credit');
                              case 3:
                                return const Text('Debit');
                              case 4:
                                return const Text('Expenses');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int titleIndex, double value, Color color) {
    return BarChartGroupData(
      x: titleIndex,
      barRods: [
        BarChartRodData(toY: value, color: color),
      ],
      showingTooltipIndicators: [0],
    );
  }
}
