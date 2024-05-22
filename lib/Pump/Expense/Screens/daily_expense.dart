import 'package:flutter/material.dart';
import 'package:myproject/Pump/Expense/Models/expense.dart';
import 'package:myproject/Pump/Expense/Screens/service.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Common/constant.dart';

import '../Widgets/expense_card.dart';

// ignore: must_be_immutable
class DailyExpenseScreen extends StatefulWidget {
  final BuildContext context;

  const DailyExpenseScreen({super.key, required this.context});

  @override
  _DailyExpenseScreenState createState() => _DailyExpenseScreenState();
}

class _DailyExpenseScreenState extends State<DailyExpenseScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  ExpenseService _expenseService = ExpenseService();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadTotalExpense();
    _expenseService = ExpenseService();
  }

  List<Expense> expenses = [];
  int totalExpense = 0;
  // Method to show the expense form dialog
  void _showExpenseFormDialog() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expense'),
          content: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.dashbordWhiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(nameController, 'Expense Name',
                        (value) {
                      if (value!.isEmpty) {
                        return 'Please enter expense name';
                      }
                      return null;
                    }),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      detailController,
                      'Expense Detail',
                      (value) {
                        if (value!.isEmpty) {
                          return 'Please enter expense detail';
                        }
                        return null;
                      },
                      TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      amountController,
                      'Expense Amount',
                      (value) {
                        if (value!.isEmpty) {
                          return 'Please enter expense amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      dateController,
                      'Expense Date (YYYY-MM-DD)',
                      (value) {
                        if (value!.isEmpty) {
                          return 'Please enter expense date';
                        }
                        RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                        if (!datePattern.hasMatch(value)) {
                          return 'Please enter a valid date in the format YYYY-MM-DD';
                        }
                        return null;
                      },
                      TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    _buildSaveButton(formKey),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.dashbordBlueColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    AppColor.dashbordWhiteColor),
              ),
              onPressed: () {
                // Close the dialog

                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      String? Function(String?)? validator,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildSaveButton(GlobalKey<FormState> formKey) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColor.dashbordWhiteColor),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColor.dashbordBlueColor),
      ),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          _saveExpense();
          Navigator.pop(context, _createNewExpense());
        }
      },
      child: const Text('Save Expense'),
    );
  }

  // Method to build a text field widget
  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _saveExpense() async {
    String expenseId = UniqueKey().toString();
    Expense newExpense = Expense(
      id: expenseId,
      name: nameController.text,
      amount: int.parse(amountController.text),
      date: dateController.text,
      detail: detailController.text,
    );

    void updateExpense0(String expenseId) async {
      Expense updateExpense = Expense(
        id: expenseId,
        name: nameController.text,
        amount: int.parse(amountController.text),
        date: dateController.text,
        detail: detailController.text,
      );
    }

    try {
      await _expenseService.addExpense(newExpense, expenseId);
      // Refresh total expense after adding new expense
      int totalExpense = await _expenseService.getTotalExpense();
      _saveTotalExpense(totalExpense + newExpense.amount);

      setState(() {
        expenses.add(newExpense);
      }); // Update total expense
    } catch (e) {
      // Handle error
      print("Error saving expense: $e");
      // Optionally, show error message to the user
    }

    nameController.clear();
    amountController.clear();
    dateController.clear();
    detailController.clear();
  }

  // Calculate total expense
  int _calculateTotalExpense() {
    return expenses.map((expense) => expense.amount).fold(0, (a, b) => a + b);
  }

  void _saveTotalExpense(int totalExpense) async {
    try {
      await _expenseService.saveTotalExpense(totalExpense);
    } catch (e) {
      // Handle error
      print("Error saving total expense: $e");
      // Optionally, show error message to the user
    }
  }

  Expense _createNewExpense() {
    String expenseId = UniqueKey().toString(); // Generate a unique id
    return Expense(
        id: expenseId,
        name: nameController.text,
        amount: int.parse(amountController.text),
        date: dateController.text,
        detail: detailController.text);
  }

  // Method to fetch expenses from Firestore
  void _loadExpenses() async {
    try {
      List<Expense> fetchedExpenses = await _expenseService.fetchExpenses();
      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (e) {
      print("Error loading expenses: $e");
      // Handle error
    }
  }

  // Method to fetch total expense from Firestore
  void _loadTotalExpense() async {
    try {
      int fetchedTotalExpense = await _expenseService.getTotalExpense();
      setState(() {
        totalExpense = fetchedTotalExpense;
      });
    } catch (e) {
      print("Error loading total expense: $e");
      // Handle error
    }
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
          'Daily Expenses',
          style: TextStyle(color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        _buildExpenseList(),
        const SizedBox(height: 16.0),
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: _showExpenseFormDialog,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColor.dashbordBlueColor, // Set the background color
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Set the button shape
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0), // Set the padding
              ),
              elevation:
                  MaterialStateProperty.all<double>(5.0), // Set the elevation
            ),
            child: Text(
              'Add New Expense',
              style: TextStyle(color: AppColor.dashbordWhiteColor),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalExpense(),
          ],
        ),
      ],
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        //side Bar
        SideBar(
          menuItems: getMenuItems(context),
        ),

        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                _buildExpenseList(),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _showExpenseFormDialog,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.dashbordBlueColor, // Set the background color
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Set the button shape
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0), // Set the padding
                      ),
                      elevation: MaterialStateProperty.all<double>(
                          5.0), // Set the elevation
                    ),
                    child: Text(
                      'Add New Expense',
                      style: TextStyle(color: AppColor.dashbordWhiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTotalExpense(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseList() {
    return Expanded(
      child: expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses available.\nAdd a new expense to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseCard(
                    expenseId: expenses[index].id,
                    expense: expenses[index],
                    expenseService: _expenseService,
                    onDelete: () {
                      // Update the UI after deleting the expense
                      setState(() {
                        expenses.removeAt(index);
                      });
                    },
                    onUpdate: () {
                      setState(() {
                        _loadExpenses();
                      });
                    });
              },
            ),
    );
  }

  Widget _buildTotalExpense() {
    int totalExpense =
        expenses.map((expense) => expense.amount).fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text(
            'Total Expense',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8.0),
          Text(
            ' Rs.$totalExpense',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      expenses.add(newExpense);
    });
  }
}
