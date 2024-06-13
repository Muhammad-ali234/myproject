import 'package:flutter/material.dart';

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
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 350,
            width: double.infinity,
            child: GraphScreen(),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (registeredPumps.length / 2).ceil(),
            itemBuilder: (context, index) {
              int startIndex = index * 2;
              int endIndex = startIndex + 2;
              if (endIndex > registeredPumps.length) {
                endIndex = registeredPumps.length;
              }

              List<Widget> pumpCards = [];
              for (int i = startIndex; i < endIndex; i++) {
                var pumpData =
                    registeredPumps[i].data() as Map<String, dynamic>;
                String pumpName = pumpData['name'] ?? 'Pump Name';

                pumpCards.add(
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Assuming pumpID is fetched properly from the document
                        String pumpID = registeredPumps[i].id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PetrolPumpStatus(pumpId: pumpID),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_gas_station,
                              size: 40,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pumpName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: pumpCards,
              );
            },
          ),
        ],
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
      String pumpName = pumpData['name'] ?? 'Pump Name';
      String pumpId = pump.id;

      pumpCards.add(
        PumpCard(
          pumpName: pumpName,
          onTap: () {
            _service.initializeData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetrolPumpStatus(
                  pumpId: pumpId,
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
          const CustomDrawer(),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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

class PumpCard extends StatelessWidget {
  final String pumpName;
  final VoidCallback onTap;

  const PumpCard({
    super.key,
    required this.pumpName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_gas_station,
                size: 40,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                pumpName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
