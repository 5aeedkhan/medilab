import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medilab/splashscreen.dart';
import 'package:medilab/Model/navigation_routes.dart';
import 'package:medilab/UI/Admin/admin_dashboard.dart';
import 'package:medilab/UI/Admin/admin_login.dart';
import 'package:medilab/UI/Admin/all_laboratories.dart';
import 'package:medilab/UI/Admin/all_pharmacies.dart';
import 'package:medilab/UI/Search/search_products.dart';
import 'package:medilab/UI/Users/register_users.dart';
import 'package:medilab/UI/role_selection_page.dart';
import 'package:medilab/UI/Users/Laboratories/add_new_tests.dart';
import 'package:medilab/UI/Users/Laboratories/all_tests_laboratory.dart';
import 'package:medilab/UI/Users/Laboratories/laboratories_dashboard.dart';
import 'package:medilab/UI/Users/Laboratories/update_laboratory_profile.dart';
import 'package:medilab/UI/Users/Pharmacies/add_new_medicines.dart';
import 'package:medilab/UI/Users/Pharmacies/all_products_pharmacy.dart';
import 'package:medilab/UI/Users/Pharmacies/pharmacies_dashboard.dart';
import 'package:medilab/UI/Users/Pharmacies/update_pharmacy_profile.dart';
import 'package:medilab/UI/Users/users_login.dart';
import 'package:medilab/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color(0xff5086A6)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: NavigationRoutes.splashscreen,
      routes: {
        NavigationRoutes.role_selection_screen: (context) =>
            RoleSelectionScreen(),
        NavigationRoutes.splashscreen: (context) => SplashScreen(),
        NavigationRoutes.admin_login: (context) => AdminLoginScreen(),
        NavigationRoutes.admin_dashboard: (context) => AdminDashboard(),
        NavigationRoutes.all_pharmacies: (context) => AllPharmaciesScreen(),
        NavigationRoutes.all_laboratories: (context) => AllLaboratoriesScreen(),
        NavigationRoutes.users_login: (context) => UsersLoginScreen(),
        NavigationRoutes.pharmacies_dashboard: (context) =>
            PharmaciesDashboardScreen(),
        NavigationRoutes.laboratories_dashboard: (context) =>
            LaboratoriesDashboardScreen(),
        NavigationRoutes.all_products_pharmacy: (context) =>
            AllProductsofPharmacies(),
        NavigationRoutes.add_new_medicines: (context) =>
            AddNewMedicinesScreen(),
        NavigationRoutes.update_pharmacy_profile: (context) =>
            UpdatePharmacyProfileScreen(),
        NavigationRoutes.all_tests_laboratory: (context) =>
            AllTestsofLaboratoriesScreen(),
        NavigationRoutes.add_new_tests: (context) => AddNewTestsScreen(),
        NavigationRoutes.update_laboratory_profile: (context) =>
            UpdateLaboratoryProfileScreen(),
        NavigationRoutes.search_products: (context) => SearchProductsScreen(),
        NavigationRoutes.register_users: (context) => RegisterUsersScreen(),
      },
    );
  }
}
