import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../drawer.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({ Key? key }) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool lockInBackground = true;
  bool English=true;
  bool Arabic=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("setting".tr, style: TextStyle(color: Colors.white),),
        backgroundColor: primarycolor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      //drawer: Drawerr(),
       body: SettingsList(
        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.0, horizontal: MediaQuery.of(context).size.width*0.02),
       sections: [
        SettingsSection(
            title: Text('select_lang'.tr, style: TextStyle(color: Colors.black),),
            tiles: [
              SettingsTile.switchTile(
                title: Text('english'.tr, style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.language, size: 19,),
               initialValue: English,
                onToggle: (bool value) {
                  setState(() {
                    English = value;
                    Arabic=false;
                    if(Arabic==false)
                    {
                      English=true;
                    }
                    
                     var locale=Locale('en','US');
                  Get.updateLocale(locale);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text('arabic'.tr, style: TextStyle(fontSize: 15),),
                leading: Icon(Icons.language, size: 19,),
               initialValue: Arabic,
                onToggle: (bool value) {
                  Arabic=true;
                  Arabic = value;
                  English=false;
                  if(English==false)
                  {
                    Arabic=true;
                  }
                  var locale=Locale('ar','ae');
                  Get.updateLocale(locale);
                },
              ),])
       ],
       )
    );
  }
}