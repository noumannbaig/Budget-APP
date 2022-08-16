import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBase{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference userData = FirebaseFirestore.instance.collection("UserData");

  String? signInUserid;

  Future registerUser(String name, String number, String currency, String email, String pass)async{
    UserCredential credit = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    User user = credit.user as User;
    signInUserid = user.uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserID', user.uid);

    try{
      await userData.doc(signInUserid).set({
        "UserID": signInUserid,
        "FullName": name,
        "ContactNumber": number,
        "Currency" : currency,
        "Email": email,
        "Password": pass,
        "AccountPassword": "",
      });
    }catch(e) {
      print("Error: $e");
    }

    return signInUserid;
  }

  Future<String?> signInUser(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User logInUser = credential.user as User;
      signInUserid = logInUser.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserID', logInUser.uid);
      print("userID in singIN: $signInUserid");
      return signInUserid;
    }
    catch(e){
      return Errors.show(e.toString());
    }
  }

  Future<UserData?> getUser(String uid) async{
    final userData = FirebaseFirestore.instance.collection("UserData").doc(uid);
    final snapshot = await userData.get();
    if(snapshot.exists){
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future saveSMSInformation(String id, String name, String bank, String date, String debited, String credited, String place, String time, String category)async{
    final CollectionReference smsData = FirebaseFirestore.instance.collection(name);
    try{
      await smsData.doc(id).set({
        "Bank": bank,
        "Date" : date,
        "Debited" : debited,
        "Credited" : credited,
        "Place": place,
        "time" : time,
        "Category" : category,
        "smsID": id,
      });
    }catch(e) {
      print("Error: $e");
    }
  }

  Future updateCategory(String value, String collectionID, String docID)async{
    final doc = FirebaseFirestore.instance.collection(collectionID).doc(docID);
    doc.update({
      "Category" : value,
    });
  }

  Future updatePhone(String userID, String phone) async{
    final doc = FirebaseFirestore.instance.collection("UserData").doc(userID);
    doc.update({
      "ContactNumber" : phone,
    });
  }

  Future updatePassword(String userID, String pass) async{
    final doc = FirebaseFirestore.instance.collection("UserData").doc(userID);
    doc.update({
      "AccountPassword" : pass,
    });
  }

  Future resetPass(String email)async{
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future deleteTransaction(String collectionID, String docID) async{
    final doc = FirebaseFirestore.instance.collection(collectionID).doc(docID);
    doc.delete();
  }

  Stream<List<UserTransactionData>> getUserTransaction(String id) => FirebaseFirestore.instance
      .collection(id)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UserTransactionData.fromJson(doc.data())).toList());


}

class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        return "not_found.";

      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return "invalid_Email.";

      case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
        return "wrong_password";

      default:
        return "an_error";
    }
  }
}

class UserData{
  final userID;
  final name;
  final number;
  final currency;
  final email;
  final password;
  final accPass;

  UserData({
    required this.userID,
    required this.name,
    required this.number,
    required this.currency,
    required this.email,
    required this.password,
    required this.accPass,
  });

  static UserData fromJson(Map<String, dynamic> doc) => UserData(
    userID: doc["UserID"],
    name: doc["FullName"],
    number: doc["ContactNumber"],
    currency: doc["Currency"],
    email: doc["Email"],
    password: doc["Password"],
    accPass: doc["AccountPassword"],
  );
}

class UserPic {
  final Reference ref;
  final String name;
  final String url;

  const UserPic({
    required this.ref,
    required this.name,
    required this.url,
  });
}

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<UserPic>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls.asMap().map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      final file = UserPic(ref: ref, name: name, url: url);
      return MapEntry(index, file);
    }).values.toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }
}

class UserTransactionData{
  final bank;
  final date;
  final debited;
  final credited;
  final place;
  final time;
  String category;
  final smsID;

  UserTransactionData({
    required this.bank,
    required this.date,
    required this.debited,
    required this.credited,
    required this.place,
    required this.time,
    required this.category,
    required this.smsID,
});

  static UserTransactionData fromJson(Map<String, dynamic>doc) => UserTransactionData(
      bank: doc["Bank"],
      date: doc["Date"],
      debited: doc["Debited"],
      credited: doc["Credited"],
      place: doc["Place"],
      time: doc["time"],
      category: doc["Category"],
      smsID : doc["smsID"],
  );
}