import 'package:budget_app/LogIn/login.dart';
import 'package:budget_app/SIgnUp/signup.dart';
import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> exitApp() async {
    await SystemNavigator.pop();
    return Future.value(true);
  }

  Future getStorage() async {
    var storagePermission =  await Permission.storage.status;
    if(storagePermission != PermissionStatus.granted) {
      storagePermission = await Permission.storage.request();
    }else{
      return;
    }
  }

  @override
  initState(){
    // TODO: implement initState
    super.initState();
    getStorage();
    // _getStoragePermission();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        backgroundColor: primarycolor,
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background1.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Righteous'),
                    )
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primarycolor,),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>
                        (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2
                    ),
                  ),
                ),
              ),
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .push(MaterialPageRoute(builder: (context) => SignUp()));
              //   },
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   minWidth: MediaQuery.of(context).size.width * 0.6,
              //   color: buttoncolor,
              //   splashColor: primarycolor,
              //   child: const Text("Sign Up",
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primarycolor,),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>
                        (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LogIn()));
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2
                    ),
                  ),
                ),
              ),
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .push(MaterialPageRoute(builder: (context) => LogIn()));
              //   },
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   minWidth: MediaQuery.of(context).size.width * 0.6,
              //   color: buttoncolor,
              //   splashColor: primarycolor,
              //   child: const Text("Log In",
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
              ),
              const Center(
                child: Text(
                  "#Logo",
                  style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
