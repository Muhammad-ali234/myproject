import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myproject/Dashboared/sidebar.dart';

class PetrolPumpStatus extends StatelessWidget {
  const PetrolPumpStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Petrol Pump Status',
          style: TextStyle(color: Colors.white),
        ),
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
            return _buildWebLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWebLayout(context) {
    return Row(
      children: [
        const CustomDrawer(),
        // Divider
        VerticalDivider(
          thickness: 1,
          color: Colors.grey.shade600,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchFilter(context),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: const [
                      PetrolPumpCard(
                        title: 'Total Stock',
                        children: [
                          DashboardInfoItem(
                              label: 'Petrol', value: '1000 Litres'),
                          DashboardInfoItem(
                              label: 'Diesel', value: '1500 Litres'),
                        ],
                      ),
                      SizedBox(height: 20),
                      PetrolPumpCard(
                        title: 'Today\'s Summary',
                        children: [
                          DashboardInfoItem(
                              label: 'Total Sale', value: '\$500'),
                          DashboardInfoItem(
                              label: 'Total Readings', value: '50'),
                        ],
                      ),
                      SizedBox(height: 20),
                      PetrolPumpCard(
                        title: 'Employee Information',
                        children: [
                          DashboardInfoItem(
                              label: 'Total Employees', value: '20'),
                          DashboardInfoItem(
                              label: 'Active Employees', value: '18'),
                        ],
                      ),
                      SizedBox(height: 20),
                      PetrolPumpCard(
                        title: 'Overall Statistics',
                        children: [
                          DashboardInfoItem(
                              label: 'Total Credit', value: '\$2000'),
                          DashboardInfoItem(
                              label: 'Total Debit', value: '\$1500'),
                          DashboardInfoItem(
                              label: 'Total Expenses', value: '\$1000'),
                          DashboardInfoItem(
                              label: 'Total Profit', value: '\$500'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchFilter(context),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                PetrolPumpCard(
                  title: 'Total Stock',
                  children: [
                    DashboardInfoItem(label: 'Petrol', value: '1000 Litres'),
                    DashboardInfoItem(label: 'Diesel', value: '1500 Litres'),
                  ],
                ),
                SizedBox(height: 20),
                PetrolPumpCard(
                  title: 'Today\'s Summary',
                  children: [
                    DashboardInfoItem(label: 'Total Sale', value: '\$500'),
                    DashboardInfoItem(label: 'Total Readings', value: '50'),
                  ],
                ),
                SizedBox(height: 20),
                PetrolPumpCard(
                  title: 'Employee Information',
                  children: [
                    DashboardInfoItem(label: 'Total Employees', value: '20'),
                    DashboardInfoItem(label: 'Active Employees', value: '18'),
                  ],
                ),
                SizedBox(height: 20),
                PetrolPumpCard(
                  title: 'Overall Statistics',
                  children: [
                    DashboardInfoItem(label: 'Total Credit', value: '\$2000'),
                    DashboardInfoItem(label: 'Total Debit', value: '\$1500'),
                    DashboardInfoItem(label: 'Total Expenses', value: '\$1000'),
                    DashboardInfoItem(label: 'Total Profit', value: '\$500'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter by:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2015, 8),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              // Implement filtering logic based on pickedDate
              print('Selected date: $pickedDate');
            }
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}

class PetrolPumpCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PetrolPumpCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const DashboardInfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
