import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; // Default to Admin tab

  // Function to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.pushNamed(context, NavigationRoutes.admin_dashboard);
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
            SizedBox(height: 15),
            Text(
              'ADMIN DASHBOARD',
              style: kHeadingTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableDashboardImages(
                      image: Image.asset('assets/images/pharmaciesicon.png'),
                      text: 'All Pharmacies',
                      onTap: () {
                        Navigator.pushNamed(
                            context, NavigationRoutes.all_pharmacies);
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableDashboardImages(
                      image:
                          Image.asset('assets/images/laboratoriesicon-01.png'),
                      text: 'All Laboratories',
                      onTap: () {
                        Navigator.pushNamed(
                            context, NavigationRoutes.all_laboratories);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, NavigationRoutes.role_selection_screen);
              },
              child: Image.asset(
                  height: 100, width: 100, 'assets/images/logoutadmin.png'),
            ),
            Text(
              'Logout',
              style: kGoogleBlackTextStyle,
            ),
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
