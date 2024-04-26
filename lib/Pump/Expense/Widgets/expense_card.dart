import 'package:flutter/material.dart';
import 'package:myproject/Pump/Expense/Models/expense.dart';
import 'package:myproject/Pump/Expense/Screens/service.dart';

class ExpenseCard extends StatelessWidget {
  final String expenseId;
  final Expense expense;
  final ExpenseService expenseService;
  final VoidCallback onDelete; // Define onDelete callback

  const ExpenseCard({
    super.key,
    required this.expenseId,
    required this.expense,
    required this.expenseService,
    required this.onDelete, // Add onDelete parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          expense.name,
          style: const TextStyle(color: Colors.orange),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              'Detail: ${expense.detail}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Amount: ${expense.amount}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${expense.date}',
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            // Delete the expense
            await expenseService.deleteExpense(expenseId);
            // Call the onDelete callback to update the UI
            onDelete();
          },
        ),
      ),
    );
  }
}
