import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';
import 'package:myproject/Dashboared/widget/petrol_price_petrol_summery_card.dart';

class PetrolFormWidget extends StatefulWidget {
  const PetrolFormWidget({super.key});

  @override
  _PetrolFormWidgetState createState() => _PetrolFormWidgetState();
}

class _PetrolFormWidgetState extends State<PetrolFormWidget> {
  final GlobalKey<FormState> _petrolFormKey = GlobalKey<FormState>();
  DateTime _selectedPetrolDate = DateTime.now();
  double _purchasingPrice = 0.0;
  double _sellingPrice = 0.0;

  final FuelPricesesService _fuelPricesService = FuelPricesesService();
  void _submitPetrolForm() {
    if (_petrolFormKey.currentState!.validate()) {
      _petrolFormKey.currentState!.save();
      print(
          "Purchasing Price: $_purchasingPrice, Selling Price: $_sellingPrice");

          _fuelPricesService
          .savePriceData(
              'petrol', _selectedPetrolDate, _purchasingPrice, _sellingPrice)
          .then((_) {
        print('Petrol prices added successfully.');
      }).catchError((error) {
        print('Failed to add Petrol prices: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _petrolFormKey,
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
                        'Select Petrol Date:',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedPetrolDate,
                            firstDate: DateTime(2010),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null &&
                              pickedDate != _selectedPetrolDate) {
                            setState(() => _selectedPetrolDate = pickedDate);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Text(
                              '${_selectedPetrolDate.day}/${_selectedPetrolDate.month}/${_selectedPetrolDate.year}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildPetrolSummaryCard(), // Including the summary card
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
                      labelText: 'Petrol Purchasing Price (per liter)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a petrol purchasing price';
                      }
                      return null;
                    },
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
                      labelText: 'Petrol Selling Price (per liter)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a petrol selling price';
                      }
                      return null;
                    },
                    onSaved: (value) => _sellingPrice = double.parse(value!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() => _submitPetrolForm());
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text('Add Petrol Price'), // Button text
          ),
        ],
      ),
    );
  }
}
