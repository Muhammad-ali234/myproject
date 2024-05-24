import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Pump/petrol_pump.dart';
import 'package:myproject/Dashboared/barchart/barchart_screen.dart';
import 'package:myproject/Dashboared/dashbored_card.dart';
import 'package:myproject/Dashboared/pump_card.dart';
import 'package:myproject/Dashboared/services/service.dart';
import 'package:myproject/Dashboared/sidebar.dart';
import 'package:myproject/Dashboared/services/dashbord_service.dart';

class DashboardOwnerScreen extends StatefulWidget {
  const DashboardOwnerScreen({super.key});

  @override
  State<DashboardOwnerScreen> createState() => _DashboardOwnerScreenState();
}

class _DashboardOwnerScreenState extends State<DashboardOwnerScreen> {
  final DashboredService _dashboardService = DashboredService();

  final GraphService _service = GraphService();

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

  List<int> registeredPumps = [];
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _dashboardService.getPumpStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pumps registered'));
          }

          var registeredPumps = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return buildMobileLayout(context, registeredPumps);
              } else {
                return buildWebLayout(context, registeredPumps);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildMobileLayout(
      BuildContext context, List<QueryDocumentSnapshot> registeredPumps) {
    if (registeredPumps.isEmpty) {
      return const Center(child: Text('No pumps registered'));
    }

    List<Widget> pumpCards = [];
    for (var pump in registeredPumps) {
      var pumpData = pump.data() as Map<String, dynamic>;

      // Ensure you have the correct key for 'pump_number'
      String pumpName = pumpData['name'] ?? 'Pump Name';

      pumpCards.add(
        PumpCard(
          pumpName: pumpName,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PetrolPumpStatus(
                  pumpId: '',
                ),
              ),
            );
          },
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
              Wrap(
                spacing: 16.0, // Spacing between pump cards
                runSpacing: 16.0, // Vertical spacing for wrapping
                children: pumpCards,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWebLayout(
      BuildContext context, List<QueryDocumentSnapshot> registeredPumps) {
    if (registeredPumps.isEmpty) {
      return const Center(child: Text('No pumps registered'));
    }

    List<Widget> pumpCards = [];
    for (var pump in registeredPumps) {
      var pumpData = pump.data() as Map<String, dynamic>;

      // Ensure you have the correct key for 'pump_number'
      String pumpName = pumpData['name'] ?? 'Pump Name';
      String pumpId = pump.id; // Firestore document ID

      pumpCards.add(
        PumpCard(
          pumpName: pumpName,
          onTap: () {
            _service.initializeData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetrolPumpStatus(
                  pumpId: pumpId, // Pass the correct pump ID
                ),
              ),
            );
          },
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 350, width: 1000, child: MeterReadingsScreen()),
                  ),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: pumpCards,
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
