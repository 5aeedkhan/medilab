import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';

class RegisterUsersScreen extends StatefulWidget {
  const RegisterUsersScreen({super.key});

  @override
  State<RegisterUsersScreen> createState() => _RegisterUsersScreenState();
}

class _RegisterUsersScreenState extends State<RegisterUsersScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController storeTitleController = TextEditingController();
  final TextEditingController opentimeController = TextEditingController();
  final TextEditingController closetimeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectRegisterType;
  Future<void> registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': emailController.text,
        'username': userNameController.text,
        'storeTitle': storeTitleController.text,
        'opentime': opentimeController.text,
        'closetime': closetimeController.text,
        'address': addressController.text,
        'role': selectRegisterType,
      });

      Navigator.pushNamed(context, NavigationRoutes.users_login);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image
            Image.asset(
              'assets/images/banner.png',
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Text(
              'Register',
              style: kHeadingTextStyle,
            ),
            ReusableTextfield(
                title: 'Enter your Email',
                controller: emailController,
                icon: Icon(Icons.email)),
            ReusableTextfield(
                title: 'Enter Username',
                controller: userNameController,
                icon: Icon(Icons.person)),
            ReusableTextfield(
                title: 'Enter Store Title',
                controller: storeTitleController,
                icon: Icon(Icons.store)),
            ReusableTextfield(
                title: 'Opening time',
                controller: opentimeController,
                icon: Icon(Icons.watch)),
            ReusableTextfield(
                title: 'Closing time',
                controller: closetimeController,
                icon: Icon(Icons.time_to_leave)),
            ReusableTextfield(
                title: 'Enter Store Address',
                controller: addressController,
                icon: Icon(Icons.location_city)),
            ReusableTextfield(
              title: 'Password',
              controller: passwordController,
              icon: Icon(Icons.lock),
            ),
            DropdownButton<String>(
              hint: Text('Select User Type'),
              value: selectRegisterType,
              items: <String>['Lab', 'Pharmacy'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectRegisterType = newValue;
                });
              },
            ),
            ReusableButton(text: 'Register', onTap: registerUser),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, NavigationRoutes.users_login);
                    },
                    child: Text('Login')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
