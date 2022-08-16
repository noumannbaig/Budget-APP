import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:budget_app/colours.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:budget_app/Database/Database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:budget_app/SavedSMS/SaveSms.dart';
import 'package:intl/intl.dart';


import '../drawer.dart';


class DashboardScreen extends StatefulWidget {
  UserData userData;
  List<UserTransactionData> allTransaction;
  bool showAppBar;
  DashboardScreen({Key? key, required this.userData, required this.allTransaction, required this.showAppBar}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  Map<String, double> dataMap = {
    "Food": 0,
    "Transport": 0,
    "Restaurants": 0,
    "Others": 0,
    "Unassigned" : 0
  };

  void setDataMap(){
    for(int i = 0; i < widget.allTransaction.length; i++){
    final amount = int.parse(widget.allTransaction[i].debited.replaceAll(RegExp('[^0-9]'), '')) + int.parse(widget.allTransaction[i].credited.replaceAll(RegExp('[^0-9]'), ''));

    if(widget.allTransaction[i].category == "Food") {
        dataMap.update("Food", (value) => value + amount);
      }else if(widget.allTransaction[i].category == "Transport") {
        dataMap.update("Transport", (value) => value + amount);
      }else if(widget.allTransaction[i].category == "Restaurants") {
        dataMap.update("Restaurants", (value) => value + amount);
      }else if(widget.allTransaction[i].category == "") {
        dataMap.update("Unassigned", (value) => value + amount);
      }else{
        dataMap.update("Others", (value) => value + amount);
      }
    }
  }

  List<Color> colorList = [
    const Color(0xffD3c823),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539)
  ];

  late Future<List<UserPic>> futureFiles;
  int selected = 0;
  String currentMon = "";
  double currentMonAmount = 0;
  File? file;
  String sms = 'No sms';
  final DataBase _db = DataBase();
  String uploadImage = "assets/images/user.png";
  static const monthList = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

  Future _refresh() async{
    setState((){
      futureFiles = FirebaseApi.listAll(widget.userData.userID);
      setDataMap();
    });
  }
  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void onData(NotificationEvent event) {
    print("onData msg: ${event.text}");
    SavingSMS().savedSMS(widget.userData.userID, event.text!);
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    // register you event handler in the ui logic.
    NotificationsListener.receivePort?.listen((evt) => onData(evt));
  }

  void startListening() async {
    print("start listening");
    var hasPermission = await NotificationsListener.hasPermission;
    if (!(hasPermission!)) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!(isR!)) {
      await NotificationsListener.startService();
    }
    initPlatformState();
  }

  double getThisMonAmount(int mon){
      var regEXP = RegExp('(0.((0[1-9]{1})|([1-9]{1}([0-9]{1})?)))|(([1-9]+[0-9]*)(.([0-9]{1,2}))?)');
      double amount = 0;
      double debited = 0;

      for(int i = 0; i < widget.allTransaction.length; i++){

        var date = DateFormat('dd/MM/yyyy').parse(widget.allTransaction[i].date);
        var thisMon = date.month;
        debited = 0;

        for(int j = 0; j < widget.allTransaction[i].debited.length; j++){
          Iterable<Match> matches = regEXP.allMatches(widget.allTransaction[i].debited, j);
          for (final Match m in matches) {
            debited = double.parse(m[0]!);
          }
          break;
        }
        if(mon == thisMon) {
          amount = amount + debited;
        }
      }
      return amount;
  }

  @override
  initState(){
    super.initState();
    selected = (DateTime.now().month)-1;
    currentMon = monthList[selected];
    getPermission().then((value) {
      if (value) {
        PlatformChannel().smsStream().listen((event) {
          sms = event;
          print(sms);
          setState(() {
            SavingSMS().savedSMS(widget.userData.userID, sms);
          });
        });
      }
    });
    startListening();
    setDataMap();
    currentMonAmount = getThisMonAmount(selected);
  }

  @override
  Widget build(BuildContext context) {
    futureFiles = FirebaseApi.listAll(widget.userData.userID);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
      ? AppBar(
          elevation: 0,
          title:  Text("home".tr, style: TextStyle(color: Colors.white),),
          backgroundColor: primarycolor,
      )
      : null,
      drawer: widget.showAppBar ? Drawerr(allTransaction: widget.allTransaction, userData: widget.userData,) : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Container(
            color: primarycolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(
                      //       widget.userData.name, // the username with which the user signed in
                      //       style: const TextStyle(fontSize: 20, color: Colors.white),
                      //     ),
                      //     const Spacer(),
                      //     FutureBuilder<List<UserPic>>(
                      //       future: futureFiles,
                      //       builder: (context, snap) {
                      //         if (snap.hasData){
                      //           final files = snap.data!;
                      //           // final last = files.length;
                      //           return files.isEmpty ? Stack(
                      //             children: [
                      //               ClipOval(
                      //                 child: Material(
                      //                   color: Colors.transparent,
                      //                   child: Ink.image(
                      //                     image: const AssetImage("assets/images/user.png"), fit: BoxFit.cover, height: 100, width: 100,
                      //                     child: InkWell(onTap: onClicked,),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Positioned(bottom: 0, right: 5,
                      //                 child: buildCircle(color: Colors.white, all: 1.5,
                      //                   child: buildCircle(
                      //                     color: Theme.of(context).colorScheme.primary, all: 3,
                      //                     child: const Icon(Icons.add_a_photo, color: Colors.white, size: 15,),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ) : ProfileWidget(imagePath: files[0].url, onClicked: onClicked);
                      //         }
                      //         // else if(snap.connectionState == ConnectionState.waiting){
                      //         //   return ;
                      //         // }
                      //         else {
                      //           return const ClipOval(
                      //             child: SizedBox(
                      //               height: 40,
                      //               width: 40,
                      //               child: CircularProgressIndicator(),
                      //             ),
                      //           );
                      //         }
                      //       }
                      //     )
                      //   ],
                      // ),
                       Text(
                        'CurrentAmmount'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "KWD 127.352",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Righteous"
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "expenditure".tr,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "KWD $currentMonAmount",
                        style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Righteous"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: Column(
                    children: [
                      // const SizedBox(height: 15,),
                      // Center(
                      //   child: PieChart(
                      //     // chartLegendSpacing: MediaQuery.of(context).size.height * 0.1,
                      //     dataMap: dataMap,
                      //     colorList: colorList,
                      //     chartType: ChartType.ring,
                      //     centerTextStyle: const TextStyle(color: Colors.black),
                      //     chartRadius: MediaQuery.of(context).size.width / 3.3,
                      //     centerText: "KWD 127.352\nTotal Expenses\n2022",
                      //     ringStrokeWidth: MediaQuery.of(context).size.width * 0.02,
                      //     animationDuration: const Duration(seconds: 1),
                      //     chartValuesOptions: const ChartValuesOptions(
                      //         showChartValues: true,
                      //         showChartValuesOutside: true,
                      //         showChartValuesInPercentage: true,
                      //         showChartValueBackground: false
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 22,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          children: [
                            Row(
                              children:  [
                                Text(
                                  "recentpurchases".tr,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  "L2T".tr,
                                  style:
                                      TextStyle(fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(height: 12,),
                            Container(
                              color: Colors.black,
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                      widget.allTransaction.isEmpty
                      ?  Center(child: Text("nty".tr),)
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.allTransaction.length >= 20 ? 20 : widget.allTransaction.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return showTransaction(widget.allTransaction[index], context);
                          },
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onClicked() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],);

    if(result == null) return;
    final path = result.files.single.path!;

    setState((){
      file = File(path);
      uploadImage = path;
      uploadFile();
      Fluttertoast.showToast(msg: "Refresh the update profile picture");
    });
  }

  Future uploadFile() async{
    final fileName = basename(file!.path);
    final destination = "${widget.userData.userID}/$fileName";

    await FirebaseStorage.instance.ref("${widget.userData.userID}/").listAll().then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });

    FirebaseAPI.uploadFile(destination, file!);
  }

  Widget buildCircle({required Widget child, required double all, required Color color,}) => ClipOval(
    child: Container(
      padding: EdgeInsets.all(all),
      color: color,
      child: child,
    ),
  );

  Widget showTransaction(UserTransactionData data, BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        title: data.category.tr != "" ? Text(
          data.category.tr,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ) : GestureDetector(
            child: Text(
              "unassingned".tr,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.amber,
              ),
            ),
            onTap: () {
              alertDialogWidget(context, widget.userData.userID, data.smsID);
              setState(() => setDataMap());
            },
        ),
        subtitle: data.category == "" ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.place,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              "${data.date}, ${data.time}",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ): Text(
          "${data.date}, ${data.time}",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.credited == "0" ? data.debited : data.credited,
              style: TextStyle(fontSize: 18, color: data.credited == "0" ? Colors.red : Colors.green),
            ),
            SizedBox(width: 4,),
            InkWell(
              onTap: () => _db.deleteTransaction(widget.userData.userID, data.smsID),
              child: Icon(Icons.delete, color: Colors.black,),
            )
          ],
        ),
      ),
    );
  }



  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("salary".tr), value: "salary"),
      DropdownMenuItem(child: Text("rent".tr), value: "rent"),
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
      DropdownMenuItem(child: Text("investments".tr), value: "Investments",),
      DropdownMenuItem(child: Text("others".tr), value: "Others",),
      DropdownMenuItem(child: Text("unassigned".tr), value: "Unassigned",),
    ];
    return menuItems;
  }

  String selectedValue = "";
  final _dropdownFormKey = GlobalKey<FormState>();

  alertDialogWidget(BuildContext context, String collID, String docID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric( vertical: MediaQuery.of(context).size.height*0.02,
                horizontal: MediaQuery.of(context).size.width*0.02),
            // scrollable: true,
            title: Text("pleaseselect".tr),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.01,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.01),
              child: DropdownButtonFormField(
                focusColor: Colors.transparent,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'category'.tr,
                ),
                validator: (value) => value == null ? "s_a_c".tr : null,
                //value: _selectedValue,
                items: dropdownItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
            ),
            actions: [
              RaisedButton(
                color: primarycolor,
                onPressed: () async{
                  dynamic saved = await _db.updateCategory(selectedValue, collID, docID);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "accept".tr,
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              RaisedButton(
                color: primarycolor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "cancel".tr,
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}

class FirebaseAPI{
  static Future<UploadTask?> uploadFile(String des, File file) async {
    try{
      final ref = FirebaseStorage.instance.ref(des);
      return ref.putFile(file);
    }on FirebaseException catch(e){
      return null;
    }
  }
}


class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({Key? key, required this.imagePath, required this.onClicked,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme.primary;
    final image = imagePath.contains('https://') ? NetworkImage(imagePath) : FileImage(File(imagePath));

    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: image as ImageProvider,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                child: InkWell(onTap: onClicked),
              ),
            ),
          ),
          Positioned(bottom: 0, right: 5,
            child: buildCircle(color: Colors.white, all: 1.5,
              child: buildCircle(
                color: Theme.of(context).colorScheme.primary, all: 3,
                child: const Icon(Icons.add_a_photo, color: Colors.white, size: 15,),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class PlatformChannel {
  static const _channel = EventChannel("com.example.app/budget_app");

  Stream smsStream() async* {
    yield* _channel.receiveBroadcastStream();
  }
}
