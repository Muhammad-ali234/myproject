import 'package:flutter/material.dart';
import 'package:myproject/Pump/common/models/drawer_item.dart';

List<DrawerItem> getDrawerMenuItems(BuildContext context) {
  return [
    DrawerItem(
      icon: Icons.dashboard,
      title: 'Home',
      onTap: () {
        Navigator.pushNamed(context, '/dashboardScreen');
        Navigator.pop(context);
      },
      route: '/dashboardPumpScreen',
    ),
    DrawerItem(
      icon: Icons.attach_money,
      title: 'Expense',
      onTap: () {
        Navigator.pushNamed(context, '/daily_expense');
        Navigator.pop(context);
      },
      route: '/daily_expense',
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Customer',
      onTap: () {
        Navigator.pushNamed(context, '/customerScreen');
        Navigator.pop(context);
      },
      route: '/customerScreen',
    ),
    DrawerItem(
      icon: Icons.arrow_upward_outlined,
      title: 'Debit Credit',
      onTap: () {
        Navigator.pushNamed(context, '/credit_debit');
        Navigator.pop(context);
      },
      route: '/credit_debit',
    ),
    DrawerItem(
      icon: Icons.credit_card,
      title: 'Daily Overview',
      onTap: () {
        Navigator.pushNamed(context, '/daily_overview');
        Navigator.pop(context);
      },
      route: '/daily_overview',
    ),
    DrawerItem(
      icon: Icons.storage,
      title: 'Petrol Diesel Stock',
      onTap: () {
        Navigator.pushNamed(context, '/stock');
        Navigator.pop(context);
      },
      route: '/stock',
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Employee Duties',
      onTap: () {
        Navigator.pushNamed(context, '/employeeDuty');
        Navigator.pop(context);
      },
      route: '/employeeDuty',
    ),
    DrawerItem(
      icon: Icons.storage,
      title: 'Chat with Us ',
      onTap: () {
        Navigator.pushNamed(context, '/pumpchatScreen');
      },
      route: '/pumpchatScreen',
    ),
    DrawerItem(
        icon: Icons.logout,
        title: 'Log Out',
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        route: '/login')
  ];
}
