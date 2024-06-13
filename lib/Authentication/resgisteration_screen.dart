import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/Authentication/service.dart';
import 'package:myproject/Common/constant.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _NameController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  List<String> roles = [
    "Admin",
    "Petrol Pump",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/splashLogo.jpg",
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Register on PetroLink',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 20),
                  _buildFormFields(),
                  const SizedBox(height: 10),
                  _buildRegisterButton(),
                  const SizedBox(height: 5),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/splashLogo.jpg",
                      height: 90,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Register on PetroLink',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildFormFields(),
                    _buildRegisterButton(),
                    const SizedBox(height: 3),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFormFields() {
    return Column(
      children: <Widget>[
        _buildTextField(
          controller: _NameController,
          label: "Name",
          hintText: 'Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Name';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _emailController,
          label: "Email",
          hintText: 'example@gmail.com',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!isValidEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _passwordController,
          label: "Password",
          hintText: 'password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _contactController,
          label: "Contact Number",
          hintText: '+923184439061',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            }
            if (!isValidPakistaniContact(value)) {
              return 'Please enter a valid Pakistani contact number';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _buildRoleSelection(),
        if (_selectedRole == 'Petrol Pump') ...[
          _buildTextField(
            controller: _ownerEmailController,
            label: "Owner Email",
            hintText: 'example@gmail.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the owner\'s email';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Role',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        Row(
          children: roles.map((role) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(role),
                value: role,
                groupValue: _selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
              ),
            );
          }).toList(),
        ),
        if (_selectedRole == null)
          const Text(
            'Please select your role',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool obscureText = false,
    required FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          cursorColor: Colors.grey,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.dashbordBlueColor),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 60),
          backgroundColor: AppColor.dashbordBlueColor,
        ),
        onPressed: _isLoading ? null : () => _register(context),
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () {
          // Navigate to the registration screen
          Navigator.pushNamed(context, '/login');
        },
        child: Text(
          "Login",
          style: TextStyle(
            color: AppColor.dashbordBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String contact = _contactController.text.trim();
      String ownerEmail = _ownerEmailController.text.trim();
      String name = _NameController.text.trim();

      try {
        UserCredential userCredential;

        if (_selectedRole == 'Admin') {
          userCredential = await _authService.createUserWithEmailAndPassword(
              email, password);
          String ownerUid = userCredential.user!.uid;
          await _firestoreService.registerOwner(ownerUid, email, contact, name);
        } else if (_selectedRole == 'Petrol Pump') {
          userCredential = await _authService.createUserWithEmailAndPassword(
              email, password);
          String pumpUid = userCredential.user!.uid;
          await _firestoreService.registerPump(
              pumpUid, email, contact, ownerEmail, name);
        }
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // Handle registration errors
        print('Registration error: $e');
        String errorMessage = 'Registration failed';
        if (e is FirebaseAuthException) {
          errorMessage = e.message!;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPakistaniContact(String contact) {
    final contactRegex = RegExp(r'^\+92[0-9]{10}$');
    return contactRegex.hasMatch(contact);
  }
}
