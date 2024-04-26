import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Authentication/service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedPetrolPump;
  bool isDropdownOpen = false;
  bool _loginClicked = false;
  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();

  List<String> petrolPumps = [
    "Owner",
    "Pump",
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return _buildWebLayout();
        } else {
          return _buildMobileLayout();
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
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to PetroLink',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildFormFields(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  // Add space between buttons
                  _buildRegisterButton(),
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
                    Image.asset("assets/splashLogo.jpg"),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Welcome to PetroLink',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFormFields(),
                    _buildLoginButton(),
                    const SizedBox(height: 20),
                    _buildRegisterButton(),
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
          controller: _emailController,
          label: "Email",
          hintText: 'Enter email address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Check if the email format is valid
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
          hintText: 'Enter password',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            // Check if the password meets minimum length requirement
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
        _buildPetrolPumpDropdown(),
      ],
    );
  }

// Function to validate email format
  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
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
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          validator: _loginClicked ? validator : null,
        ),
        const SizedBox(height: 5),
        if (_loginClicked && validator != null)
          Text(
            validator(controller.text) ?? '',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
      ],
    );
  }

  Widget _buildPetrolPumpDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPetrolPump,
      onChanged: (newValue) {
        setState(() {
          _selectedPetrolPump = newValue!;
        });
      },
      onTap: () {
        setState(() {
          isDropdownOpen = !isDropdownOpen;
        });
      },
      items: petrolPumps.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select a petrol pump',
        hintStyle: TextStyle(color: Colors.amber),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a petrol pump';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(330, 60),
          backgroundColor: const Color(0xFF6789CA),
        ),
        onPressed: _isLoading ? null : () => _login(context),
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    setState(() {
      _loginClicked = true;
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc;
      if (_selectedPetrolPump == "Owner") {
        userDoc = await _firestoreService.getUserData('Owner', uid);
      } else {
        userDoc = await _firestoreService.getUserData('Pump', uid);
      }

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User data not found. Please register."),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      print("dataddddddd${userDoc.data()}");

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if ((_selectedPetrolPump != "Owner") && (_selectedPetrolPump != "Pump")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Wrong role selected. Please select the correct role."),
          ),
        );
      } else {
        if (_selectedPetrolPump == "Owner") {
          Navigator.pushReplacementNamed(context, '/dashboardOwnerScreen');
        } else if (_selectedPetrolPump == "Pump") {
          Navigator.pushReplacementNamed(context, '/dashboardPumpScreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Unexpected role. Please contact support."),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text("Failed to sign in: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget textFieldWidget({
    label,
    obscureText = false,
    hintText,
    contoller,
    FormFieldValidator<String>? validator, // Add validator argument
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
          controller: contoller,
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
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          validator: validator, // Set the validator function
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
