import 'package:flutter/material.dart';
import 'package:myproject/Pump/Customer/customer_data.dart';
import 'package:myproject/Pump/Customer/service.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';
import 'package:myproject/Common/constant.dart';

class AddCustomer extends StatefulWidget {
  final Customer? customer;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;
  const AddCustomer({super.key, this.customer, this.onDelete, this.onUpdate});

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController contactController;
  late final CustomerService _customerService;
  // late final String id;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _customerService = CustomerService();
    nameController = TextEditingController(text: widget.customer?.name ?? '');
    emailController = TextEditingController(text: widget.customer?.email ?? '');
    contactController =
        TextEditingController(text: widget.customer?.contact ?? '');
    // id = widget.customer?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Add Customer',
          style: TextStyle(color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive UI logic
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return _buildMobileLayout();
          } else {
            // Web layout
            return _buildWebLayout();
          }
        },
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    nameController,
                    'Name',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    emailController,
                    'Email',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address.';
                      }
                      if (!_isValidEmail(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    contactController,
                    'Contact',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact number.';
                      }
                      if (!_isValidContact(value)) {
                        return 'Please enter a valid contact number.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.dashbordBlueColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:  Text(
                      'Save',
                      style: TextStyle(color: AppColor.dashbordWhiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                nameController,
                'Name',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                emailController,
                'Email',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address.';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                contactController,
                'Contact',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number.';
                  }
                  if (!_isValidContact(value)) {
                    return 'Please enter a valid contact number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _saveUser();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.dashbordBlueColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:  Text(
                  'Save',
                  style: TextStyle(color: AppColor.dashbordWhiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:  TextStyle(color: AppColor.dashbordBlueColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.dashbordBlueColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: validator,
    );
  }

  void _saveUser() async {
    String customerId = UniqueKey().toString();
    final newCustomer = Customer(
      id: customerId,
      name: nameController.text,
      email: emailController.text,
      contact: contactController.text,
      credit: 0,
      debit: 0,
    );

    if (widget.customer != null) {
      // Update mode
      final updateCustomer = Customer(
        id: widget.customer!.id,
        name: nameController.text,
        email: emailController.text,
        contact: contactController.text,
        credit: 0,
        debit: 0,
      );

      // Wait for the update operation to complete
      await _customerService.updateCustomer(updateCustomer);
      widget.onUpdate!();
      widget.onDelete!();
    } else {
      // Add mode
      await _customerService.addCustomer(newCustomer);
      setState(() {});
    }

    // After the async operation completes, navigate back
    Navigator.pop(context);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidContact(String contact) {
    final contactRegex = RegExp(r'^[0-9]{10}$');
    return contactRegex.hasMatch(contact);
  }
}
