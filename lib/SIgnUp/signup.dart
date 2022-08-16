import 'package:budget_app/colours.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:budget_app/Database/Database.dart';

import '../Dashboard/dashboard_1.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  final DataBase _db = DataBase();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  String _currency = "";
  String phone = "";
  PhoneNumber value = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
          Positioned(
            left: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.width * 0.03,
            child: IconButton(
                onPressed: () {Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back_sharp)),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: 'Righteous'),
                    )
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                    validator: (value){
                      if(value!.isEmpty || RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)){
                        return "Enter correct Name";
                      }
                      else{
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.05
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Email is required"),
                      EmailValidator(errorText: "Not a valid Email")
                    ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black.withOpacity(0.5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.transparent,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(()=> phone = number.phoneNumber.toString());
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
                                fontSize: 16),
                            ),
                          ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.09,
                  //margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Color.fromARGB(255, 27, 27, 27).withOpacity(0.5)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.transparent,
                        //blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: Colors.red.withOpacity(0),
                    ),
                    onPressed: () {
                      showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currency) {
                          setState(()=> _currency = currency.code);
                          print('Select currency: ${currency.code}');
                        },
                      );
                    },
                    child: Text(
                      _currency == "" ? 'Select Currency' : _currency,
                      style: const TextStyle(color: Color.fromARGB(255, 80, 80, 80)),
                    ),
                  ),
                  // child: TextField(
                  //   controller: emailController,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Currency',
                  //   ),
                  // ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Container(
                  //  width: MediaQuery.of(context).size.width*0.9,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
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
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      // add your custom validation here.
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 6) {
                        return 'Must be more than 6 character';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
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
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      // add your custom validation here.
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 6) {
                        return 'Must be more than 6 character';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
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
                        if(formKey.currentState!.validate()){
                          dynamic user = await _db.registerUser(nameController.text, phone, _currency, emailController.text, passwordController.text);
                          if (user != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Dashboard()));
                          }
                        }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2),
                    ),
                  ),
                ),
                // MaterialButton(
                //   onPressed: () async {
                //     print("Name: ${nameController.text}");
                //     print("email: ${emailController.text}");
                //     print("Phone: $phone");
                //     print("Currency: $_currency");
                //     print("pass: ${passwordController.text}");
                //     print("2Pass: ${confirmPasswordController.text}");
                //     if(formKey.currentState!.validate()){
                //       dynamic user = await _db.registerUser(nameController.text, phone, _currency, emailController.text, passwordController.text);
                //       if (user != null) {
                //         Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => const Dashboard()));
                //       }
                //     }
                //   },
                //   height: MediaQuery.of(context).size.height * 0.09,
                //   minWidth: MediaQuery.of(context).size.width * 0.6,
                //   color: primarycolor,
                //   splashColor: buttoncolor,
                //   child: const Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
                // Center(
                //   child: Container(
                //     child: Text("#Logo",
                //     style: TextStyle(
                //       fontSize: 30,
                //       fontWeight: FontWeight.bold,),)),
                // ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
