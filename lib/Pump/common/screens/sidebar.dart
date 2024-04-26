// import 'package:flutter/material.dart';
// import 'package:petrol_pump/Pump/pump_dashboared_screen.dart';

// class SideBar extends StatelessWidget {
//   final List<MenuItem> menuItems;

//   const SideBar({Key? key, required this.menuItems}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: const Color(0xFF6789CA),
//       child: ListView(
//         children: [
//           // const SizedBox(
//           //   height: 15,
//           // ),
//           for (var menuItem in menuItems)
//             Card(
//               elevation: 2,
//               color: const Color(0xFF6789CA),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.white, // Specify the color you want
//                     width: 1.0, // Specify the width of the border
//                   ),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     menuItem.icon,
//                     color: Colors.white,
//                   ),
//                   title: Text(
//                     menuItem.title,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   onTap: () {
//                     if (menuItem.onTap != null) {
//                       menuItem.onTap!();
//                     } else {
//                       Navigator.pop(context); // Close the drawer
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PumpDashboardScreen(
//                                   context: context,
//                                 )),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // models/sidebar.dart

// class MenuItem {
//   final IconData icon;
//   final String title;

//   final VoidCallback? onTap;

//   MenuItem({required this.icon, required this.title, this.onTap});
// }

import 'package:flutter/material.dart';
import 'package:myproject/Pump/pump_dashboared_screen.dart';

class SideBar extends StatelessWidget {
  final List<MenuItem> menuItems;

  const SideBar({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0, // Remove the shadow
      shape: Border.all(
        color: const Color(0xFF6789CA), // Make the border transparent
        width: 0, // Set the width to 0
      ),
      child: Container(
        color: const Color(0xFF6789CA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            for (var menuItem in menuItems)
              ListTile(
                leading: Icon(
                  menuItem.icon,
                  color: Colors.white,
                ),
                title: Text(
                  menuItem.title,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  if (menuItem.onTap != null) {
                    menuItem.onTap!();
                  } else {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PumpDashboardScreen(
                          context: context,
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  MenuItem({required this.icon, required this.title, this.onTap});
}
