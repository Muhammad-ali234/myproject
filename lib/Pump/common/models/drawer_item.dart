// Modify your DrawerItem class to include a route property
import 'package:flutter/material.dart';

class DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String route; // Add a route property

  DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.route,
  });
}
