import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Pump/Stocks/Screens/meter_reading_histry.dart';
import 'package:myproject/Pump/Stocks/Screens/service.dart';
import 'package:myproject/Pump/Stocks/Screens/stock_histry_screen.dart';
import 'package:myproject/Pump/Stocks/Widget/image_picker.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

import '../../common/screens/app_drawer.dart';
import '../../common/screens/sidebar.dart';
import '../Models/stock_histry_Item.dart';
import 'dart:io';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  double petrolStock = 0.0;
  double dieselStock = 0.0;
  List<StockHistoryItem> stockHistory = [];
  List<StockHistoryItem> meterReadingHistory = [];

  TextEditingController petrolController = TextEditingController();
  TextEditingController dieselController = TextEditingController();
  TextEditingController pumpReadingController = TextEditingController();

  final _firestoreService = FirestoreService();
  final _authService = FirebaseAuthService();

  String selectedFuelType = 'Petrol';
  late File _imageFile;
  final String _extractedText = '';

  @override
  void initState() {
    super.initState();
    fetchStockData();
    fetchStockHistory();
    fetchMeterReadingHistory();
  }

  void addToStock() async {
    String? uid = await _authService.getCurrentUserUID();
    double amount = double.parse(
      selectedFuelType == 'Petrol'
          ? petrolController.text
          : dieselController.text,
    );

    setState(() {
      if (selectedFuelType == 'Petrol') {
        petrolStock += amount;
      } else {
        dieselStock += amount;
      }

      stockHistory.add(StockHistoryItem(
        type: '$selectedFuelType Stock',
        amount: amount,
        timestamp: DateTime.now(),
      ));
    });
    // add stock data to firestore
    if (selectedFuelType == 'Petrol') {
      try {
        await _firestoreService.addStockData(
          type: 'Petrol',
          date: Timestamp.now(),
          amount: amount,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Petrol stock added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add petrol stock: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      try {
        await _firestoreService.addStockData(
          type: 'Diesel',
          date: Timestamp.now(),
          amount: amount,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diesel stock added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add diesel stock: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    // add stock histry to firestore
    if (selectedFuelType == 'Petrol') {
      try {
        await _firestoreService.addStockHistry(
          type: 'Petrol',
          date: Timestamp.now(),
          amount: amount,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Petrol stock histry added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add petrol stock histry : $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      try {
        await _firestoreService.addStockHistry(
          type: 'Diesel',
          date: Timestamp.now(),
          amount: amount,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diesel stock histry added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add diesel stock histry: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    petrolController.clear();
    dieselController.clear();
  }

  // Fetch stock data from Firestore
  Future<void> fetchStockData() async {
    try {
      Map<String, double> stockData = await _firestoreService.fetchStockData();
      setState(() {
        petrolStock = stockData['petrol'] ?? 0.0;
        dieselStock = stockData['diesel'] ?? 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching stock data: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // fetch histry of stock
  Future<void> fetchStockHistory() async {
    try {
      List<Map<String, dynamic>> stockHistoryData =
          await _firestoreService.fetchStockHistory();
      List<StockHistoryItem> historyItems = stockHistoryData
          .map((item) => StockHistoryItem.fromMap(item))
          .toList();

      if (historyItems.isNotEmpty) {
        setState(() {
          stockHistory = historyItems;
        });
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching stock history: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Future<void> deductFromStock({double? amount}) async {
  //   double deductionAmount = amount ?? double.parse(pumpReadingController.text);

  //   // Get the previous reading from Firestore
  //   double previousReading =
  //       await _firestoreService.getPreviousMeterReading(selectedFuelType) ??
  //           0.0;

  //   // Calculate the difference between the current reading and the previous reading
  //   double currentReading = 0.0;
  //   setState(() {
  //     currentReading = deductionAmount - previousReading;
  //     if (selectedFuelType == 'Petrol') {
  //       petrolStock -= currentReading;
  //     } else {
  //       dieselStock -= currentReading;
  //     }

  //     stockHistory.add(
  //       StockHistoryItem(
  //         type: '$selectedFuelType Pump Reading',
  //         amount: currentReading,
  //         timestamp: DateTime.now(),
  //       ),
  //     );
  //   });

  //   // Add the meter reading data to Firestore
  //   try {
  //     await _firestoreService.addMeterReading(
  //       type: selectedFuelType,
  //       date: Timestamp.now(),
  //       amount: currentReading,
  //     );

  //     // Update the stock data in Firestore
  //     if (selectedFuelType == 'Petrol') {
  //       await _firestoreService.addStockData(
  //         type: 'Petrol',
  //         date: Timestamp.now(),
  //         amount: petrolStock, // Deducting the amount from stock
  //       );
  //     } else {
  //       await _firestoreService.addStockData(
  //         type: 'Diesel',
  //         date: Timestamp.now(),
  //         amount: dieselStock, // Deducting the amount from stock
  //       );
  //     }

  //     // Clear the text field after updating the stock.
  //     pumpReadingController.clear();

  //     // Show a SnackBar to provide feedback.
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           '$selectedFuelType Pump Reading deducted from stock successfully!',
  //         ),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to deduct pump reading from stock: $e'),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }
  Future<void> deductFromStock({double? amount}) async {
    double deductionAmount = amount ?? double.parse(pumpReadingController.text);

    // Get the previous reading from Firestore
    double previousReading =
        await _firestoreService.getPreviousMeterReading(selectedFuelType) ??
            0.0;

    // Calculate the current reading based on the difference
    double currentReading = deductionAmount - previousReading;

    setState(() {
      if (selectedFuelType == 'Petrol') {
        petrolStock -= currentReading;
      } else {
        dieselStock -= currentReading;
      }

      stockHistory.add(
        StockHistoryItem(
          type: '$selectedFuelType Pump Reading',
          amount: currentReading,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Add the meter reading data to Firestore
    try {
      await _firestoreService.addMeterReading(
        type: selectedFuelType,
        date: Timestamp.now(),
        amount: deductionAmount,
      );

      // Update the stock data in Firestore
      if (selectedFuelType == 'Petrol') {
        await _firestoreService.addStockData(
          type: 'Petrol',
          date: Timestamp.now(),
          amount: petrolStock,
        );
      } else {
        await _firestoreService.addStockData(
          type: 'Diesel',
          date: Timestamp.now(),
          amount: dieselStock,
        );
      }
      pumpReadingController.clear();
      currentReading = 0.0;

      // Show a SnackBar to provide feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$selectedFuelType Pump Reading deducted from stock successfully!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to deduct pump reading from stock: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchMeterReadingHistory() async {
    try {
      List<Map<String, dynamic>> stockHistoryData =
          await _firestoreService.fetchMeterReadingHistory();
      List<StockHistoryItem> historyItems = stockHistoryData
          .map((item) => StockHistoryItem.fromMap(item))
          .toList();

      if (historyItems.isNotEmpty) {
        meterReadingHistory = historyItems;
        setState(() {});
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching stock history: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        title: const Text(
          'Petrol Diesel Stock',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6789CA),
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive UI logic
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return buildMobileLayout(context);
          } else {
            // Web layout
            return buildWebLayout(context);
          }
        },
      ),
    );
  }

  Widget buildWebLayout(BuildContext context) {
    return Row(
      children: [
        //sidebar
        SideBar(
          menuItems: getMenuItems(context),
        ),
        // Main Content

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total Petrol Stock: $petrolStock',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Diesel Stock: $dieselStock',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: selectedFuelType == 'Petrol'
                      ? petrolController
                      : dieselController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Enter Fuel Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: addToStock,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFF6789CA)), // Set the background color
                      ),
                      child: const Text(
                        'Add Fuel to Stock',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockHistoryScreen(
                              historyType: 'Stock',
                              stockHistory: stockHistory,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFF6789CA)), // Set the background color
                      ),
                      child: const Text(
                        'View Stock History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xFF6789CA),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF6789CA),
                          iconEnabledColor: Colors.white,
                          value: selectedFuelType,
                          onChanged: (value) {
                            setState(() {
                              selectedFuelType = value!;
                            });
                          },
                          items: ['Petrol', 'Diesel']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => StockHistoryScreen(
                //           historyType: 'Stock',
                //           stockHistory: stockHistory,
                //         ),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: Colors.blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'View Stock History',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                TextField(
                  controller: pumpReadingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Enter Meter Reading',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ImagePickerScreen(
                //   onTextExtracted: (text) {
                //     setState(() {
                //       _extractedText = text;
                //     });
                //     if (text.isNotEmpty) {
                //       // Remove non-numeric characters from the extracted text
                //       String sanitizedText =
                //           text.replaceAll(RegExp(r'[^0-9.]'), '');
                //       // Set the sanitized text to the pumpReadingController
                //       pumpReadingController.text = sanitizedText;
                //       // Ensure the UI updates after setting the text
                //       setState(() {});
                //     }
                //   },
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: deductFromStock,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFF6789CA)), // Set the background color
                      ),
                      child: const Text(
                        'Deduct Pump Reading from Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeterReadingHistoryScreen(
                              stockHistory: meterReadingHistory,
                              historyType: 'Pump Reading',
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFF6789CA)), // Set the background color
                      ),
                      child: const Text(
                        'View Pump Reading History',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 33,
                      decoration: BoxDecoration(
                          color: const Color(0xFF6789CA),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: DropdownButton<String>(
                          iconEnabledColor: Colors.white,
                          dropdownColor: const Color(0xFF6789CA),
                          value: selectedFuelType,
                          onChanged: (value) {
                            setState(() {
                              selectedFuelType = value!;
                            });
                          },
                          items: ['Petrol', 'Diesel']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => MeterReadingHistoryScreen(
                //           stockHistory: meterReadingHistory,
                //           historyType: 'Pump Reading',
                //         ),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: Colors.blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'View Pump Reading History',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total Petrol Stock: $petrolStock',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Diesel Stock: $dieselStock',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: selectedFuelType == 'Petrol'
                  ? petrolController
                  : dieselController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Enter Fuel Amount'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: addToStock,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF6789CA)), // Set the background color
                  ),
                  child: const Text(
                    'Add Fuel to Stock',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Container(
                  width: 80,
                  height: 35,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6789CA),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: DropdownButton<String>(
                      iconEnabledColor: Colors.white,
                      dropdownColor: const Color(0xFF6789CA),
                      value: selectedFuelType,
                      onChanged: (value) {
                        setState(() {
                          selectedFuelType = value!;
                        });
                      },
                      items: ['Petrol', 'Diesel']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockHistoryScreen(
                      stockHistory: stockHistory,
                      historyType: 'Stock', // or any meaningful string
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF6789CA)), // Set the background color
              ),
              child: const Text(
                'View Stock History',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pumpReadingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  const InputDecoration(labelText: 'Enter Meter Reading'),
            ),
            const SizedBox(height: 10),
            // ImagePickerScreen(
            //   onTextExtracted: (text) {
            //     setState(() {
            //       _extractedText = text;
            //     });
            //     if (text.isNotEmpty) {
            //       // Remove non-numeric characters from the extracted text
            //       String sanitizedText =
            //           text.replaceAll(RegExp(r'[^0-9.]'), '');
            //       // Set the sanitized text to the pumpReadingController
            //       pumpReadingController.text = sanitizedText;
            //       // Ensure the UI updates after setting the text
            //       setState(() {});
            //     }
            //   },
            // ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: deductFromStock,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF6789CA)), // Set the background color
                  ),
                  child: const Text(
                    'Add Reading',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Container(
                  width: 80,
                  height: 33,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6789CA),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedFuelType,
                      onChanged: (value) {
                        setState(() {
                          selectedFuelType = value!;
                        });
                      },
                      items: ['Petrol', 'Diesel']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF6789CA)), // Set the background color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeterReadingHistoryScreen(
                      stockHistory: meterReadingHistory,
                      historyType: 'Pump Reading', // or any meaningful string
                    ),
                  ),
                );
              },
              child: const Text(
                'View Pump Reading History',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




 // Future<void> deductFromStock({double? amount}) async {
  //   double deductionAmount = amount ?? double.parse(pumpReadingController.text);

  //   setState(() {
  //     if (selectedFuelType == 'Petrol') {
  //       petrolStock -= deductionAmount;
  //     } else {
  //       dieselStock -= deductionAmount;
  //     }

  //     stockHistory.add(
  //       StockHistoryItem(
  //         type: '$selectedFuelType Pump Reading',
  //         amount: deductionAmount,
  //         timestamp: DateTime.now(),
  //       ),
  //     );
  //   });

  //   // Add the meter reading data to Firestore
  //   try {
  //     await _firestoreService.addMeterReading(
  //       type: selectedFuelType,
  //       date: Timestamp.now(),
  //       amount: deductionAmount,
  //     );

  //     // Update the stock data in Firestore
  //     if (selectedFuelType == 'Petrol') {
  //       await _firestoreService.addStockData(
  //         type: 'Petrol',
  //         date: Timestamp.now(),
  //         amount: petrolStock, // Deducting the amount from stock
  //       );
  //     } else {
  //       await _firestoreService.addStockData(
  //         type: 'Diesel',
  //         date: Timestamp.now(),
  //         amount: dieselStock, // Deducting the amount from stock
  //       );
  //     }

  //     // Clear the text field after updating the stock.
  //     pumpReadingController.clear();

  //     // Show a SnackBar to provide feedback.
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           '$selectedFuelType Pump Reading deducted from stock successfully!',
  //         ),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to deduct pump reading from stock: $e'),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   }
  //   //
  //   if (selectedFuelType == 'Petrol') {
  //     try {
  //       await _firestoreService.addMeterReadingHistry(
  //         type: 'Petrol',
  //         date: Timestamp.now(),
  //         amount: deductionAmount,
  //       );

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Petrol stock histry added successfully!'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to add petrol stock histry : $e'),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );
  //     }
  //   } else {
  //     try {
  //       await _firestoreService.addMeterReadingHistry(
  //         type: 'Diesel',
  //         date: Timestamp.now(),
  //         amount: deductionAmount,
  //       );

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Diesel stock histry added successfully!'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to add diesel stock histry: $e'),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );
  //     }
  //   }
  // }