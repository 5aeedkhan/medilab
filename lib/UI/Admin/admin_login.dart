import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int _selectedIndex = 0; // Default to Admin tab

  // Function to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.pushNamed(context, NavigationRoutes.admin_login);
        break;
      case 1:
        Navigator.pushNamed(context, NavigationRoutes.users_login);
        break;
      case 2:
        Navigator.pushNamed(context, NavigationRoutes.search_products);
        break;
    }
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      // Check if the email and password match the admin credentials
      if (emailController.text == 'admin@gmail.com' &&
          passwordController.text == 'admin1234') {
        _auth
            .signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text.toString())
            .then((value) {
          Navigator.pushNamed(context, NavigationRoutes.admin_dashboard);
        }).onError((error, StackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to login: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid admin credentials')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context, NavigationRoutes.role_selection_screen);
            },
            child: Icon(
              Icons.home,
              color: Color(0xffAACFD0),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Image
              Image.asset(
                'assets/images/banner.png',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              Text(
                'Login',
                style: kHeadingTextStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableTextfield(
                      title: 'Email',
                      icon: Icon(Icons.email),
                      controller: emailController,
                    ),
                    ReusableTextfield(
                      title: 'Password',
                      icon: Icon(Icons.lock),
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ReusableButton(
                  text: 'LogIn',
                  onTap: () {
                    login();
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
