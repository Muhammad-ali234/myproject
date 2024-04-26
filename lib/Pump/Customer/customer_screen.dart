import 'package:flutter/material.dart'; // Changed import
import 'package:myproject/Pump/Customer/add_customer.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/user_detailed.dart';
import 'package:myproject/Pump/Customer/customer_detaile.dart';
import 'package:myproject/Pump/Customer/service.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/widgets/save_button.dart';
import 'package:myproject/Pump/common/models/drawer_item.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';

// ignore: must_be_immutable
class CustomerScreen extends StatefulWidget {
  final BuildContext context;
  const CustomerScreen({super.key, required this.context});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = []; // Changed type
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      // Create an instance of CustomerService
      CustomerService customerService = CustomerService();

      // Fetch customers
      List<Customer> fetchedUsers = await customerService.getCustomers();

      // Assign fetched customers to CustomerData.users
      setState(() {
        customers = fetchedUsers;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : const Text(
                'Customer Screen',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6789CA),
        actions: _buildAppBarActions(),
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return _buildMobileLayout();
        } else {
          return _buildWebLayout();
        }
      },
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        // Sidebar
        SideBar(
          menuItems: getMenuItems(context),
        ),
        // Main Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          customers[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Email: ${customers[index].email}\nContact: ${customers[index].contact}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerDetailsScreen(user: customers[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SaveButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCustomer(),
                    ),
                  );
                },
                buttonText: "Add User",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          customers[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Email: ${customers[index].email}\nContact: ${customers[index].contact}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerDetailsScreen(user: customers[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SaveButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCustomer()),
                    );
                  },
                  buttonText: "Add User"),
            ],
          ),
        ),
      ],
    );
  }

  // void _addCustomer(Customer customer) {
  //   Customer user = Customer(
  //     id: customer.id,
  //     name: customer.name,
  //     email: customer.email,
  //     contact: customer.contact,
  //   );
  //   setState(() {
  //     // Assuming UserData is properly defined and addUser method accepts a User object
  //     CustomerData.addUser(user);
  //   });
  // }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        style: const TextStyle(color: Colors.black),
        onChanged: (value) {
          // Implement search logic here
          setState(() {
            // Update the list of users based on the search query
          });
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              _isSearching = false;
              // Clear the search query when cancelling the search
              _searchController.clear();
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            // Handle list icon click
          },
        ),
      ];
    }
  }
}
