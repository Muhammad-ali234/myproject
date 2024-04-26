import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Pump/petrol_pump.dart';

import 'package:myproject/Dashboared/dashbored_card.dart';
import 'package:myproject/Dashboared/pump_card.dart';
import 'package:myproject/Dashboared/sidebar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardOwnerScreen extends StatelessWidget {
  List<Point> salesData = [
    Point(0, 20), // January
    Point(1, 30), // February
    Point(2, 40), // March
    Point(3, 50), // April
    Point(4, 60), // May
    Point(5, 70), // June
    Point(6, 80), // July
    Point(7, 90), // August
    Point(8, 100), // September
    Point(9, 110), // October
    Point(10, 120), // November
    Point(11, 130), // December
  ];

  List<Point> earningsData = [
    Point(0, 10), // January
    Point(1, 20), // February
    Point(2, 30), // March
    Point(3, 40), // April
    Point(4, 50), // May
    Point(5, 60), // June
    Point(6, 70), // July
    Point(7, 80), // August
    Point(8, 90), // September
    Point(9, 100), // October
    Point(10, 110), // November
    Point(11, 120), // December
  ];

  List<int> registeredPumps = [
    1,
    2,
    3,
    4,
    5,
    6,
    7
  ]; // Example list of registered pumps

  DashboardOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: MediaQuery.of(context).size.width < 600
            ? Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu,
                        color: Colors.white), // Drawer icon with white color
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Open the drawer
                    },
                  );
                },
              )
            : null,
      ),
      drawer:
          MediaQuery.of(context).size.width < 600 ? const CustomDrawer() : null,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
            return buildMobileLayout(context);
          } else {
            return buildWebLayout(context);
          }
        },
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    List<Widget> rows = [];

    // Generate rows with two PumpCard widgets in each row
    for (int i = 0; i < registeredPumps.length; i += 2) {
      List<Widget> pumpCards = [];
      for (int j = i; j < i + 2 && j < registeredPumps.length; j++) {
        pumpCards.add(
          PumpCard(
            pumpNumber: registeredPumps[j],
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PetrolPumpStatus(),
                ),
              );
            },
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pumpCards,
        ),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Petrol Pump Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DashboardCard(
                title: 'Total Sales',
                value: '\$10,000',
                icon: Icons.shopping_cart,
                color: Colors.blue,
                dataPoints: salesData,
              ),
              const SizedBox(height: 20),
              DashboardCard(
                title: 'Total Earnings',
                value: '\$5,000',
                icon: Icons.attach_money,
                color: Colors.green,
                dataPoints: earningsData,
              ),
              const SizedBox(height: 20),
              const Text(
                'Pump Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: rows,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWebLayout(BuildContext context) {
    List<Widget> rows = [];

    // Generate rows with three PumpCard widgets in each row
    for (int i = 0; i < registeredPumps.length; i += 6) {
      List<Widget> pumpCards = [];
      for (int j = i; j < i + 6 && j < registeredPumps.length; j++) {
        pumpCards.add(
          PumpCard(
            pumpNumber: registeredPumps[j],
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PetrolPumpStatus(),
                ),
              );
            },
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pumpCards,
        ),
      );
    }

    return Expanded(
      child: Row(
        children: [
          // Sidebar
          const CustomDrawer(),
          // Divider
          VerticalDivider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Sales Card
                      DashboardCard(
                        title: 'Total Sales',
                        value: '\$10,000',
                        icon: Icons.shopping_cart,
                        color: Colors.blue,
                        dataPoints: salesData,
                      ),
                      // Total Earnings Card
                      DashboardCard(
                        title: 'Total Earnings',
                        value: '\$5,000',
                        icon: Icons.attach_money,
                        color: Colors.green,
                        dataPoints: earningsData,
                      ),
                    ],
                  ),
                  // Pump cards
                  Column(
                    children: rows,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
