import 'package:budget_app/Dashboard/dashboard_1.dart';
import 'package:budget_app/colours.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/Database/Database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Settings/FingerPrint.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final DataBase _db = DataBase();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool status = false;
  bool signIn = true;
  String email = "";
  String pass = "";
  String accPassword = "";
  bool isLogin = false;


  @override
  initState(){
    super.initState();
    showFingerPrint();
  }

  Future showFingerPrint()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      status = prefs.getBool('fingerPrint') ?? false;
      isLogin = prefs.getBool('Login') ?? false;
      accPassword = prefs.getString('AccountPassword') ?? "";
    });
    if(status == true){
      final auth = await LocalAuthApi.authenticate();

      if(auth){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    }
    print("initState status: $status");
    print("initState isLogin: $isLogin");
    print("initState accPass: $accPassword");
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: isLogin
            ?  Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background1.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.03,
                  top: MediaQuery.of(context).size.width * 0.03,
                  child: IconButton(
                      onPressed: () {Navigator.pop(context);},
                      icon: Icon(Icons.arrow_back_sharp)),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous'
                            ),
                          )
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                      accPassword != "" ? Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            labelText: 'Password',
                          ),
                          onChanged: (value) => pass = value,
                        ),
                      ) : Container(),
                      accPassword != "" ? SizedBox(height: MediaQuery.of(context).size.height * 0.02,) : Container(),
                      accPassword != "" ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(primarycolor,),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>
                                (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                          ),
                          onPressed: () async {
                            if (pass == "") {
                              Fluttertoast.showToast(msg: "Please enter email and password", textColor: Colors.white, gravity: ToastGravity.TOP);
                            } else {
                              if(accPassword == pass){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Dashboard())
                                );
                              }else{

                              }
                            }
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 2),
                          ),
                        ),
                      ) : Container(),
                      SizedBox(height:MediaQuery.of(context).size.height * 0.01,),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(primarycolor,),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>
                                (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var status = prefs.get('fingerPrint') ?? false;
                            if(status == true){
                              final auth = await LocalAuthApi.authenticate();
                              if(auth){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const Dashboard()),
                                );
                              }
                            }
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.fingerprint, size: 40,),
                              Spacer(),
                              Text(
                                "Use finger print",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                      Center(child: Container(child: Text("#Logo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),)),),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                    ],
                  ),
                ),
              ],
            )
            : Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background1.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.03,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_sharp)),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.17),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontSize: 39,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Righteous'),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        onChanged: (value) => email = value,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          labelText: 'Password',
                        ),
                        onChanged: (value) => pass = value,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primarycolor,),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>
                              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                        ),
                        onPressed: () async {
                          if (email == "" && pass == "") {
                            Fluttertoast.showToast(msg: "Please enter email and password", textColor: Colors.white, gravity: ToastGravity.TOP);
                          } else {
                            if(formKey.currentState!.validate()){
                              String? signInUser = await _db.signInUser(email, pass);
                              print("error: $signInUser");
                              if(signInUser == "not_found."){
                                setState(() {signIn = false; Fluttertoast.showToast(msg: "User does not exist", textColor: Colors.white, gravity: ToastGravity.TOP);});
                              }else if(signInUser == "invalid_Email"){
                                setState(() {signIn = false; Fluttertoast.showToast(msg: "Your email is incorrect", textColor: Colors.white, gravity: ToastGravity.TOP);});
                              }else if(signInUser == "wrong_password"){
                                setState(() {signIn = false; Fluttertoast.showToast(msg: "Your password is incorrect", textColor: Colors.white, gravity: ToastGravity.TOP);});
                              }else if(signInUser == "an_error"){
                                setState(() {signIn = false; Fluttertoast.showToast(msg: "There was an error during logging in", textColor: Colors.white, gravity: ToastGravity.TOP);});
                              }else{
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const Dashboard()));
                              }
                            }
                          }
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height * 0.015,),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.indigo,),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Forget Password',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {
                                if (email == "") {
                                  Fluttertoast.showToast(msg: "Please enter your email", textColor: Colors.white, gravity: ToastGravity.TOP)
                                }else{
                                  Fluttertoast.showToast(msg: 'The link has been sent to your email.', textColor: Colors.white, gravity: ToastGravity.TOP),
                                  _db.resetPass(email)
                                }
                              }
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height * 0.01,),
                    status ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primarycolor,),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>
                              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var status = prefs.get('fingerPrint') ?? false;
                          if(status == true){
                            final auth = await LocalAuthApi.authenticate();
                            if(auth){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const Dashboard()),
                              );
                            }
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.fingerprint, size: 40,),
                            Spacer(),
                            Text(
                              "Use finger print",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                      ),
                    ) : Container(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                    Center(child: Container(child: Text("#Logo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),)),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
