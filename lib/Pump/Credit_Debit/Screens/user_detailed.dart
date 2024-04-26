import 'package:flutter/material.dart';
import 'package:myproject/Authentication/service.dart';
import 'package:myproject/Pump/Credit_Debit/Models/user.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/Transaction_histry.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/service.dart';
import 'package:myproject/Pump/Credit_Debit/Widgets/add_creditdebit.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class UserDetailsScreen extends StatefulWidget {
  final Customer user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  double totalCredits = 0.0;
  double totalDebits = 0.0;
  List<Customer> users = [];

  @override
  Widget build(BuildContext context) {
    totalCredits = widget.user.credit!;
    totalDebits = widget.user.debit!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.name,
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
            // For larger screens (e.g., tablets, desktops)
            return _buildWebLayout();
          } else {
            // For smaller screens (e.g., mobile phones)
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SideBar(
          menuItems: getMenuItems(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: IntrinsicWidth(
                child: SizedBox(
                  height: 385,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoTile('Name', widget.user.name, Icons.person),
                      _buildInfoTile('Email', widget.user.email, Icons.email),
                      _buildInfoTile(
                          'Contact', widget.user.contact, Icons.phone),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTotalTile('Total Credits', totalCredits,
                              Icons.arrow_upward, Colors.green),
                          _buildTotalTile('Total Debits', totalDebits,
                              Icons.arrow_downward, Colors.red),
                          const SizedBox(height: 32),
                          _buildActionButtons('web'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('Name', widget.user.name, Icons.person),
            _buildInfoTile('Email', widget.user.email, Icons.email),
            _buildInfoTile('Contact', widget.user.contact, Icons.phone),
            const SizedBox(height: 16),
            _buildTotalTile('Total Credits', totalCredits, Icons.arrow_upward,
                Colors.green),
            _buildTotalTile(
                'Total Debits', totalDebits, Icons.arrow_downward, Colors.red),
            const SizedBox(height: 32),
            _buildActionButtons('mob'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String platform) {
    if (platform == 'web') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
              'Add Debit', 'Debit', Icons.add, Colors.green, 200),
          const SizedBox(height: 16),
          _buildActionButton(
              'Add Credit', 'Credit', Icons.remove, Colors.red, 200),
          const SizedBox(height: 16),
          _buildActionButton(
              'View Credits/Debits', 'View', Icons.list, Colors.blue, 200),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                  'Add Debit', 'Debit', Icons.add, Colors.green, 120),
              const SizedBox(height: 16),
              _buildActionButton(
                  'Add Credit', 'Credit', Icons.remove, Colors.red, 120),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButton(
              'View Credits/Debits', 'View', Icons.list, Colors.blue, 170),
        ],
      );
    }
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildTotalTile(
      String title, double total, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text('$title: $total'),
    );
  }

  Widget _buildActionButton(
      String text, String type, IconData icon, Color color, double width) {
    final creditDebitService = CreditDebitService();
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (type == 'Debit') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddCreditDialog(
                  type: 'Debit',
                  id: widget.user.id,
                  onTransactionSaved: (double amount) async {
                    await creditDebitService.updateCustomerTransaction(
                      widget.user.id,
                      amount,
                      false,
                    );
                    setState(() {
                      widget.user.debit = (widget.user.debit ?? 0) + amount;
                    });
                  },
                );
              },
            );
          } else if (type == 'Credit') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddCreditDialog(
                  type: 'Credit',
                  id: widget.user.id,
                  onTransactionSaved: (double amount) async {
                    await creditDebitService.updateCustomerTransaction(
                      widget.user.id,
                      amount,
                      true,
                    );
                    setState(() {
                      widget.user.credit = (widget.user.credit ?? 0) + amount;
                    });
                  },
                );
              },
            );
          } else if (type == 'View') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionHistoryScreen(customerId: widget.user.id),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
