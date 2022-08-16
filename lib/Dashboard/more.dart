import 'package:budget_app/Settings/ExtractCSV.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Settings/ChangePassword.dart';
import '../Settings/Email.dart';
import '../Settings/ExtractPdf.dart';
import '../Settings/PhoneNumber.dart';
import '../SplashScreen/splash_screen.dart';
import '../Settings/languageScreen.dart';
import 'package:budget_app/Database/Database.dart';
import 'package:open_file/open_file.dart';

import '../colours.dart';
import '../drawer.dart';

class MoreOptions extends StatefulWidget {
  UserData userData;
  List<UserTransactionData> allTransaction;
  bool showAppBar;
  MoreOptions({ Key? key, required this.userData, required this.allTransaction, required this.showAppBar}) : super(key: key);

  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
    bool lockInBackground = false;
    bool fingerPrint = false;

    final DataBase _db = DataBase();

    @override
    initState(){
      super.initState();
      getFingerStatus();
    }

    Future getFingerStatus()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState((){
          fingerPrint = prefs.getBool('fingerPrint') ?? false;
          lockInBackground = prefs.getBool('lockIn') ?? false;
      });

    }

    // final androidConfig = const FlutterBackgroundAndroidConfig(
    //   notificationTitle: "Background Service",
    //   notificationText: "Application is running in background",
    //   notificationImportance: AndroidNotificationImportance.Default,
    //   notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    // );
    //
    // void setBackground() async {
    //   await FlutterBackground.initialize(androidConfig: androidConfig);
    //   await FlutterBackground.enableBackgroundExecution();
    // }
    // void unSetBackground() async{
    //   await FlutterBackground.disableBackgroundExecution();
    // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
      ? AppBar(
        elevation: 0,
        title: Text("m_s".tr, style: TextStyle(color: Colors.white),),
        backgroundColor: primarycolor,
      )
      : null,
      drawer: widget.showAppBar ? Drawerr(allTransaction: widget.allTransaction, userData: widget.userData,) : null,
      body: SettingsList(
        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.0, horizontal: MediaQuery.of(context).size.width*0.02),
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.only(top: 0),
            title: Text('common'.tr,
            style: TextStyle(color: Colors.black),
            ),
            tiles: [
              SettingsTile(
                title: Text('lang'.tr, style: TextStyle(fontSize: 15),),
                description: Text('English'),
                leading: Icon(Icons.language, size: 19,),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguageScreen()));
                },
              ),
              SettingsTile(
                title: Text('extract_pdf'.tr, style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.picture_as_pdf, size: 19,),
                onPressed: (context) async{
                  final file = await PdfAPI.generatePdf(userData: widget.userData, smsData: widget.allTransaction);
                  await OpenFile.open(file.path);
                },
              ),
              SettingsTile(
                title: Text('extract_excel'.tr, style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.file_copy, size: 19,),
                onPressed: (context) async {
                  await ExcelApi.create_xlsx(UserData: UserData, smsData: widget.allTransaction);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('account'.tr, style: TextStyle(color: Colors.black),),
            tiles: [
              SettingsTile(title: Text('phone_no'.tr,  style: TextStyle(fontSize: 15),), leading: Icon(Icons.phone, size: 19,),
                onPressed: (context){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TelePhone(phone: widget.userData.number, id: widget.userData.userID,))
                  );
                },
              ),
              SettingsTile(title: Text('email'.tr,  style: TextStyle(fontSize: 15),), leading: Icon(Icons.email, size: 19,),
                onPressed: (context){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ShowEmail(email: widget.userData.email))
                  );
                },
              ),
              SettingsTile(title: Text('sign_out'.tr,  style: TextStyle(fontSize: 15),), leading: Icon(Icons.exit_to_app, size: 19,),
                onPressed: (context) async {
                  await FirebaseAuth.instance.signOut();
                  if(!fingerPrint){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('UserID');
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SplashScreen()));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('security'.tr, style: TextStyle(color: Colors.black),),
            tiles: [
              SettingsTile.switchTile(
                title: Text('L_A_B'.tr, style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.phonelink_lock, size: 19,),
                initialValue: lockInBackground,
                onToggle: (bool value) async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState((){
                    lockInBackground = value;
                    if(lockInBackground == true){
                      // setBackground();
                      prefs.setBool('lockIn', true);
                    }if(lockInBackground == false){
                      // unSetBackground();
                      prefs.setBool('lockIn', false);
                    }
                  });
                },
              ),
              SettingsTile.switchTile(
                  title: Text('use_finger'.tr,  style: TextStyle(fontSize: 15),),
                  leading: Icon(Icons.fingerprint, size: 19,),
                  initialValue: fingerPrint,
                  onToggle: (bool value) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState( ()  {
                      fingerPrint = value;
                      if(fingerPrint == true){
                        prefs.setBool('fingerPrint', true);
                      }if(fingerPrint == false){
                        prefs.setBool('fingerPrint', false);
                      }
                    });
                  },
              ),
              SettingsTile(
                title: Text('change_pass'.tr,  style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.lock, size: 19,),
                onPressed: (context){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePassword(
                        pass: widget.userData.accPass,
                        id: widget.userData.userID,
                      ))
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('misc'.tr, style: TextStyle(color: Colors.black),),
            tiles: [
              SettingsTile(
                  title: Text('TOS'.tr, style: TextStyle(fontSize: 15),), leading: Icon(Icons.description, size: 19,),
                  onPressed: (context){},
              ),
              SettingsTile(
                  title: Text('O_S_L'.tr, style: TextStyle(fontSize: 15),),
                  leading: Icon(Icons.collections_bookmark, size: 19,),
                  onPressed: (context){},
              ),
            ],
          )
        ],
      ),
    );
  }
}