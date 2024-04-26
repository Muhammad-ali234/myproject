
  import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/models/petrol_price.dart';
import 'package:myproject/Dashboared/services/petrol_price.dart';

Widget buildDieselSummaryCard() {
  final FuelPricesesService _fuelPricesesService = FuelPricesesService();
    return FutureBuilder<PetrolPrice?>(
      future: _fuelPricesesService
          .getLastAddedDieselPrice(), // Fetch the last diesel price
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(); // Show loading indicator while fetching
        }

        if (snapshot.hasError) {
          return _buildDieselErrorCard(); // Handle errors
        }

        PetrolPrice? dieselPrice = snapshot.data;
        if (dieselPrice == null) {
          return _buildDieselEmptyCard(); // Display if no data is found
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
                  'Date: ${dieselPrice.date.day}/${dieselPrice.date.month}/${dieselPrice.date.year}', // Display the fetched date
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  'Price: ${dieselPrice.price}', // Display the fetched price
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
            color: Colors.white, // Loading indicator color
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
    return const Card(
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

