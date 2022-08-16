import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colours.dart';

class ShowEmail extends StatefulWidget {
  String email;
  ShowEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<ShowEmail> createState() => _ShowEmailState();
}

class _ShowEmailState extends State<ShowEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Your email address",
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
                  widget.email,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 18,),
            Center(
              child: Text(
                "You can not change your email address",
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            )
          ],
        ),
      ),
    );
  }
}
