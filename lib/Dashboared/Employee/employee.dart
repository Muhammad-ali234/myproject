import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/sidebar.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen(BuildContext context, {super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  final TextEditingController roleController = TextEditingController();

  String selectedEmployee = '';
  final List<int> registeredPumps = [1, 2, 3, 4, 5];

  // Dummy data for already registered employees
  final List<Map<String, dynamic>> registeredEmployees = [
    {
      'name': 'John Doe',
      'contact': '1234567890',
      'salary': 50000,
      'role': 'Manager'
    },
    {
      'name': 'Jane Smith',
      'contact': '9876543210',
      'salary': 60000,
      'role': 'Developer'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Employee'),
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
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return _buildMobileLayout();
          } else {
            // Web layout
            return _buildWebLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSearchFilter(context),
            const Divider(),
            _buildRegisteredEmployeesCard(),
            const SizedBox(height: 20),
            _buildTextField(
              controller: nameController,
              labelText: 'Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: contactController,
              labelText: 'Contact',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: salaryController,
              labelText: 'Salary',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: roleController,
              labelText: 'Role',
              icon: Icons.work,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle saving employee data
                String name = nameController.text;
                String contact = contactController.text;
                double salary = double.tryParse(salaryController.text) ?? 0.0;
                String role = roleController.text;

                // Perform validation if needed

                // Now you can use the employee data as needed
                // For example, you could save it to a database, display it in a list, etc.
              },
              child: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomDrawer(),
        VerticalDivider(
          thickness: 1,
          color: Colors.grey.shade600,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSearchFilter(context),
                const Divider(),
                _buildRegisteredEmployeesCard(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: nameController,
                              labelText: 'Name',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: contactController,
                              labelText: 'Contact',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: salaryController,
                              labelText: 'Salary',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: roleController,
                              labelText: 'Role',
                              icon: Icons.work,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle saving employee data
                    String name = nameController.text;
                    String contact = contactController.text;
                    double salary =
                        double.tryParse(salaryController.text) ?? 0.0;
                    String role = roleController.text;

                    // Perform validation if needed

                    // Now you can use the employee data as needed
                    // For example, you could save it to a database, display it in a list, etc.
                  },
                  child: const Text('Add Employee'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildRegisteredEmployeesCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registered Employees',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: registeredEmployees.map((employee) {
                return ListTile(
                  title: Text(employee['name']),
                  subtitle: Text(
                      'Contact: ${employee['contact']} | Salary: ${employee['salary']} | Role: ${employee['role']}'),
                );
              }).toList(),
            ),
          ],
        ),
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
            // Simulating filter by registered pump
            // You can replace this logic with your actual filter implementation
            final int? selectedPump = await showDialog<int>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Select Pump'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: registeredPumps.map((pumpNumber) {
                    return ListTile(
                      title: Text('Pump $pumpNumber'),
                      onTap: () {
                        Navigator.of(context).pop(pumpNumber);
                      },
                    );
                  }).toList(),
                ),
              ),
            );

            if (selectedPump != null) {
              // Implement filtering logic based on selectedPump
              print('Selected pump: $selectedPump');
            }
          },
          child: const Text('Select Pump'),
        ),
      ],
    );
  }
}
