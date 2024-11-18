import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/reusable_widgets.dart';

class AllProductsofPharmacies extends StatefulWidget {
  const AllProductsofPharmacies({super.key});

  @override
  State<AllProductsofPharmacies> createState() =>
      _AllProductsofPharmaciesState();
}

class _AllProductsofPharmaciesState extends State<AllProductsofPharmacies> {
  // List to store fetched data
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Function to fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('medicines').get();

      setState(() {
        products = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Function to delete a product from Firestore
  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('medicines').doc(id).delete();
      fetchProducts(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

  // Function to show edit dialog
  void showEditDialog(Map<String, dynamic> product) {
    TextEditingController medicineController =
        TextEditingController(text: product['medicineName']);
    TextEditingController formulaController =
        TextEditingController(text: product['formulaName']);
    TextEditingController mlmgController =
        TextEditingController(text: product['mlmg']);
    TextEditingController companynameController =
        TextEditingController(text: product['companyName']);
    TextEditingController priceController =
        TextEditingController(text: product['price']);
    String? selectedType = product['type'];
    String? selectedStatus = product['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: Text('Select Type'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                  items:
                      ['Tablet', 'Syrup', 'Injection', 'Capsule'].map((type) {
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
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  hint: Text('Select Status'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  items: ['In Stock', 'Out of Stock'].map((status) {
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
                      .collection('medicines')
                      .doc(product['id'])
                      .update({
                    'medicineName': medicineController.text,
                    'formulaName': formulaController.text,
                    'mlmg': mlmgController.text,
                    'companyName': companynameController.text,
                    'price': priceController.text,
                    'type': selectedType,
                    'status': selectedStatus,
                  });
                  fetchProducts(); // Refresh the list after update
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update product: $e')),
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
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Icon(Icons.medical_services,
                            color: Colors.blue, size: 40),
                        title: Text(
                          product['medicineName'] ?? 'No Name',
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
                              'Formula: ${product['formulaName'] ?? 'No Formula'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Company: ${product['companyName'] ?? 'No Company'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Price: ${product['price'] ?? 'No Price'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Type: ${product['type'] ?? 'No Type'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Status: ${product['status'] ?? 'No Status'}',
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
                                showEditDialog(product);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteProduct(product['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
