import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/sidebar.dart';
import 'package:myproject/Dashboared/widget/petrol_price_Petrolform_widget.dart';
import 'package:myproject/Dashboared/widget/petrol_price_dieselform.dart';

class PetrolPriceScreen extends StatefulWidget {
  const PetrolPriceScreen({super.key});

  @override
  _PetrolPriceScreenState createState() => _PetrolPriceScreenState();
}

class _PetrolPriceScreenState extends State<PetrolPriceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Petrol and Diesel Prices',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer:
          MediaQuery.of(context).size.width < 600 ? const CustomDrawer() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWideScreenLayout(); // For larger screens and tablets
          } else {
            return _buildMobileLayout(); // For smaller screens and mobile devices
          }
        },
      ),
    );
  }

  Widget _buildWideScreenLayout() {
    return const Row(
      children: [
        Flexible(
          child: CustomDrawer(), // Sidebar for wide layout
        ),
        VerticalDivider(thickness: 1, color: Colors.grey),
        Flexible(
          flex: 3,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PetrolFormWidget(), // Petrol form
                  DieselFormWidget(), // Diesel form
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildPetrolSummaryCard(), // Summary card for petrol
            // _buildDieselSummaryCard(), // Summary card for diesel
            PetrolFormWidget(), // Petrol form
            DieselFormWidget(), // Diesel form
          ],
        ),
      ),
    );
  }

  // Widget _buildPetrolForm() {
  //   return Form(
  //     key: _petrolFormKey,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: Text(
  //                       'Select Petrol Date:',
  //                       style: TextStyle(fontSize: 18.0),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: InkWell(
  //                       onTap: () async {
  //                         final DateTime? pickedDate = await showDatePicker(
  //                           context: context,
  //                           initialDate: _selectedPetrolDate,
  //                           firstDate: DateTime(2010),
  //                           lastDate: DateTime.now(),
  //                         );
  //                         if (pickedDate != null &&
  //                             pickedDate != _selectedPetrolDate) {
  //                           setState(() => _selectedPetrolDate = pickedDate);
  //                         }
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(16.0),
  //                         child: Row(
  //                           children: [
  //                             const Icon(Icons.calendar_today),
  //                             const SizedBox(width: 10),
  //                             Text(
  //                               '${_selectedPetrolDate.day}/${_selectedPetrolDate.month}/${_selectedPetrolDate.year}',
  //                               style: const TextStyle(fontSize: 18),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             buildPetrolSummaryCard(),
  //           ],
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: TextFormField(
  //             keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //               labelText: 'Petrol Price (per liter)',
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter a petrol price';
  //               }
  //               return null;
  //             },
  //             onSaved: (value) => _petrolPrice = double.parse(value!),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               _submitPetrolForm;
  //             });
  //           },
  //           style: ButtonStyle(
  //             // Define the border style

  //             backgroundColor: MaterialStateProperty.all<Color>(
  //                 Colors.teal), // Background color
  //             foregroundColor:
  //                 MaterialStateProperty.all<Color>(Colors.white), // Text color
  //           ),
  //           child: const Text('Add Petrol Price'), // Button text
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
