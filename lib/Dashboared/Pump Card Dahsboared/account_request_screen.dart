import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/sidebar.dart';

class AccountRequested extends StatelessWidget {
  const AccountRequested({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requested Accounts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For tablets and larger screens
            return _buildWebLayout(context);
          } else {
            // For mobile devices
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        const CustomDrawer(),
        VerticalDivider(
          thickness: 1,
          color: Colors.grey.shade600,
        ),
        Expanded(
          // Ensure the ListView takes up remaining space
          child: ListView(
            children: [
              _buildRequestItem(context, 'John Doe', 'john.doe@example.com'),
              _buildRequestItem(
                  context, 'Jane Smith', 'jane.smith@example.com'),
              // Add more request items as needed
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildRequestItem(context, 'John Doe', 'john.doe@example.com'),
          _buildRequestItem(context, 'Jane Smith', 'jane.smith@example.com'),
          // Add more request items as needed
        ],
      ),
    );
  }

  Widget _buildRequestItem(BuildContext context, String name, String email) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(context, 'Confirm', Colors.green, () {
              // Add functionality for confirm button
            }),
            const SizedBox(width: 8.0),
            _buildActionButton(context, 'Cancel', Colors.red, () {
              // Add functionality for cancel button
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, Color color,
      void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
