
import 'package:flutter/material.dart';
import 'package:myproject/Pump/Expense/Models/expense.dart';
import 'package:myproject/Pump/Expense/Screens/service.dart';
import 'package:myproject/Common/constant.dart';

class ExpenseCard extends StatefulWidget {
  final String expenseId;
  final Expense expense;
  final ExpenseService expenseService;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const ExpenseCard({
    super.key,
    required this.expenseId,
    required this.expense,
    required this.expenseService,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  _ExpenseCardState createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController detailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.expense.name);
    detailController = TextEditingController(text: widget.expense.detail);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    dateController = TextEditingController(text: widget.expense.date);
  }

  @override
  void dispose() {
    nameController.dispose();
    detailController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _updateExpense(String expenceId) async {
    if (_formKey.currentState!.validate()) {
      Expense updatedExpense = Expense(
        name: nameController.text,
        detail: detailController.text,
        amount: int.parse(amountController.text),
        date: dateController.text,
        id: expenceId,
      );

      try {
        if (widget.expenseId.isNotEmpty) {
          // Check if expenseId is not empty
          await widget.expenseService
              .updateExpense(widget.expenseId, updatedExpense);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense updated successfully')),
          );
        } else {
          throw Exception('Expense ID is empty');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update expense: $e')),
        );
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expense.name,
                  style: const TextStyle(color: Colors.orange, fontSize: 20),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Detail: ${widget.expense.detail}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Amount: ${widget.expense.amount}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: ${widget.expense.date}',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  try {
                    await widget.expenseService.deleteExpense(widget.expenseId);
                    widget.onDelete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Expense deleted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete expense: $e')),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColor.dashbordBlueColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildEditDialog(widget.expense.id),
                  );
                  print("ggfgfgf:${widget.expense.id}");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditDialog(String expenseId) {
    return AlertDialog(
      title: const Text('Edit Expense'),
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
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Expense Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: detailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Expense Detail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense detail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Expense Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Expense Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense date';
                    }
                    RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!datePattern.hasMatch(value)) {
                      return 'Please enter a valid date in the format YYYY-MM-DD';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _updateExpense(expenseId);
                      widget.onUpdate();
                    });
                  },
                  child: const Text('Save Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
