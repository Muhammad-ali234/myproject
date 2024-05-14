import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/Dashboared/Employee/employee_service.dart';
import 'package:myproject/Dashboared/dashbored_styles.dart';
import 'package:myproject/Dashboared/widget/droped_down_button.dart';
import 'package:intl/intl.dart';

class RegisterEmployeeScreen extends StatefulWidget {
  const RegisterEmployeeScreen({super.key});

  @override
  State<RegisterEmployeeScreen> createState() => _RegisterEmployeeScreenState();
}

class _RegisterEmployeeScreenState extends State<RegisterEmployeeScreen> {
  final EmployeeService employeeService = EmployeeService();

  DocumentReference? pumpDocument;
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

  void selectPump(String email) async {
    try {
      pumpDocument = await employeeService.getPumpDocumentByEmail(email);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error finding pump: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Function to confirm employee deletion
  void deleteEmployee(String employeeId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Employee"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await employeeService.deleteEmployee(employeeId, pumpDocument!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Employee deleted successfully")),
                );
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Function to delete employee with error handling

  void openDutyTimingDialog(String employeeId) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Set Duty Timing"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Start Time"),
                trailing: TextButton(
                  child: const Text("Select"),
                  onPressed: () async {
                    final TimeOfDay? pickedStartTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedStartTime != null) {
                      startTime = pickedStartTime;
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("End Time"),
                trailing: TextButton(
                  child: const Text("Select"),
                  onPressed: () async {
                    final TimeOfDay? pickedEndTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedEndTime != null) {
                      endTime = pickedEndTime;
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (startTime != null && endTime != null) {
                  final now = DateTime.now();
                  final startDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    startTime!.hour,
                    startTime!.minute,
                  );
                  final endDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    endTime!.hour,
                    endTime!.minute,
                  );

                  await employeeService.setEmployeeDutyTiming(
                    employeeId,
                    startDateTime,
                    endDateTime,
                    "extra_argument",
                    pumpDocument!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Duty Scheduled Successfuly'),
                      backgroundColor: Colors.green));

                  Navigator.of(context).pop(); // Close dialog after saving
                }
              },
              child: const Text("Set Schedule"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return _buildMobileLayout();
      } else {
        return _buildWebLayout();
      }
    });
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 20, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<List<String>>(
                stream: employeeService
                    .getRegisteredPumpsStream(), // Get the list of pumps
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading state
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text("Error fetching pumps"); // Error state
                  }

                  return DropdownFilterButton(
                    backgroundColor: Colors.grey,

                    options: snapshot.data!, // List of pump names
                    onChanged: (String value) {
                      setState(() {
                        selectPump(value);
                      });
                    },
                  );
                },
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value; // Update search term
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search Employee...',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _buildRegisteredEmployeesStream(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWebLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 2, bottom: 10, left: 10, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<List<String>>(
                    stream: employeeService
                        .getRegisteredPumpsStream(), // Get the list of pumps
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading state
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text(
                            "Error fetching pumps"); // Error state
                      }

                      return DropdownFilterButton(
                        backgroundColor: Colors.grey,
                        options: snapshot.data!, // List of pump names
                        onChanged: (value) {
                          setState(() {
                            selectPump(value);
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value; // Update search term
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Search Employee...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: _buildRegisteredEmployeesStream(),
        ),
      ],
    );
  }

  Widget _buildRegisteredEmployeesStream() {
    if (pumpDocument == null) {
      return const Center(
          child: Text("No pump document found. Select a pump."));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: employeeService.getEmployeesStream(pumpDocument!),
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

        var filteredEmployees = snapshot.data!.docs.where((doc) {
          var employee = doc.data() as Map<String, dynamic>;
          var name = employee['name']
              .toString()
              .toLowerCase(); // Convert to lowercase for case-insensitive search

          if (searchTerm == null || searchTerm!.isEmpty) {
            return true; // If no search term, show all
          }

          return name.contains(searchTerm!
              .toLowerCase()); // Check if name contains the search term
        }).toList();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var employee = doc.data() as Map<String, dynamic>;

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
                      // Employee details
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.blueAccent,
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
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          deleteEmployee(doc.id);
                                        });
                                      },
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
                                      'Contact: ${employee['contact'] ?? "N/A"}', // Use null-aware operator
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Salary: \$${employee['salary'] ?? "N/A"}', // Default value if null
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Role: ${employee['role'] ?? "N/A"}', // Default to "N/A" if null
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Duty Start: ${formatTimeSafe(convertToDateTime(employee['duty_start']))}', // Handle Timestamp conversion and null
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Duty End: ${formatTimeSafe(convertToDateTime(employee['duty_end']))}', // Handle Timestamp conversion and null
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: AppStyle.dashbordButton(),
                                      onPressed: () {
                                        openDutyTimingDialog(doc.id);
                                        print(doc.id);
                                      },
                                      child: Text(
                                        'schedule',
                                        style: AppStyle.textWhiteColor(),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
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
