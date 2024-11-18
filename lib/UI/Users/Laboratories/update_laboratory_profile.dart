import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateLaboratoryProfileScreen extends StatefulWidget {
  const UpdateLaboratoryProfileScreen({super.key});

  @override
  State<UpdateLaboratoryProfileScreen> createState() =>
      _UpdateLaboratoryProfileScreenState();
}

class _UpdateLaboratoryProfileScreenState
    extends State<UpdateLaboratoryProfileScreen> {
  // Controllers for the text fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController storetitleController = TextEditingController();
  final TextEditingController opentimeController = TextEditingController();
  final TextEditingController closetimeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        usernameController.text = data['username'] ?? '';
        storetitleController.text = data['storeTitle'] ?? '';
        opentimeController.text = data['opentime'] ?? '';
        closetimeController.text = data['closetime'] ?? '';
        addressController.text = data['address'] ?? '';
      }
    }
  }

  Future<void> updateUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': usernameController.text,
          'storeTitle': storetitleController.text,
          'opentime': opentimeController.text,
          'closetime': closetimeController.text,
          'address': addressController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
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
              SizedBox(height: 20), // Add space below the image
              Text('Update Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20), // Add space below the title

              // ReusableTextfields for laboratory details
              ReusableTextfield(
                title: 'Enter your Username',
                controller: usernameController,
                icon: Icon(Icons.person),
              ),
              ReusableTextfield(
                title: 'Enter Store title',
                controller: storetitleController,
                icon: Icon(Icons.store),
              ),
              ReusableTextfield(
                title: 'Opening Time',
                controller: opentimeController,
                icon: Icon(Icons.lock_clock),
              ),
              ReusableTextfield(
                title: 'Closing Time',
                controller: closetimeController,
                icon: Icon(Icons.time_to_leave),
              ),
              ReusableTextfield(
                title: 'Enter Address',
                controller: addressController,
                icon: Icon(Icons.location_city),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .03,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: updateUserProfile,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
