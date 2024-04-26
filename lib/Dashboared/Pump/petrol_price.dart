import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';
import 'package:myproject/Dashboared/sidebar.dart';
import 'package:myproject/Dashboared/models/petrol_price.dart';
import 'package:myproject/Dashboared/widget/petrol_price_Petrolform_widget.dart';
import 'package:myproject/Dashboared/widget/petrol_price_diesel_summery_card.dart';
import 'package:myproject/Dashboared/widget/petrol_price_dieselform,dart';
import 'package:myproject/Dashboared/widget/petrol_price_petrol_summery_card.dart';

class PetrolPriceScreen extends StatefulWidget {
  const PetrolPriceScreen({super.key});

  @override
  _PetrolPriceScreenState createState() => _PetrolPriceScreenState();
}

class _PetrolPriceScreenState extends State<PetrolPriceScreen> {
  final GlobalKey<FormState> _petrolFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dieselFormKey = GlobalKey<FormState>();
  final DateTime _selectedPetrolDate = DateTime.now();
  final DateTime _selectedDieselDate = DateTime.now();
  final double _petrolPrice = 0.0;
  final double _dieselPrice = 0.0;

  final FuelPricesesService _fuelPricesesService = FuelPricesesService();

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
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                PetrolFormWidget(), // Petrol form
                DieselFormWidget() // Diesel form
              ],
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
}
