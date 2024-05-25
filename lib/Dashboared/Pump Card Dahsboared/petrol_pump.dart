// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:myproject/Dashboared/sidebar.dart';

// class PetrolPumpStatus extends StatelessWidget {
//   final String pumpId;

//   const PetrolPumpStatus({
//     super.key,
//     required this.pumpId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text(
//           'Petrol Pump Status',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: MediaQuery.of(context).size.width < 600
//             ? Builder(
//                 builder: (BuildContext context) {
//                   return IconButton(
//                     icon: const Icon(Icons.menu, color: Colors.white),
//                     onPressed: () {
//                       Scaffold.of(context).openDrawer();
//                     },
//                   );
//                 },
//               )
//             : null,
//       ),
//       drawer:
//           MediaQuery.of(context).size.width < 600 ? const CustomDrawer() : null,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 600) {
//             return _buildWebLayout(context);
//           } else {
//             return _buildMobileLayout(context);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildWebLayout(context) {
//     return Row(
//       children: [
//         const CustomDrawer(),
//         VerticalDivider(
//           thickness: 1,
//           color: Colors.grey.shade600,
//         ),
//         Expanded(
//           flex: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildSearchFilter(context),
//                 Divider(
//                   thickness: 1,
//                   color: Colors.grey.shade600,
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: _buildDailyOverview(context),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileLayout(context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _buildSearchFilter(context),
//           const SizedBox(height: 20),
//           Expanded(
//             child: _buildDailyOverview(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDailyOverview(BuildContext context) {
//     DateTime startOfDay =
//         DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//     DocumentReference dailyOverviewRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc('Pump')
//         .collection('Pump')
//         .doc(pumpId)
//         .collection('daily_overview')
//         .doc(startOfDay.toIso8601String());

//     return StreamBuilder<DocumentSnapshot>(
//       stream: dailyOverviewRef.snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text('No data available for today'));
//         }
//         var data = snapshot.data!.data() as Map<String, dynamic>;

//         return ListView(
//           children: [
//             PetrolPumpCard(
//               title: 'Daily Overview',
//               children: [
//                 DashboardInfoItem(label: 'Credit', value: '${data['credit']}'),
//                 DashboardInfoItem(label: 'Debit', value: '${data['debit']}'),
//                 DashboardInfoItem(label: 'Diesel', value: '${data['diesel']}'),
//                 DashboardInfoItem(
//                     label: 'Expense', value: '${data['expense']}'),
//                 DashboardInfoItem(label: 'Petrol', value: '${data['petrol']}'),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSearchFilter(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Filter by:',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             final DateTime? pickedDate = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2015, 8),
//               lastDate: DateTime.now(),
//             );
//             if (pickedDate != null) {
//               // Implement filtering logic based on pickedDate
//               print('Selected date: $pickedDate');
//             }
//           },
//           child: const Text('Select Date'),
//         ),
//       ],
//     );
//   }
// }

// class PetrolPumpCard extends StatelessWidget {
//   final String title;
//   final List<Widget> children;

//   const PetrolPumpCard({
//     super.key,
//     required this.title,
//     required this.children,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.0),
//         border: Border.all(color: Colors.black),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const SizedBox(height: 15),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: children,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DashboardInfoItem extends StatelessWidget {
//   final String label;
//   final String value;

//   const DashboardInfoItem({
//     super.key,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/Dashboared/sidebar.dart';

class PetrolPumpStatus extends StatefulWidget {
  final String pumpId;

  const PetrolPumpStatus({
    super.key,
    required this.pumpId,
  });

  @override
  _PetrolPumpStatusState createState() => _PetrolPumpStatusState();
}

class _PetrolPumpStatusState extends State<PetrolPumpStatus> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Petrol Pump Status',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWebLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWebLayout(context) {
    return Row(
      children: [
        const CustomDrawer(),
        VerticalDivider(
          thickness: 1,
          color: Colors.grey.shade600,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchFilter(context),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildDailyOverview(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchFilter(context),
          const SizedBox(height: 20),
          Expanded(
            child: _buildDailyOverview(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyOverview(BuildContext context) {
    DateTime startOfDay =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    DocumentReference dailyOverviewRef = FirebaseFirestore.instance
        .collection('users')
        .doc('Pump')
        .collection('Pump')
        .doc(widget.pumpId)
        .collection('daily_overview')
        .doc(startOfDay.toIso8601String());

    return StreamBuilder<DocumentSnapshot>(
      stream: dailyOverviewRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
              child: Text('No data available for selected date'));
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;

        return ListView(
          children: [
            PetrolPumpCard(
              title: 'Daily Overview',
              children: [
                DashboardInfoItem(label: 'Credit', value: '${data['credit']}'),
                DashboardInfoItem(label: 'Debit', value: '${data['debit']}'),
                DashboardInfoItem(label: 'Diesel', value: '${data['diesel']}'),
                DashboardInfoItem(
                    label: 'Expense', value: '${data['expense']}'),
                DashboardInfoItem(label: 'Petrol', value: '${data['petrol']}'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter by:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2015, 8),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}

class PetrolPumpCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PetrolPumpCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const DashboardInfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
