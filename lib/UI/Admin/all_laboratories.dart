import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllLaboratoriesScreen extends StatefulWidget {
  const AllLaboratoriesScreen({super.key});

  @override
  State<AllLaboratoriesScreen> createState() => _AllLaboratoriesScreenState();
}

class _AllLaboratoriesScreenState extends State<AllLaboratoriesScreen> {
  // Function to delete a laboratory from Firestore
  Future<void> deleteLaboratory(String id) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laboratory deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete laboratory: $e')),
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
                    .where('role', isEqualTo: 'Lab')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No laboratories found'));
                  }

                  var laboratories = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: laboratories.length,
                    itemBuilder: (context, index) {
                      var laboratory =
                          laboratories[index].data() as Map<String, dynamic>;
                      var laboratoryId = laboratories[index].id;
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
                            leading: Icon(Icons.science,
                                color: Colors.blue, size: 40),
                            title: Text(
                              laboratory['storeTitle'] ?? 'No Title',
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
                                  'Username: ${laboratory['username'] ?? 'No Username'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Email: ${laboratory['email'] ?? 'No Email'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Address: ${laboratory['address'] ?? 'No Address'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Opening Time: ${laboratory['opentime'] ?? 'No Opening Time'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Closing Time: ${laboratory['closetime'] ?? 'No Closing Time'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteLaboratory(laboratoryId);
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
