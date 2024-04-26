import 'package:flutter/material.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/Transaction_histry.dart';
import 'package:myproject/Pump/Credit_Debit/Models/user.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:myproject/Pump/Customer/customer_screen.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer user;

  const CustomerDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
          if (constraints.maxWidth > 600) {
            // For larger screens (e.g., tablets, web), show a split-screen layout
            return _buildWebLayout(context);
          } else {
            // For smaller screens (e.g., phones), show a single-column layout
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        SideBar(
          menuItems: getMenuItems(context),
        ),
        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: IntrinsicWidth(
                child: SizedBox(
                  height: 385,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoTile('Name', user.name, Icons.person),
                      _buildInfoTile('Email', user.email, Icons.email),
                      _buildInfoTile('Contact', user.contact, Icons.phone),
                      _buildTotalTile('Total Credits', user.credit!,
                          Icons.arrow_upward, Colors.green),
                      _buildTotalTile('Total Debits', user.debit!,
                          Icons.arrow_downward, Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('Name', user.name, Icons.person),
            _buildInfoTile('Email', user.email, Icons.email),
            _buildInfoTile('Contact', user.contact, Icons.phone),
            _buildTotalTile('Total Credits', user.credit!, Icons.arrow_upward,
                Colors.green),
            _buildTotalTile(
                'Total Debits', user.debit!, Icons.arrow_downward, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.blue, // Custom icon color
                size: 24, // Custom icon size
              ),
              const SizedBox(width: 16), // Spacing between icon and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Custom title font size
                      color: Colors.black, // Custom title color
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Spacing between title and subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16, // Custom subtitle font size
                      color: Colors.grey[600], // Custom subtitle color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[500], thickness: 1),
      ],
    );
  }

  Widget _buildTotalTile(
      String title, double total, IconData icon, Color iconColor) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text('$title: $total'),
        ),
        Divider(color: Colors.grey[500], thickness: 1), // Add a horizontal line
      ],
    );
  }

  void _navigateToCreditDebitFormScreen(BuildContext context, String type) {
    if (type == 'Credit' || type == 'Debit') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => CreditDebitFormScreen(type: type, user: ,)),
      // );
    } else if (type == 'View') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerScreen(
                  context: context,
                )),
      );
    }
  }
}
