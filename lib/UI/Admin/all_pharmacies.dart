import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllPharmaciesScreen extends StatefulWidget {
  const AllPharmaciesScreen({super.key});

  @override
  State<AllPharmaciesScreen> createState() => _AllPharmaciesScreenState();
}

class _AllPharmaciesScreenState extends State<AllPharmaciesScreen> {
  // Function to delete a pharmacy from Firestore
  Future<void> deletePharmacy(String id) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pharmacy deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete pharmacy: $e')),
      );
    }
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
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'Pharmacy')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No pharmacies found'));
                  }

                  var pharmacies = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: pharmacies.length,
                    itemBuilder: (context, index) {
                      var pharmacy =
                          pharmacies[index].data() as Map<String, dynamic>;
                      var pharmacyId = pharmacies[index].id;
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
                            leading: Icon(Icons.local_pharmacy,
                                color: Colors.blue, size: 40),
                            title: Text(
                              pharmacy['storeTitle'] ?? 'No Title',
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
                                  'Username: ${pharmacy['username'] ?? 'No Username'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Email: ${pharmacy['email'] ?? 'No Email'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Address: ${pharmacy['address'] ?? 'No Address'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Opening Time: ${pharmacy['opentime'] ?? 'No Opening Time'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Closing Time: ${pharmacy['closetime'] ?? 'No Closing Time'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deletePharmacy(pharmacyId);
                              },
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
