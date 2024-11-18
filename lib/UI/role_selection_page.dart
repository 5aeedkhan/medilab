import 'package:flutter/material.dart';
import 'package:medilab/Constants/constants.dart';
import 'package:medilab/Model/navigation_routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int _selectedIndex = 0; // Default to Admin tab

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
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5086A6), Color(0xff5086A6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
              // Using Expanded to fill available space
              Image.asset(
                  height: 150, width: 150, 'assets/images/medicinetracker.png'),
              Expanded(
                child: Center(
                  child: Card(
                    color: Color(0xff5086A6),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'WELCOME TO MEDILAB',
                                textStyle: kHeadingTextStyle.copyWith(
                                  fontSize: 28,
                                  color: Color(0xffAACFD0),
                                ),
                                speed: Duration(milliseconds: 100),
                              ),
                            ],
                            repeatForever: true,
                            pause: Duration(milliseconds: 1000),
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.admin_panel_settings,
              color: Color(0xffAACFD0),
            ),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Color(0xffAACFD0)),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color(0xffAACFD0)),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        backgroundColor: Color(0xff5086A6),
        onTap: _onItemTapped,
      ),
    );
  }
}
