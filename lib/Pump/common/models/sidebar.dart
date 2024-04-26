// sidebar_menu_item_model.dart

import 'package:flutter/material.dart';

class SidebarMenuItemModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SidebarMenuItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
