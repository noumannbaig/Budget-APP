import 'package:budget_app/Dashboard/dashboard_1.dart';
import 'package:budget_app/colours.dart';
import 'package:budget_app/income_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:budget_app/Database/Database.dart';

import '../drawer.dart';

class Manual_input extends StatefulWidget {
  UserData userData;
  List<UserTransactionData> allTransaction;
  bool showAppBar;
  Manual_input({Key? key, required this.userData, required this.allTransaction, required this.showAppBar})
      : super(key: key);

  @override
  State<Manual_input> createState() => _Manual_inputState();
}

class _Manual_inputState extends State<Manual_input> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String date = "";
  String time = "";
  String debited = "0";
  String credited = "0";
  String place = "";
  String bank = "";
  String category = "";

  // id, name, bank, date, debited, credited, place, time, category

  bool income = false;

  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  int _income_expense = 0;
  int _card_cash = 0;

  final DataBase _db = DataBase();

  final List<String> in_exp = ["income".tr, "expense".tr];

  final List<String> card_ca = ["card".tr, "cash".tr];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems =  [
      DropdownMenuItem(child: Text("salary".tr), value: "Salary"),
      DropdownMenuItem(child: Text("rent".tr), value: "Rent"),
      DropdownMenuItem(child: Text("bills".tr), value: "Bills"),
      DropdownMenuItem(child: Text("groceries".tr), value: "Groceries"),
      DropdownMenuItem(child: Text("medical".tr), value: "Medical"),
      DropdownMenuItem(child: Text("transportation".tr), value: "Transportation"),
      DropdownMenuItem(child: Text("r_o".tr), value: "Restaurants/Ordering"),
      DropdownMenuItem(child: Text("shopping".tr), value: "Shopping"),
      DropdownMenuItem(child: Text("p_s".tr), value: "Personal Spending"),
      DropdownMenuItem(child: Text("vacation".tr), value: "Vacation",),
      DropdownMenuItem(child: Text("gifts".tr), value: "Gifts",),
      DropdownMenuItem(child: Text("saving".tr), value: "Saving",),
      DropdownMenuItem(child: Text("investment".tr), value: "Investments",),
      DropdownMenuItem(child: Text("others".tr), value: "Others",),
      DropdownMenuItem(child: Text("unassigned".tr), value: "Unassigned",),
    ];
    return menuItems;
  }

  // String? _selectedValue = null;
  // final _dropdownFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    timeController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
      ? AppBar(
        elevation: 0,
        title:  Text("add_manually".tr, style: TextStyle(color: Colors.white),),
        backgroundColor: primarycolor,
      )
      : null,
      drawer: widget.showAppBar ? Drawerr(allTransaction: widget.allTransaction, userData: widget.userData,) : null,
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.03),
                  child: TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'p_e_a_v_ammount'.tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'input_amount'.tr,
                    ),
                    onChanged: (value){
                      setState((){
                        _income_expense == 0
                            ? credited = "+${amountController.text}"
                            : debited = "-${amountController.text}";
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: DropdownButtonFormField(
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'category'.tr,
                    ),
                    validator: (value) =>
                        value == null ? "s_a_c".tr : null,
                    //value: _selectedValue,
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _income_expense = index;
                          if(_income_expense == 0) {
                            credited = "+${amountController.text}";
                            debited = "0";
                          }else{
                            debited = "-${amountController.text}";
                            credited = "0";
                          }
                        });
                      },
                      child: Income_expense(
                        _income_expense == index,
                        in_exp[index],
                      ),
                    ),
                    separatorBuilder: (_, index) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,),
                      itemCount: in_exp.length
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {_card_cash = index;});
                      },
                      child: Income_expense(
                        _card_cash == index,
                        card_ca[index],
                      ),
                    ),
                    separatorBuilder: (_, index) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    itemCount: card_ca.length
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "select_date".tr,
                    ),
                    onTap: () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
                      );
                      if (selected != null && selected != selectedDate) {
                        setState(() {selectedDate = selected;});
                      }if (selected != null) {
                        print(selected);
                        String formattedDate = DateFormat('dd/MM/yyyy').format(selected);
                        print(formattedDate);
                        setState(() {dateController.text = formattedDate;});
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "select_time".tr,
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (pickedTime != null) {
                        print(pickedTime.format(context));
                        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime);
                        setState(() {timeController.text = formattedTime;});
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
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
                          if (_formKey.currentState!.validate()) {
                            // print("debited: $debited");
                            // print("credited: $credited");
                            // print("Category: $category");
                            // print("bank: $bank");
                            // print("useriD: ${widget.userData.userID}");
                            // print("place: $place");
                            // print("time: ${timecontroller.text}");
                            // print("date: ${datecontroller.text}");
                            String id = "${dateController.text.replaceAll(RegExp('[^0-9]'), '')}_${timeController.text}";
                            // print("id $id");
                            await _db.saveSMSInformation(id, widget.userData.userID, bank, dateController.text, debited, credited, place, timeController.text, category);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('a_a'.tr)),
                            );
                          }
                        },
                        child:  Text(
                          "a_a".tr,
                          style:const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(content: Text('Amount Added')),
                    //       );
                    //     }
                    //   },
                    //   height: MediaQuery.of(context).size.height * 0.07,
                    //   minWidth: MediaQuery.of(context).size.width * 0.3,
                    //   color: primarycolor,
                    //   splashColor: buttoncolor,
                    //   child: Text("Add",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //       )),
                    // ),
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Dashboard()));
                        },
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            ),
          )
      ),
    );
  }

  // _selectDate(BuildContext context) async {
  //   final DateTime? selected = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2010),
  //     lastDate: DateTime(2025),
  //   );
  //   if (selected != null && selected != selectedDate)
  //     setState(() {
  //       selectedDate = selected;
  //     });
  // }
}
