import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Authentication/service.dart';
import 'package:myproject/Common/constant.dart';
import 'package:myproject/Pump/Daily_Overview/Screens/service.dart';

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
  bool _loginClicked = false;
  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();

  List<String> petrolPumps = [
    "Owner",
    "Pump",
  ];

  @override
  Widget build(BuildContext context) {
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
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _buildPetrolPumpSelection(),
      ],
    );
  }

  bool isValidEmail(String email) {
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.dashbordBlueColor),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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

  Widget _buildPetrolPumpSelection() {
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
          children: petrolPumps.map((role) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(role),
                value: role,
                groupValue: _selectedPetrolPump,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPetrolPump = newValue;
                  });
                },
              ),
            );
          }).toList(),
        ),
        if (_loginClicked && _selectedPetrolPump == null)
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

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(330, 60),
          backgroundColor: AppColor.dashbordBlueColor,
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
        child: Text(
          "Register",
          style: TextStyle(
            color: AppColor.dashbordBlueColor,
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
    FormFieldValidator<String>? validator,
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.dashbordBlueColor),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          validator: validator,
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
