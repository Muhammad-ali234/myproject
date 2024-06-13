import 'package:flutter/material.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Common/constant.dart';
import 'package:myproject/Pump/header_container.dart';
import 'package:myproject/Pump/info_container.dart';

class PumpDashboardScreen extends StatelessWidget {
  final BuildContext context;
  const PumpDashboardScreen({super.key, required this.context});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Dashboared Screen',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive UI logic
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return _buildMobileLayout(context);
          } else {
            // Web layout
            return _buildWebLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Sidebar
                SideBar(
                  menuItems: getMenuItems(context),
                ),
                // Main Content Area

                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Card_Widget(
                          name: "Petrol Diesel Stock",
                          inputIcon: Icons.storage,
                          onTap: () {
                            Navigator.pushNamed(context, '/stock');
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Card_Widget(
                          name: "Debit Credit ",
                          inputIcon: Icons.arrow_upward_outlined,
                          secondIcon: Icons.arrow_downward,
                          onTap: () {
                            Navigator.pushNamed(context, '/credit_debit');
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Card_Widget(
                          name: "Daily Overview",
                          inputIcon: Icons.credit_card,
                          onTap: () {
                            Navigator.pushNamed(context, '/daily_overview');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 20), // Add spacing between the rows of cards
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Card_Widget(
                          name: "Expense ",
                          inputIcon: Icons.attach_money,
                          onTap: () {
                            Navigator.pushNamed(context, '/daily_expense');
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Card_Widget(
                          name: "Total Customer",
                          inputIcon: Icons.person,
                          onTap: () {
                            Navigator.pushNamed(context, '/customerScreen');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Expanded(flex: 2, child: HeaderContainer()),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: InfoContainer(
                    icon: Icons.local_gas_station, // Changed icon
                    label: 'Petrol Diesel Stock',
                    onTap: () {
                      Navigator.pushNamed(context, '/stock');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoContainer(
                    icon: Icons.account_balance_wallet, // Changed icon
                    label: 'Debit Credit',
                    onTap: () {
                      Navigator.pushNamed(context, '/credit_debit');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: InfoContainer(
                    icon: Icons.timeline, // Changed icon
                    label: 'Daily Overview',
                    onTap: () {
                      Navigator.pushNamed(context, '/daily_overview');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoContainer(
                    icon: Icons.attach_money,
                    label: 'Expense',
                    onTap: () {
                      Navigator.pushNamed(context, '/daily_expense');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: InfoContainer(
                    icon: Icons.group, // Changed icon
                    label: 'Total Customer',
                    onTap: () =>
                        Navigator.pushNamed(context, '/customerScreen'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoContainer(
                    icon: Icons.work,
                    label: 'Employee Duties',
                    onTap: () {
                      Navigator.pushNamed(context, '/employeeDuty');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// web Card
class Card_Widget extends StatelessWidget {
  final String name;
  final IconData inputIcon;

  final IconData? secondIcon;
  final VoidCallback onTap;

  const Card_Widget({
    super.key,
    this.secondIcon,
    required this.inputIcon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: AppColor.dashbordBlueColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    inputIcon,
                    color: AppColor.dashbordWhiteColor,
                    size: 30.0,
                  ),
                  if (secondIcon != null) ...[
                    const SizedBox(height: 10.0),
                    Icon(
                      secondIcon,
                      color: AppColor.dashbordWhiteColor,
                      size: 30.0,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dashbordWhiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// mobile Card
class CardWidget extends StatelessWidget {
  final String name;
  final IconData inputIcon;
  final IconData? secondIcon;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    this.secondIcon,
    required this.inputIcon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: AppColor.dashbordBlueColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    inputIcon,
                    color: AppColor.dashbordWhiteColor,
                    size: 30.0,
                  ),
                  if (secondIcon != null) ...[
                    const SizedBox(width: 10.0),
                    Icon(
                      secondIcon,
                      color: AppColor.dashbordWhiteColor,
                      size: 30.0,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dashbordWhiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
