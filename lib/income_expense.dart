import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';


class Income_expense extends StatelessWidget {
  final bool outerborder;
  final String text;
  Income_expense(this.outerborder, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: outerborder ? Border.all(
          color: primarycolor,
          width: 2,
        ): Border.all(
          color:  Color.fromARGB(255, 161, 161, 161).withOpacity(0.5),
          width: 2,
      ),),
      child: Container(
        child: Center(child: Text(text, style: TextStyle(fontSize: 16),)),
        height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.4,
      ),
    );
  }
}