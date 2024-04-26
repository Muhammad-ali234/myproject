import 'package:flutter/material.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/service.dart';

class AddCreditDialog extends StatefulWidget {
  final String type;
  final String id;
  final void Function(double) onTransactionSaved;

  const AddCreditDialog({
    super.key,
    required this.type,
    required this.id,
    required this.onTransactionSaved,
  });

  @override
  _AddCreditDialogState createState() => _AddCreditDialogState();
}

class _AddCreditDialogState extends State<AddCreditDialog> {
  final TextEditingController _creditController = TextEditingController();
  final creditDebitService = CreditDebitService();

  @override
  void dispose() {
    _creditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.type}'),
      content: TextField(
        controller: _creditController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: widget.type,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            double? amount = double.tryParse(_creditController.text);
            if (widget.type == 'Debit') {
              await creditDebitService.addTransactionToHistory(
                  widget.id, amount!, false);
              // await creditDebitService.TransactionToHistory(
              //     widget.id, amount, false);
            } else {
              await creditDebitService.addTransactionToHistory(
                  widget.id, amount!, true);
              // await creditDebitService.TransactionToHistory(
              //     widget.id, amount, true);
            }

            if (amount > 0) {
              widget.onTransactionSaved(amount);
              Navigator.of(context).pop(); // Close the dialog
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Invalid input. Please enter a valid positive number.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
