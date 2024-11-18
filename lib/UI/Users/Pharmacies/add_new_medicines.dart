import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/reusable_widgets.dart';

class AddNewMedicinesScreen extends StatefulWidget {
  const AddNewMedicinesScreen({super.key});

  @override
  State<AddNewMedicinesScreen> createState() => _AddNewMedicinesScreenState();
}

class _AddNewMedicinesScreenState extends State<AddNewMedicinesScreen> {
  // Controllers for the text fields
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController formulaController = TextEditingController();
  final TextEditingController mlmgController = TextEditingController();
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Variables for dropdowns
  String? selectedType; // Store selected type
  String? selectedStatus; // Store selected status

  // Dropdown options
  List<String> types = ['Tablet', 'Syrup', 'Injection', 'Capsule'];
  List<String> statuses = ['In Stock', 'Out of Stock'];

  // Function to generate search keywords
  List<String> generateSearchKeywords(String text) {
    List<String> keywords = [];
    for (int i = 0; i < text.length; i++) {
      keywords.add(text.substring(0, i + 1).toLowerCase());
    }
    return keywords;
  }

  // Function to save medicine data to Firestore
  Future<void> saveMedicine() async {
    try {
      String medicineName = medicineController.text;
      List<String> searchKeywords = generateSearchKeywords(medicineName);

      await FirebaseFirestore.instance.collection('medicines').add({
        'medicineName': medicineName,
        'formulaName': formulaController.text,
        'mlmg': mlmgController.text,
        'companyName': companynameController.text,
        'price': priceController.text,
        'type': selectedType,
        'status': selectedStatus,
        'searchKeywords': searchKeywords,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicine added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add medicine: $e')),
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
                Text('Add New Medicines',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20), // Add space below the title

                // ReusableTextfields for medicine details
                ReusableTextfield(
                  title: 'Enter Medicine Name',
                  controller: medicineController,
                  icon: Icon(Icons.medical_services),
                ),
                ReusableTextfield(
                  title: 'Enter Formula Name',
                  controller: formulaController,
                  icon: Icon(Icons.medical_services),
                ),
                ReusableTextfield(
                  title: 'ML/MG',
                  controller: mlmgController,
                  icon: Icon(Icons.medical_services_rounded),
                ),
                ReusableTextfield(
                  title: 'Enter Company Name',
                  controller: companynameController,
                  icon: Icon(Icons.business),
                ),
                ReusableTextfield(
                  title: 'Enter Price',
                  controller: priceController,
                  icon: Icon(Icons.attach_money),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * .6,
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        hint: Text('Select Type'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedType = newValue;
                          });
                        },
                        items: types.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * .6,
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        hint: Text('Select Status'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        },
                        items: statuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.check),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
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
                      onTap: saveMedicine,
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
