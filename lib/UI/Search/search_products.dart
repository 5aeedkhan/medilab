import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedType; // Store selected type
  List<Map<String, dynamic>> searchResults = [];
  int _selectedIndex = 2; // Default to Search tab

  List<String> types = ['Medicines', 'Tests'];

  // Function to perform search
  Future<void> performSearch() async {
    if (selectedType != null && searchController.text.isNotEmpty) {
      String searchText = searchController.text.toLowerCase();
      print('Searching for: $searchText in $selectedType');

      QuerySnapshot querySnapshot;
      if (selectedType == 'Medicines') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('medicines')
            .where('searchKeywords', arrayContains: searchText)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('tests')
            .where('searchKeywords', arrayContains: searchText)
            .get();
      }

      print('QuerySnapshot: ${querySnapshot.docs.length} documents found');

      setState(() {
        searchResults = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
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
            ReusableTextfield(
              title: 'Enter Medicine or Test Name',
              controller: searchController,
              icon: Icon(Icons.search_outlined),
            ),
            ElevatedButton(
              onPressed: performSearch,
              child: Text('Search'),
            ),
            Text('Results'),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var result = searchResults[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result['medicineName'] ??
                                result['testName'] ??
                                'No Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (result.containsKey('formulaName'))
                            Text('Formula: ${result['formulaName']}'),
                          if (result.containsKey('companyName'))
                            Text('Company: ${result['companyName']}'),
                          if (result.containsKey('mlmg'))
                            Text('ML/MG: ${result['mlmg']}'),
                          if (result.containsKey('price'))
                            Text('Price: ${result['price']}'),
                          if (result.containsKey('status'))
                            Text('Status: ${result['status']}'),
                          if (result.containsKey('testDetails'))
                            Text('Details: ${result['testDetails']}'),
                          if (result.containsKey('contact'))
                            Text('Contact: ${result['contact']}'),
                          if (result.containsKey('duration'))
                            Text('Duration: ${result['duration']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
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
