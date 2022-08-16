import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Database.dart';
import '../colours.dart';

class ChangePassword extends StatefulWidget {
  String id;
  String pass;
  ChangePassword({Key? key, required this.pass, required this.id}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool visible = false;
  String password = "";

  final DataBase _db = DataBase();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("setting".tr, style: TextStyle(color: Colors.white),),
        backgroundColor: primarycolor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pass != "" ? "Current Account Password" : "You don't have password for current Account",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 14,),
            widget.pass == "" ? Container() : Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(0,4),
                    blurRadius: 4,
                  )
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Text(
                    visible ? widget.pass : "**********",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState((){visible = !visible;}),
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                    )
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "Change Password",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 14,),
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(0,4),
                    blurRadius: 4,
                  )
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: !visible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () => setState(() {visible = !visible;})
                  ),
                  border: InputBorder.none,
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }if (value.length < 6) {
                    return 'Must be more than 6 character';
                  }
                  return null;
                },
                onChanged: (value) => password = value,
              ),
            ),
            const SizedBox(height: 70,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primarycolor,),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),))
                    ),
                    onPressed: () async {
                      if (password != "") {
                        await _db.updatePassword(widget.id, password);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('AccountPassword', password);
                      }else{
                        Fluttertoast.showToast(msg: "Please fill in the password field", gravity: ToastGravity.TOP);
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.07,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primarycolor,),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)
                      )
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
