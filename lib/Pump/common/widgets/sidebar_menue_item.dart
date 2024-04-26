import 'package:flutter/material.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';

List<MenuItem> getMenuItems(BuildContext context) {
  return [
    MenuItem(
      icon: Icons.home,
      title: 'Home',
      onTap: () {
        Navigator.pushNamed(context, '/dashboardPumpScreen');
      },
    ),
    MenuItem(
      icon: Icons.attach_money,
      title: 'Expense',
      onTap: () {
        Navigator.pushNamed(context, '/daily_expense');
      },
    ),
    MenuItem(
      icon: Icons.person,
      title: 'Customer',
      onTap: () {
        Navigator.pushNamed(context, '/customerScreen');
      },
    ),
    MenuItem(
      icon: Icons.arrow_upward_outlined,
      title: 'Debit Credit',
      onTap: () {
        Navigator.pushNamed(context, '/credit_debit');
      },
    ),
    MenuItem(
      icon: Icons.credit_card,
      title: 'Daily Overview',
      onTap: () {
        Navigator.pushNamed(context, '/daily_overview');
      },
    ),
    MenuItem(
      icon: Icons.storage,
      title: 'Petrol Diesel Stock ',
      onTap: () {
        Navigator.pushNamed(context, '/stock');
      },
    ),
    MenuItem(
      icon: Icons.logout,
      title: 'Log Out',
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
    ),
  ];
}
