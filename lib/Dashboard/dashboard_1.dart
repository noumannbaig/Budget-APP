import 'dart:async';

import 'package:budget_app/Dashboard/dashboard_2.dart';
import 'package:budget_app/Dashboard/history.dart';
import 'package:budget_app/Dashboard/manual_input.dart';
import 'package:budget_app/Dashboard/more.dart';
import 'package:budget_app/Dashboard/piechart.dart';
import 'package:budget_app/colours.dart';
import 'package:budget_app/drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Database.dart';
import '../LogIn/login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String userID = "";
  bool status = false;
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  DateTime currentBackPressTime = DateTime.now();

  final DataBase _db = DataBase();

  static const iconList = [
    Icon(Icons.home, color: Colors.white,),
    Icon(Icons.pie_chart, color: Colors.white,),
    Icon(Icons.add_circle_outline, color: Colors.white,),
    Icon(Icons.history, color: Colors.white,),
    Icon(Icons.more_horiz, color: Colors.white,)
  ];

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();

    setState(() => canResendEmail = false);
    await Future.delayed(Duration(seconds: 5));
    setState(() => canResendEmail = true);

    timer = Timer.periodic(

        Duration(seconds: 3),
            (_) => checkEmailVerified()
    );
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  Future setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('UserID')!;
    prefs.setBool('fingerPrint', true);
    prefs.setBool('Login', true);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  Future verifyEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      status = prefs.getBool('fingerPrint') ?? false;
    });
    if(status == false){
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if(!isEmailVerified){
        sendVerificationEmail();
      }
    }else{
      isEmailVerified = true;
    }
  }


  @override
  initState() {
    super.initState();
    setLogin();
    verifyEmail();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return FutureBuilder<UserData?>(
            future: _db.getUser(userID),
            builder: (context, snaps) {
              if(snaps.hasData) {
                final user = snaps.data!;
                return StreamBuilder<List<UserTransactionData>> (
                  stream: _db.getUserTransaction(user.userID),
                  builder: (context, transactions){
                    final transaction = transactions.data!;
                    final List _pages = [
                      DashboardScreen(userData: user, allTransaction: transaction, showAppBar: false),
                      PieChartScreen(userData: user, allTransaction : transaction, showAppBar: false),
                      Manual_input(userData: user, allTransaction : transaction, showAppBar: false),
                      History(userData: user, allTransaction : transaction, showAppBar: false),
                      MoreOptions(userData: user, allTransaction : transaction, showAppBar: false)
                    ];
                    return WillPopScope(
                      onWillPop: onWillPop,
                      child: Scaffold(
                        extendBody: true,
                        appBar: AppBar(
                          elevation: 0,
                          title: title(),
                          backgroundColor: primarycolor,
                        ),
                        drawer: Drawerr(userData: user, allTransaction: transaction),
                        body: Padding(
                          padding: const EdgeInsets.only(bottom: 70.0),
                          child: _pages[_selectedIndex],
                        ),
                        bottomNavigationBar: CurvedNavigationBar(
                          index: _selectedIndex,
                          height: 70,
                          buttonBackgroundColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          color: primarycolor,
                          items: iconList,
                          onTap: (index) => setState(() => _selectedIndex = index),
                        ),
                      ),
                    );
                  }
                );
              }else if(snaps.connectionState == ConnectionState.waiting){
                print("userID in waiting: $userID");
                return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
              }else{
                print("userID in wrong: $userID");
                return const Scaffold(body: Center(child: Text("Something went wrong!")),);
              }
            },
          );
        },
      );
  }

  Widget title() {
    if (_selectedIndex == 0) {
      return  Text("home".tr);
    } else if (_selectedIndex == 1) {
      return Text("expenditure".tr);
    } else if (_selectedIndex == 2) {
      return Text("add_manually".tr);
    } else if (_selectedIndex == 3) {
      return Text("history".tr);
    } else {
      return Text("m_s".tr);
    }
  }
}


