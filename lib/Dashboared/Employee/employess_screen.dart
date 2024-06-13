import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Employee/add_employee_sacreen.dart';
import 'package:myproject/Dashboared/Employee/reg_employee.dart';
import 'package:myproject/Dashboared/dashbored_styles.dart';
import 'package:myproject/Dashboared/sidebar.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  int _currentIndex = 0; // 0: Registered Employees, 1: Add Employee

  void _setScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Employee Management', style: AppStyle.textWhiteColorHeader()),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For wider screens (e.g., tablets, desktops)
            return _buildWideLayout();
          } else {
            // For narrow screens (e.g., mobile phones)
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        const Expanded(
            flex: 1, child: CustomDrawer()), // Sidebar for wide layout

        const VerticalDivider(thickness: 1, color: Colors.grey),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5, // Elevation for shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // Background color
                      borderRadius:
                          BorderRadius.circular(10), // Same as Card shape
                    ),
                    height: 90, // Fixed height
                    width: double.infinity, // Takes the full width
                    child: const Padding(
                      padding: EdgeInsets.all(
                          16.0), // Uniform padding inside the card
                      child: Row(
                        children: [
                          // Text column
                          Expanded(
                            // Takes available space but doesn't affect the icon
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Aligns text to the start
                              children: [
                                Text(
                                  'Total Employees: 100', // Example data
                                  style: TextStyle(
                                    fontSize: 20, // Header-like font size
                                    color:
                                        Colors.black, // White text for contrast
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                                Text(
                                  'Full-Time: 70, Part-Time: 20, Contract: 10', // Example data
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Icon
                          Icon(
                            Icons.people,
                            size: 40, // Larger icon
                            color: Colors.black, // Consistent with text color
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 5),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: AppStyle.dashbordButton(),
                        onPressed: () => _setScreen(0),
                        child: Text(
                          'Registered Employees',
                          style: AppStyle.textWhiteColor(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: AppStyle.dashbordButton(),
                        onPressed: () => _setScreen(1),
                        child: Text(
                          'Add Employee',
                          style: AppStyle.textWhiteColor(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildMobileLayout() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Card(
  //           elevation: 5, // Elevation for shadow
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10), // Rounded corners
  //           ),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               // Background color
  //               borderRadius: BorderRadius.circular(10), // Same as Card shape
  //             ),
  //             height: 90, // Fixed height
  //             width: double.infinity, // Takes the full width
  //             child: const Padding(
  //               padding:
  //                   EdgeInsets.all(16.0), // Uniform padding inside the card
  //               child: Row(
  //                 children: [
  //                   // Text column
  //                   Expanded(
  //                     // Takes available space but doesn't affect the icon
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment:
  //                           MainAxisAlignment.start, // Aligns text to the start
  //                       children: [
  //                         Text(
  //                           'Total Employees: 100', // Example data
  //                           style: TextStyle(
  //                             fontSize: 20, // Header-like font size
  //                             color: Colors.black, // White text for contrast
  //                             fontWeight: FontWeight.bold, // Bold text
  //                           ),
  //                         ),
  //                         Text(
  //                           'Full-Time: 70, Part-Time: 20, Contract: 10', // Example data
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Icon
  //                   Icon(
  //                     Icons.people,
  //                     size: 40, // Larger icon
  //                     color: Colors.black, // Consistent with text color
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 8, left: 8),
  //           child: Row(
  //             children: [
  //               ElevatedButton(
  //                 style: AppStyle.dashbordButton(),
  //                 onPressed: () => _setScreen(0),
  //                 child: Text(
  //                   'Registered Employees',
  //                   style: AppStyle.textWhiteColor(),
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //               ElevatedButton(
  //                 style: AppStyle.dashbordButton(),
  //                 onPressed: () => _setScreen(1),
  //                 child: Text(
  //                   'Add Employee',
  //                   style: AppStyle.textWhiteColor(),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Expanded(
  //           child: _buildContent(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Employees: 100',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Full-Time: 70, Part-Time: 20, Contract: 10',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Section
                    Icon(
                      Icons.people,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Navigation Buttons Section
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: AppStyle.dashbordButton(),
                  onPressed: () => _setScreen(0),
                  child: Text(
                    'Registered Employees',
                    style: AppStyle.textWhiteColor(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: AppStyle.dashbordButton(),
                  onPressed: () => _setScreen(1),
                  child: Text(
                    'Add Employee',
                    style: AppStyle.textWhiteColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content Section
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_currentIndex == 0) {
      return const RegisterEmployeeScreen();
    } else {
      return const AddEmployeeScreen();
    }
  }
}
