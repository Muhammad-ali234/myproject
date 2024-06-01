import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Pump%20Card%20Dahsboared/petrol_pump.dart';
import 'package:myproject/Dashboared/Barchart/barchart_screen.dart';
import 'package:myproject/Dashboared/Dashboared/widget/pump_card.dart';
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
              SizedBox(height: 350, width: 1000, child: GraphScreen()),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 16.0, // Spacing between pump cards
                  runSpacing: 16.0, // Vertical spacing for wrapping
                  children: pumpCards,
                ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 350, width: 1000, child: GraphScreen()),
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
