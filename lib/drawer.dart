import 'package:budget_app/Dashboard/more.dart';
import 'package:budget_app/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/Database/Database.dart';
import 'package:budget_app/Dashboard/history.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard/dashboard_1.dart';
import 'Dashboard/manual_input.dart';
import 'Dashboard/piechart.dart';
import 'SplashScreen/splash_screen.dart';

class Drawerr extends StatefulWidget {
  UserData userData;
  List<UserTransactionData> allTransaction;
  Drawerr({Key? key, required this.userData, required this.allTransaction}) : super(key: key);

  @override
  State<Drawerr> createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  late Future<List<UserPic>> futureFiles;
  @override
  Widget build(BuildContext context) {
    futureFiles = FirebaseApi.listAll(widget.userData.userID);
    return Drawer(
      elevation: 1,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          FutureBuilder<List<UserPic>>(
            future: futureFiles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final files = snapshot.data!;
                final last = files.length;
                return UserAccountsDrawerHeader(
                  accountName: Text(widget.userData.name),
                  accountEmail: Text(widget.userData.email),
                  decoration: BoxDecoration(color: primarycolor, borderRadius: BorderRadius.circular(20)),
                  currentAccountPicture: files.isEmpty
                  ? Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/user.png"), fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : ClipOval(
                    child: Image.network(files[last-1].url, fit: BoxFit.cover,),
                  )
                );
              }else{
                return UserAccountsDrawerHeader(
                    accountName: Text(widget.userData.name),
                    accountEmail: Text(widget.userData.email),
                    decoration: BoxDecoration(color: primarycolor, borderRadius: BorderRadius.circular(20)),
                    currentAccountPicture: const SizedBox(height: 40, width: 40,child: CircularProgressIndicator()),
                );
              }
            }),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("home".tr),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard())),
          ),
          ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text("expense".tr),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  PieChartScreen(userData: widget.userData, allTransaction: widget.allTransaction, showAppBar: true,)))),
          ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("_add".tr),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  Manual_input(userData: widget.userData, allTransaction: widget.allTransaction, showAppBar: true,)))),
          ListTile(
              leading: Icon(Icons.history),
              title: Text("history".tr),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  History(userData: widget.userData, allTransaction: widget.allTransaction, showAppBar: true,)))),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text("setting".tr),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  MoreOptions(userData: widget.userData, allTransaction: widget.allTransaction, showAppBar: true,)))),
          // ListTile(
          //   leading: Icon(Icons.phone),
          //   title: Text("Contact"),
          //     onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoreOptions(userData: widget.userData, allTransaction: widget.allTransaction,)))
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("sign_out".tr),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var flag = prefs.getBool('fingerPrint') ?? false;
              if(!flag){
                prefs.remove('UserID');
                prefs.remove('Login');
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SplashScreen()));
            },
          ),
        ],
      ),
    );
  }
}
