import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';

class AddNewTestsScreen extends StatefulWidget {
  const AddNewTestsScreen({super.key});

  @override
  State<AddNewTestsScreen> createState() => _AddNewTestsScreenState();
}

class _AddNewTestsScreenState extends State<AddNewTestsScreen> {
  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  // Function to generate search keywords
  List<String> generateSearchKeywords(String text) {
    List<String> keywords = [];
    for (int i = 0; i < text.length; i++) {
      keywords.add(text.substring(0, i + 1).toLowerCase());
    }
    return keywords;
  }

  // Function to save test data to Firestore
  Future<void> saveTest() async {
    try {
      String testName = nameController.text;
      List<String> searchKeywords = generateSearchKeywords(testName);

      await FirebaseFirestore.instance.collection('tests').add({
        'testName': testName,
        'testDetails': detailsController.text,
        'price': priceController.text,
        'contact': contactController.text,
        'duration': durationController.text,
        'searchKeywords': searchKeywords,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add test: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(),
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
                Text('Add New Test', style: kGoogleBlackTextStyle),
                SizedBox(height: 20), // Add space below the title

                // ReusableTextfields for test details
                ReusableTextfield(
                  title: 'Enter Test Name',
                  controller: nameController,
                  icon: Icon(Icons.local_hospital_rounded),
                ),
                ReusableTextfield(
                  title: 'Enter Test Details',
                  controller: detailsController,
                  icon: Icon(Icons.local_hospital_rounded),
                ),
                ReusableTextfield(
                  title: 'Test Price',
                  controller: priceController,
                  icon: Icon(Icons.attach_money),
                ),
                ReusableTextfield(
                  title: 'Contact',
                  controller: contactController,
                  icon: Icon(Icons.phone),
                ),
                ReusableTextfield(
                  title: 'Time Duration',
                  controller: durationController,
                  icon: Icon(Icons.watch_outlined),
                ),

                // SizedBox(height: MediaQuery.of(context).size.height * .2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                      onTap: saveTest,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Save',
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
      ),
    );
  }
}
