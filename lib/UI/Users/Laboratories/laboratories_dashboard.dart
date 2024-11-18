import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Constants/reusable_widgets.dart';
import 'package:medilab/Model/navigation_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaboratoriesDashboardScreen extends StatefulWidget {
  const LaboratoriesDashboardScreen({super.key});

  @override
  State<LaboratoriesDashboardScreen> createState() =>
      _LaboratoriesDashboardScreenState();
}

class _LaboratoriesDashboardScreenState
    extends State<LaboratoriesDashboardScreen> {
  int _selectedIndex = 0; // Default to Dashboard tab

  // Function to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.pushNamed(context, NavigationRoutes.laboratories_dashboard);
        break;
      case 1:
        Navigator.pushNamed(context, NavigationRoutes.admin_login);
        break;
      case 2:
        Navigator.pushNamed(context, NavigationRoutes.search_products);
        break;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isUserLoggedIn');
    await prefs.remove('userRole');
    Navigator.pushNamed(context, NavigationRoutes.role_selection_screen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Image
            Image.asset(
              'assets/images/banner.png',
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Text(
              'Laboratories Dashboard',
              style: kHeadingTextStyle,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReusableDashboardImages(
                    image: Image.asset('assets/images/allproducts.png'),
                    text: 'All Tests',
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigationRoutes.all_tests_laboratory);
                    }),
                ReusableDashboardImages(
                    image: Image.asset('assets/images/addicon.png'),
                    text: 'Add new Test',
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigationRoutes.add_new_tests);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReusableDashboardImages(
                    image: Image.asset('assets/images/setting.png'),
                    text: 'Update Profile',
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigationRoutes.update_laboratory_profile);
                    }),
                ReusableDashboardImages(
                  image: Image.asset('assets/images/logout.png'),
                  text: 'Logout',
                  onTap: logout,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
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
