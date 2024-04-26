import 'package:flutter/material.dart';
import 'package:myproject/Pump/common/models/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final List<DrawerItem> drawerItems;

  const AppDrawer({
    super.key,
    required this.username,
    required this.drawerItems,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF6789CA),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Color(0xFF6789CA),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          for (var item in drawerItems)
            ListTile(
              leading: Icon(
                item.icon,
                color: const Color(0xFF6789CA),
              ),
              title: Text(
                item.title,
                style: const TextStyle(color: Color(0xFF6789CA), fontSize: 16),
              ),
              onTap: () {
                // Use Navigator to push the corresponding route
                Navigator.pushNamed(context, item.route);
              },
            ),
        ],
      ),
    );
  }
}
