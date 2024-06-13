// import 'package:flutter/material.dart';

// class PumpCard extends StatelessWidget {
//   final String pumpName;
//   final VoidCallback onTap;

//   const PumpCard({
//     super.key,
//     required this.pumpName,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Card(
//           elevation: 4.0,
//           child: SizedBox(
//             height: 110,
//             width: 100,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     pumpName,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   // const Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   children: [
//                   //     InfoItem(label: 'Earnings', value: '\$5000'),
//                   //     SizedBox(
//                   //       width: 15,
//                   //     ),
//                   //     InfoItem(label: 'Profit', value: '\$2000'),
//                   //   ],
//                   // )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InfoItem extends StatelessWidget {
//   final String label;
//   final String value;

//   const InfoItem({super.key, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14.0,
//             color: Colors.grey,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         const SizedBox(height: 10.0),
//       ],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Barchart/barchart_screen.dart';
import 'package:myproject/Dashboared/Pump%20Card%20Dahsboared/petrol_pump.dart';

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
              var pumpData = registeredPumps[i].data() as Map<String, dynamic>;
              String pumpName = pumpData['name'] ?? 'Pump Name';

              pumpCards.add(
                PumpCard(
                  pumpName: pumpName,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PetrolPumpStatus(
                          pumpId:
                              '', // You may pass the pump ID here if available.
                        ),
                      ),
                    );
                  },
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
