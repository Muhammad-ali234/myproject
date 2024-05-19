import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myproject/Pump/Employee%20screen/service.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Common/constant.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class EmployeeDutiesScreen extends StatefulWidget {
  const EmployeeDutiesScreen({super.key});

  @override
  State<EmployeeDutiesScreen> createState() => _EmployeeDutiesScreenState();
}

class _EmployeeDutiesScreenState extends State<EmployeeDutiesScreen> {
  final EmployeeDutyService employeeDutyService = EmployeeDutyService();
  String? searchTerm;
  DateTime? convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate(); // Convert Firestore Timestamp to DateTime
    } else if (value is DateTime) {
      return value; // Already a DateTime
    } else {
      return null; // Unknown type, return null
    }
  }

// Helper function to format DateTime safely
  String formatTimeSafe(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A'; // Return a default value if null
    }
    final DateFormat formatter =
        DateFormat('hh:mm a'); // 12-hour format with AM/PM
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor
              .dashbordWhiteColor, // Change the color of the back icon here
        ),
        title: Text(
          'Empoyee Duties Screen',
          style: TextStyle(color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Employee Duties Screen',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          } else {
            return _buildWebLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search employees...',
                hintStyle: TextStyle(color: AppColor.dashbordBlueColor),
                border: const OutlineInputBorder(),
                suffixIcon:
                    Icon(Icons.search, color: AppColor.dashbordBlueColor),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase(); // Store the search term
                });
              },
            ),
          ),
          Expanded(
            child: _buildRegisteredEmployeesStream(),
          ),
          const SizedBox(height: 20),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search employees...',
                    hintStyle: TextStyle(color: AppColor.dashbordBlueColor),
                    border: const OutlineInputBorder(),
                    suffixIcon:
                        Icon(Icons.search, color: AppColor.dashbordBlueColor),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value.toLowerCase(); // Store the search term
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildRegisteredEmployeesStream(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisteredEmployeesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: employeeDutyService.getEmployeesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text("Error fetching registered employees"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No registered employees found"));
        }

        // Filter employees based on the search term
        var filteredEmployees = snapshot.data!.docs.where((doc) {
          var employee = doc.data() as Map<String, dynamic>;
          var name = employee['name'].toLowerCase();

          if (searchTerm == null || searchTerm!.isEmpty) {
            return true; // If no search term, show all
          }

          return name.contains(searchTerm!); // Case-insensitive filtering
        }).toList();

        return ListView.builder(
          itemCount: filteredEmployees.length,
          itemBuilder: (context, index) {
            var employeeDoc = filteredEmployees[index];
            var employee = employeeDoc.data() as Map<String, dynamic>;

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColor.dashbordBlueColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    employee['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact: ${employee['contact'] ?? "N/A"}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Salary: \$${employee['salary'] ?? "N/A"}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Role: ${employee['role'] ?? "N/A"}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Duty Start: ${formatTimeSafe(convertToDateTime(employee['duty_start']))}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Duty End: ${formatTimeSafe(convertToDateTime(employee['duty_end']))}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
