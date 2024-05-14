import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';
import 'package:myproject/Dashboared/widget/petrol_price_diesel_summery_card.dart';

class DieselFormWidget extends StatefulWidget {
  const DieselFormWidget({super.key});

  @override
  _DieselFormWidgetState createState() => _DieselFormWidgetState();
}

class _DieselFormWidgetState extends State<DieselFormWidget> {
  final GlobalKey<FormState> _dieselFormKey = GlobalKey<FormState>();
  DateTime _selectedDieselDate = DateTime.now();
  double _purchasingPrice = 0.0;
  double _sellingPrice = 0.0;

  final FuelPricesesService _fuelPricesService = FuelPricesesService();

  void _submitDieselForm() {
    if (_dieselFormKey.currentState!.validate()) {
      _dieselFormKey.currentState!.save();

      // Save to Firestore with 'diesel' as the type
      _fuelPricesService
          .savePriceData(
              'diesel', _selectedDieselDate, _purchasingPrice, _sellingPrice)
          .then((_) {
        print('Diesel prices added successfully.');
      }).catchError((error) {
        print('Failed to add diesel prices: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dieselFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Select Diesel Date:',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDieselDate,
                            firstDate: DateTime(2010),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null &&
                              pickedDate != _selectedDieselDate) {
                            setState(() => _selectedDieselDate = pickedDate);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Text(
                              '${_selectedDieselDate.day}/${_selectedDieselDate.month}/${_selectedDieselDate.year}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildDieselSummaryCard(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Diesel Selling Price (per liter)',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a diesel purchasing price'
                        : null,
                    onSaved: (value) => _purchasingPrice = double.parse(value!),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Diesel Selling Price (per liter)',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a diesel selling price'
                        : null,
                    onSaved: (value) => _sellingPrice = double.parse(value!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitDieselForm,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text('Add Diesel Price'),
          ),
        ],
      ),
    );
  }
}
