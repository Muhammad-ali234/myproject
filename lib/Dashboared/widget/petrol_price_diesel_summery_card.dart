import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/models/petrol_price.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';

Widget buildDieselSummaryCard() {

  final FuelPricesesService fuelPricesService = FuelPricesesService();

  return FutureBuilder<PetrolPrice?>(
    future: fuelPricesService.getLastAddedDieselPrice(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingCard();
      }

      if (snapshot.hasError) {
        return _buildDieselErrorCard();
      }

      PetrolPrice? dieselPrice = snapshot.data;
      if (dieselPrice == null) {
        return _buildDieselEmptyCard();
      }

      return Card(
        elevation: 3,
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Diesel Price:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${dieselPrice.date.day}/${dieselPrice.date.month}/${dieselPrice.date.year}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                'Purchasing Price: ${dieselPrice.purchasingPrice}', // Display purchasing price
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                'Selling Price: ${dieselPrice.sellingPrice}', // Display selling price
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Widget for loading state
Widget _buildLoadingCard() {
  return const Card(
    elevation: 3,
    color: Colors.indigo,
    child: Padding(
     padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    ),
  );
}

// Widget for error state
Widget _buildDieselErrorCard() {
  return const Card(
    elevation: 3,
    color: Colors.indigo,
    child: Padding(
     padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Error fetching diesel price',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    ),
  );
}

// Widget for no data state
Widget _buildDieselEmptyCard() {
  return  const Card(
    elevation: 3,
    color: Colors.indigo,
    child: Padding(
      
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'No diesel price data found',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    ),
  );
}
