import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Pump/Stocks/Screens/meter_reading_histry.dart';
import 'package:myproject/Pump/Stocks/Screens/service.dart';
import 'package:myproject/Pump/Stocks/Screens/stock_histry_screen.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Common/constant.dart';

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
    double litres = double.parse(
      selectedFuelType == 'Petrol'
          ? petrolController.text
          : dieselController.text,
    );

    setState(() {
      if (selectedFuelType == 'Petrol') {
        petrolStock += litres;
      } else {
        dieselStock += litres;
      }

      stockHistory.add(StockHistoryItem(
        type: '$selectedFuelType Stock',
        litres: litres,
        timestamp: DateTime.now(),
      ));
    });
    // add stock data to firestore
    if (selectedFuelType == 'Petrol') {
      try {
        await _firestoreService.addStockData(
          type: 'Petrol',
          date: Timestamp.now(),
          litres: litres,
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
          litres: litres,
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
          litres: litres,
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
          litres:litres,
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

  Future<void> deductFromStock({double? litres}) async {
    double deductionLitres = litres ?? double.parse(pumpReadingController.text);

    double previousReading =
        await _firestoreService.getPreviousMeterReading(selectedFuelType) ??
            0.0;
    if (deductionLitres > previousReading) {
      double currentReading = deductionLitres - previousReading;
      setState(() {
        if (selectedFuelType == 'Petrol') {
          petrolStock -= currentReading;
        } else {
          dieselStock -= currentReading;
        }

        stockHistory.add(
          StockHistoryItem(
            type: '$selectedFuelType Pump Reading',
            litres: currentReading,
            timestamp: DateTime.now(),
          ),
        );
      });

      try {
        await _firestoreService.addMeterReading(
          type: selectedFuelType,
          date: Timestamp.now(),
          litres: deductionLitres,
        );

        await _firestoreService.addMeterReadingHistry(
          type: selectedFuelType,
          date: Timestamp.now(),
          litres: currentReading,
        );

        // Update the stock data in Firestore
        if (selectedFuelType == 'Petrol') {
          await _firestoreService.addStockData(
            type: 'Petrol',
            date: Timestamp.now(),
            litres: petrolStock,
          );
        } else {
          await _firestoreService.addStockData(
            type: 'Diesel',
            date: Timestamp.now(),
            litres: dieselStock,
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to deduct pump reading from stock Please the deduction amount is greater than previous reading'),
          duration: Duration(seconds: 2),
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
        iconTheme: IconThemeData(
          color: AppColor
              .dashbordWhiteColor, // Change the color of the back icon here
        ),
        title: Text(
          'Petrol Diesel Stock',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
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
                            AppColor
                                .dashbordBlueColor), // Set the background color
                      ),
                      child: Text(
                        'Add Fuel to Stock',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.dashbordWhiteColor),
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
                            AppColor
                                .dashbordBlueColor), // Set the background color
                      ),
                      child: Text(
                        'View Stock History',
                        style: TextStyle(
                          color: AppColor.dashbordWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                          color: AppColor.dashbordBlueColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: DropdownButton<String>(
                          dropdownColor: AppColor.dashbordBlueColor,
                          iconEnabledColor: AppColor.dashbordWhiteColor,
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
                                style: TextStyle(
                                    color: AppColor.dashbordWhiteColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

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
                            AppColor
                                .dashbordBlueColor), // Set the background color
                      ),
                      child: Text(
                        'Deduct Pump Reading from Stock',
                        style: TextStyle(
                          color: AppColor.dashbordWhiteColor,
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
                            AppColor
                                .dashbordBlueColor), // Set the background color
                      ),
                      child: Text(
                        'View Pump Reading History',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.dashbordWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 33,
                      decoration: BoxDecoration(
                          color: AppColor.dashbordBlueColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: DropdownButton<String>(
                          iconEnabledColor: AppColor.dashbordWhiteColor,
                          dropdownColor: AppColor.dashbordBlueColor,
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
                                style: TextStyle(
                                    color: AppColor.dashbordWhiteColor),
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
                //     foregroundColor: AppColor.dashbordWhiteColor,
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
                        AppColor.dashbordBlueColor), // Set the background color
                  ),
                  child: Text(
                    'Add Fuel to Stock',
                    style: TextStyle(
                        color: AppColor.dashbordWhiteColor, fontSize: 16),
                  ),
                ),
                Container(
                  width: 80,
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColor.dashbordBlueColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: DropdownButton<String>(
                      iconEnabledColor: AppColor.dashbordWhiteColor,
                      dropdownColor: AppColor.dashbordBlueColor,
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
                            style:
                                TextStyle(color: AppColor.dashbordWhiteColor),
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
                    AppColor.dashbordBlueColor), // Set the background color
              ),
              child: Text(
                'View Stock History',
                style:
                    TextStyle(color: AppColor.dashbordWhiteColor, fontSize: 16),
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
                        AppColor.dashbordBlueColor), // Set the background color
                  ),
                  child: Text(
                    'Add Reading',
                    style: TextStyle(
                        color: AppColor.dashbordWhiteColor, fontSize: 16),
                  ),
                ),
                Container(
                  width: 80,
                  height: 33,
                  decoration: BoxDecoration(
                      color: AppColor.dashbordBlueColor,
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
                            style:
                                TextStyle(color: AppColor.dashbordWhiteColor),
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
                    AppColor.dashbordBlueColor), // Set the background color
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
              child: Text(
                'View Pump Reading History',
                style:
                    TextStyle(fontSize: 16, color: AppColor.dashbordWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
