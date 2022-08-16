import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../Database/Database.dart';
import '../colours.dart';

class TelePhone extends StatefulWidget {
  String id;
  String phone;
  TelePhone({Key? key, required this.phone, required this.id}) : super(key: key);

  @override
  State<TelePhone> createState() => _TelePhoneState();
}

class _TelePhoneState extends State<TelePhone> {

  final DataBase _db = DataBase();

  String localPhone = "";
  PhoneNumber value = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.white),),
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
              "Current Phone Number",
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
              child: Center(
                child: Text(
                  widget.phone,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "Change Phone Number",
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
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(()=> localPhone = number.phoneNumber.toString());
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {print(value);},
                selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET,),
                ignoreBlank: false,
                initialValue: value,
                formatInput: false,
                selectorTextStyle: const TextStyle(color: Colors.black),
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                cursorColor: Colors.black,
                inputDecoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                  border: InputBorder.none,
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 83, 83, 83),
                    fontSize: 16
                  ),
                ),
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
                      if (localPhone != "") {
                        await _db.updatePhone(widget.id, localPhone);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Phone Updated Successfully')),
                        );
                      }
                    },
                    child: const Text(
                      "Update",
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
                        backgroundColor: MaterialStateProperty.all(
                          primarycolor,
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
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
                // MaterialButton(
                //   onPressed: () {
                //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard()));
                //   },
                //   height: MediaQuery.of(context).size.height * 0.07,
                //   minWidth: MediaQuery.of(context).size.width * 0.3,
                //
                //   color: primarycolor,
                //   splashColor: buttoncolor,
                //   child: Text("Cancel",
                //       style: TextStyle(
                //         fontSize: 18,
                //       )),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
