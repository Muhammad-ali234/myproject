import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/Dashboared/Employee/employee_service.dart';
import 'package:myproject/Dashboared/dashbored_styles.dart';
import 'package:myproject/Dashboared/sidebar.dart';
import 'package:myproject/Dashboared/widget/droped_down_button.dart'; // Custom drop-down button

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final EmployeeService employeeService = EmployeeService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String? selectedPump; // Track the selected pump

  Future<void> addEmployee(BuildContext context) async {
    if (!_formKey.currentState!.validate() || selectedPump == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectedPump == null
              ? "Please select a pump."
              : "Please correct the form errors."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final employeeData = {
      'name': nameController.text,
      'contact': contactController.text,
      'salary': double.tryParse(salaryController.text) ?? 0.0,
      'role': roleController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    String result =
        await employeeService.addEmployeeToPump(employeeData, selectedPump!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
        backgroundColor:
            result.startsWith("Error") ? Colors.red : Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Employee")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout(context);
          } else {
            return _buildWebLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField(nameController, 'Name', Icons.person,
                  (value) => value!.isEmpty ? 'Enter a name' : null),
              const SizedBox(height: 10),
              _buildTextField(contactController, 'Contact', Icons.phone,
                  (value) => value!.isEmpty ? 'Enter contact number' : null),
              const SizedBox(height: 10),
              _buildTextField(salaryController, 'Salary', Icons.attach_money,
                  (value) => value!.isEmpty ? 'Enter salary' : null,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(roleController, 'Role', Icons.home,
                  (value) => value!.isEmpty ? 'Enter an role' : null),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPumpDropdown(),
                  ElevatedButton(
                    style: AppStyle.dashbordButton(),
                    onPressed: () => addEmployee(context),
                    child: Text(
                      "Add Employee",
                      style: AppStyle.textWhiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(
                          nameController,
                          'Name',
                          Icons.person,
                          (value) => value!.isEmpty ? 'Enter a name' : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(
                          contactController,
                          'Contact',
                          Icons.phone,
                          (value) =>
                              value!.isEmpty ? 'Enter contact number' : null)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(
                          salaryController,
                          'Salary',
                          Icons.money_rounded,
                          (value) => value!.isEmpty ? 'Enter salary' : null,
                          keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(
                          roleController,
                          'Role',
                          Icons.work_rounded,
                          (value) => value!.isEmpty ? 'Enter a role' : null)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPumpDropdown(),
                  ElevatedButton(
                    style: AppStyle.dashbordButton(),
                    onPressed: () => addEmployee(context),
                    child: Text(
                      "Add Employee",
                      style: AppStyle.textWhiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPumpDropdown() {
    return StreamBuilder<List<String>>(
      stream: employeeService.getRegisteredPumpsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {}

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("Error fetching pumps."); // Display error message
        }

        List<String> pumpOptions =
            snapshot.data!; // Extract the list of pump names

        return Container(
          width: 250,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Center(
            child: DropdownFilterButton(
              options: pumpOptions, // Use the extracted pump list
              onChanged: (String? newValue) {
                setState(() {
                  selectedPump = newValue; // Set the new value
                });
              },
              initialHint: 'Select Pump', // Hint for when nothing is selected
              backgroundColor: Colors.blue, // Background color for the button
              iconColor: Colors.white, // Color for the dropdown icon
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      IconData icon, FormFieldValidator<String> validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
