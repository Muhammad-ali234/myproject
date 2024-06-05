import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Changed import
import 'package:flutter/widgets.dart';
import 'package:myproject/Pump/Customer/add_customer.dart';
import 'package:myproject/Pump/Customer/customer_detaile.dart';
import 'package:myproject/Pump/Customer/service.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/widgets/save_button.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:myproject/Common/constant.dart';

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
  final CustomerService _customerService = CustomerService();

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

  void _updateCustomer(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(
                'Customer Screen',
                style: TextStyle(color: AppColor.dashbordWhiteColor),
              ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerDetailsScreen(user: customers[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customers[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Email: ${customers[index].email}\nContact: ${customers[index].contact}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCustomer(
                                                      customer:
                                                          customers[index],
                                                      onDelete: () {
                                                        setState(() {
                                                          fetchUsers();
                                                        });
                                                      },
                                                      onUpdate: () {
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () async {
                                                await _customerService
                                                    .deleteCustomer(
                                                        customers[index].id);
                                                setState(() {
                                                  customers.removeAt(
                                                      index); // Remove from local list
                                                });
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomerDetailsScreen(user: customers[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customers[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Email: ${customers[index].email}\nContact: ${customers[index].contact}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddCustomer(
                                              customer: customers[index],
                                              onDelete: () {
                                                setState(() {
                                                  fetchUsers();
                                                });
                                              },
                                              onUpdate: () {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () async {
                                        await _customerService.deleteCustomer(
                                            customers[index].id);
                                        setState(() {
                                          customers.removeAt(
                                              index); // Remove from local list
                                        });
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
    );
  }

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

// import 'package:flutter/material.dart';
// import 'package:myproject/Pump/Customer/customer_data.dart';
// import 'package:myproject/Pump/Customer/service.dart';
// // Import your customer service class

// class CustomerScreen extends StatefulWidget {
//   const CustomerScreen({super.key});

//   @override
//   State<CustomerScreen> createState() => _CustomerScreenState();
// }

// class _CustomerScreenState extends State<CustomerScreen> {
//   final CustomerService _customerService = CustomerService();

//   @override
//   Widget build(BuildContext context) {
//     List<Customer> customers = []; // Changed type
//     Future<void> fetchUsers() async {
//       try {
//         // Create an instance of CustomerService
//         CustomerService customerService = CustomerService();

//         // Fetch customers
//         List<Customer> fetchedUsers = await customerService.getCustomers();

//         // Assign fetched customers to CustomerData.users
//         setState(() {
//           customers = fetchedUsers;
//         });
//       } catch (e) {
//         print("Error: $e");
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Customer List'),
//       ),
//       body: FutureBuilder<List<Customer>>(
//         future: _customerService.getCustomers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No customers found.'),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Customer customer = snapshot.data![index];
//                 return ListTile(
//                   title: Text(customer.name),
//                   subtitle: Text(customer.email),
//                   // You can add onTap callback to handle taps on each customer
//                   // onTap: () => _navigateToCustomerDetails(customer),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
