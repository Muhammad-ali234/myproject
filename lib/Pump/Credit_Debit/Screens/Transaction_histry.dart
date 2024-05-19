import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/service.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Common/constant.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String customerId;

  const TransactionHistoryScreen({super.key, required this.customerId});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final CreditDebitService _creditDebitService = CreditDebitService();
  late Future<List<Map<String, dynamic>>> _transactionHistoryFuture;

  @override
  void initState() {
    super.initState();
    _transactionHistoryFuture =
        _creditDebitService.getTransactionHistory(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Transaction History',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.dashbordWhiteColor),
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
      children: [
        SideBar(
          menuItems: getMenuItems(context),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _transactionHistoryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, dynamic>> transactionHistory = snapshot.data!;
                return ListView.builder(
                  itemCount: transactionHistory.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> transaction =
                        transactionHistory[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Amount: ${transaction['amount']}'),
                        subtitle: Text(
                            'Type: ${transaction['isCredit'] ? 'Credit' : 'Debit'}'),
                        trailing: Text(
                            'Date: ${_formatTimestamp(transaction['timestamp'])}'),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _transactionHistoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> transactionHistory = snapshot.data!;
          return ListView.builder(
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> transaction = transactionHistory[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Amount: ${transaction['amount']}'),
                  subtitle: Text(
                      'Type: ${transaction['isCredit'] ? 'Credit' : 'Debit'}'),
                  trailing: Text(
                      'Date: ${_formatTimestamp(transaction['timestamp'])}'),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else {
      return 'Invalid Timestamp';
    }
  }
}
