// @dart=2.9
import 'package:budget_app/Dashboard/dashboard_2.dart';
import 'package:budget_app/LogIn/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_app/SplashScreen/splash_screen.dart';
import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ArabicLanguage/localStrings.dart';
import 'Dashboard/dashboard_1.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('fingerPrint') ?? false;

  runApp(GetMaterialApp(
    translations: LocalString(),
    locale: const Locale('en','US'),
    debugShowCheckedModeBanner: false,
    title: 'Budget App',
    theme: ThemeData(primaryColor: primarycolor, primarySwatch: Colors.purple,),
    home: status ? const LogIn() :const SplashScreen(),)
    // home: const SplashScreen())
    
  );
}
