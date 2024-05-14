import 'package:flutter/material.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

import '../../common/screens/sidebar.dart';

// ignore: must_be_immutable
class DailyOverviewScreen extends StatelessWidget {
  final Color cardColor = const Color(0xFF6789CA);
  final Color titleTextColor = Colors.white;
  final Color iconColor = Colors.white;
  String selectedFuelType = 'Petrol';
  final List<Customer>? users;
  final BuildContext context;
  final String totalStock = "100";

  DailyOverviewScreen({super.key, this.users, required this.context});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        title: const Text(
          'Daily Overview',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6789CA),
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return buildMobileLayout();
          } else {
            // Web layout
            return buildWebLayout(context);
          }
        },
      ),
    );
  }

  Widget buildWebLayout(BuildContext context) {
    return Row(
      children: [
        // sidebar
        SideBar(
          menuItems: getMenuItems(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    SizedBox(
                      width: 950,
                    ),
                    Icon(
                      Icons.calendar_month,
                      size: 40,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Card_Widget(
                      name: "Total Petrol Sale",
                      totalStock: totalStock,
                      inputIcon: Icons.storage,
                      cardColor: cardColor, // Use the defined color
                      iconColor: iconColor,
                      textColor: titleTextColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/stock');
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Card_Widget(
                      name: "Today Credit",
                      totalStock: totalStock,
                      inputIcon: Icons.arrow_downward,
                      cardColor: cardColor, // Use the defined color
                      iconColor: iconColor,
                      textColor: titleTextColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/stock');
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Card_Widget(
                      name: "Today Debit",
                      totalStock: totalStock,
                      inputIcon: Icons.arrow_upward,
                      cardColor: cardColor, // Use the defined color
                      iconColor: iconColor,
                      textColor: titleTextColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/stock');
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Card_Widget(
                      name: "Today Expense",
                      totalStock: totalStock,
                      inputIcon: Icons.arrow_upward,
                      cardColor: cardColor, // Use the defined color
                      iconColor: iconColor,
                      textColor: titleTextColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/stock');
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Card_Widget(
                      name: "Net Amount",
                      totalStock: totalStock,
                      inputIcon: Icons.arrow_upward,
                      cardColor: cardColor, // Use the defined color
                      iconColor: iconColor,
                      textColor: titleTextColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/stock');
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOverviewCard('Today Credit', '1881', cardColor),
            _buildOverviewCard('Today Debit', '2772', cardColor),
            _buildOverviewCard('Today Expense', '50', cardColor),
            _buildOverviewCard('Net Amount', '250', cardColor),
            _buildOverviewCard('Today Sale', '1000', cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    String title,
    String amount,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
       
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$$amount',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card_Widget extends StatelessWidget {
  final String totalStock;
  final String name;
  final IconData inputIcon;
  final Color cardColor;
  final Color iconColor;
  final Color textColor;
  final IconData? secondIcon;
  final VoidCallback onTap;

  const Card_Widget({
    super.key,
    this.secondIcon,
    required this.totalStock,
    required this.inputIcon,
    required this.name,
    required this.cardColor,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    inputIcon,
                    color: iconColor,
                    size: 30.0,
                  ),
                  if (secondIcon != null) ...[
                    const SizedBox(height: 10.0),
                    Icon(
                      secondIcon,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Total: $totalStock',
                style: TextStyle(
                  fontSize: 14.0,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
