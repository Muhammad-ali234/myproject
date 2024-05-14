import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Common/chat_roam.dart';
import 'package:myproject/Dashboared/Employee/employess_screen.dart';
import 'package:myproject/Dashboared/Employee/reg_employee.dart';
import 'package:myproject/Dashboared/Home_screen.dart';
import 'package:myproject/Authentication/login_screen.dart';
import 'package:myproject/Dashboared/Pump/account_request_screen.dart';
import 'package:myproject/Dashboared/Pump/petrol_price.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(3, 0), // Offset to the right
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(
                Icons.dashboard,
                color: Colors.teal,
              ),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardOwnerScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.perm_data_setting,
                color: Colors.teal,
              ),
              title: const Text('Employee Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmployeeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.price_change,
                color: Colors.teal,
              ),
              title: const Text('Petrol Price'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PetrolPriceScreen()),
                );
              },
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(
                Icons.account_box,
                color: Colors.teal,
              ),
              title: const Text('Requested Accounts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountRequested()),
                );
              },
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(
                Icons.account_box,
                color: Colors.teal,
              ),
              title: const Text('Chat  with Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.teal,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
