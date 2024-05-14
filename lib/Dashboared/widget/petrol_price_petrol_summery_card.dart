import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/models/petrol_price.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';

Widget buildPetrolSummaryCard() {
  final FuelPricesesService fuelPricesService = FuelPricesesService();

  return FutureBuilder<PetrolPrice?>(
    future:
        fuelPricesService.getLastAddedPetrolPrice(), // Fetch last petrol price
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingCard(); // Display loading indicator while fetching
      }

      if (snapshot.hasError) {
        return _buildErrorCard(); // Display error message on failure
      }

      PetrolPrice? petrolPrice = snapshot.data;
      if (petrolPrice == null) {
        return _buildEmptyCard(); // No data found
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
                'Last Petrol Price:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${petrolPrice.date.day}/${petrolPrice.date.month}/${petrolPrice.date.year}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                'Purchasing Price: ${petrolPrice.purchasingPrice}', // Display purchasing price
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                'Selling Price: ${petrolPrice.sellingPrice}', // Display selling price
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Widget to display while loading data
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

// Widget to display if an error occurs
Widget _buildErrorCard() {
  return const Card(
    elevation: 3,
    color: Colors.indigo,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Error loading petrol price',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    ),
  );
}

// Widget to display if no data is found
Widget _buildEmptyCard() {
  return const Card(
    elevation: 3,
    color: Colors.indigo,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'No petrol price data found',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    ),
  );
}
