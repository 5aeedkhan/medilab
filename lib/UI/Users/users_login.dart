import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersLoginScreen extends StatefulWidget {
  const UsersLoginScreen({super.key});

  @override
  State<UsersLoginScreen> createState() => _UsersLoginScreenState();
}

class _UsersLoginScreenState extends State<UsersLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final _formKey = GlobalKey<FormState>();

  // Variable for selected login type
  String? selectedLoginType;
  int _selectedIndex = 1; // Default to Users tab

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

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String userRole = userDoc['role'];

      // Verify role and navigate
      if (userRole == selectedLoginType) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLoggedIn', true);
        await prefs.setString('userRole', userRole);

        if (userRole == 'Lab') {
          Navigator.pushNamed(context, NavigationRoutes.laboratories_dashboard);
        } else if (userRole == 'Pharmacy') {
          Navigator.pushNamed(context, NavigationRoutes.pharmacies_dashboard);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid login type for this user')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
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
                height: MediaQuery.of(context).size.height * 0.2,
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
              // Dropdown for Lab or Pharmacy
              DropdownButton<String>(
                hint: Text('Select Login Type'),
                value: selectedLoginType,
                items: <String>['Lab', 'Pharmacy'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLoginType = newValue;
                  });
                },
              ),
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
              SizedBox(
                height: 15,
              ),
              ReusableButton(
                text: 'LogIn',
                onTap: loginUser,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Not a user?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, NavigationRoutes.register_users);
                      },
                      child: Text('Register')),
                ],
              ),
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
