import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/reusable_widgets.dart';

class AllTestsofLaboratoriesScreen extends StatefulWidget {
  const AllTestsofLaboratoriesScreen({super.key});

  @override
  State<AllTestsofLaboratoriesScreen> createState() =>
      _AllTestsofLaboratoriesScreenState();
}

class _AllTestsofLaboratoriesScreenState
    extends State<AllTestsofLaboratoriesScreen> {
  // Function to delete a test from Firestore
  Future<void> deleteTest(String id) async {
    try {
      await FirebaseFirestore.instance.collection('tests').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete test: $e')),
      );
    }
  }

  // Function to show edit dialog
  void showEditDialog(Map<String, dynamic> test, String id) {
    TextEditingController nameController =
        TextEditingController(text: test['testName']);
    TextEditingController detailsController =
        TextEditingController(text: test['testDetails']);
    TextEditingController priceController =
        TextEditingController(text: test['price']);
    TextEditingController contactController =
        TextEditingController(text: test['contact']);
    TextEditingController durationController =
        TextEditingController(text: test['duration']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Test'),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('tests')
                      .doc(id)
                      .update({
                    'testName': nameController.text,
                    'testDetails': detailsController.text,
                    'price': priceController.text,
                    'contact': contactController.text,
                    'duration': durationController.text,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Test updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update test: $e')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Top Image
            Image.asset(
              'assets/images/banner.png',
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('tests').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No tests found'));
                  }

                  var tests = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      var test = tests[index].data() as Map<String, dynamic>;
                      var testId = tests[index].id;
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: Icon(Icons.local_hospital_rounded,
                                color: Colors.blue, size: 40),
                            title: Text(
                              test['testName'] ?? 'No Name',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Details: ${test['testDetails'] ?? 'No Details'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Price: ${test['price'] ?? 'No Price'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Contact: ${test['contact'] ?? 'No Contact'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Duration: ${test['duration'] ?? 'No Duration'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    showEditDialog(test, testId);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteTest(testId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
