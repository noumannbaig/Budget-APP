import 'package:budget_app/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:budget_app/Database/Database.dart';
import 'package:intl/intl.dart';

import '../drawer.dart';


class History extends StatefulWidget {
  UserData userData;
  List<UserTransactionData> allTransaction;
  bool showAppBar;
  History({Key? key, required this.userData, required this.allTransaction, required this.showAppBar}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final List<SalesData> chartData = [];
  int selected = 0;
  TooltipBehavior? _tooltipBehavior;
  double totalIncome = 0;
  double totalExpense = 0;
  bool flag = false;
  static const monthList = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];


  @override
  initState(){
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    selected = (DateTime.now().month)-1;
    getGraphData(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
      ? AppBar(
        elevation: 0,
        title: Text("history".tr, style: TextStyle(color: Colors.white),),
        backgroundColor: primarycolor,
      )
      : null,
      drawer: widget.showAppBar ? Drawerr(allTransaction: widget.allTransaction, userData: widget.userData,) : null,
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index){
                      return month(index);
                    }
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 2,
                      color: Colors.grey.shade500
                    )
                  ]
                ),
                child: SfCartesianChart(
                  title: ChartTitle(text: "m_e_a".tr,),
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                  primaryYAxis: NumericAxis(labelFormat: "{value}\n KWD"),
                  series: <LineSeries>[
                    LineSeries<SalesData, int>(
                      dataSource: chartData,
                      xValueMapper: (SalesData sales, _) => sales.day,
                      yValueMapper: (SalesData sales, _) => sales.transaction,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      color: primarycolor
                    )
                  ]
                ),
              ),
              const SizedBox(height: 18,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 2,
                            color: Colors.grey.shade300
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.upload_sharp,size: 60, color: Colors.green,),
                          const SizedBox(height: 22,),
                           Text(
                            "income".tr,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 14,),
                          Text(
                            "$totalIncome",
                            style: TextStyle(color: Colors.green.shade200, fontSize: 20, fontFamily: "Righteous"),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 2,
                              color: Colors.grey.shade300
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.download_sharp,size: 60, color: Colors.red,),
                          const SizedBox(height: 22,),
                           Text(
                            "expense".tr,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 14,),
                          Text(
                            "$totalExpense",
                            style: TextStyle(color: Colors.red.shade200, fontSize: 20, fontFamily: "Righteous"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children:  [
                    Text("category".tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    const Spacer(),
                    Text("_amount".tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    const Spacer(),
                    Text("_date".tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  color: Colors.black,
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(height: 15,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: widget.allTransaction.isEmpty
                      ?  Center(child: Text("nty".tr),)
                      : (flag
                      ? Center(child: Text("n_t_t_m".tr),)
                      :  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.allTransaction.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return showTransaction(widget.allTransaction[index], context, index);
                    },
                  )
                  )
              )
            ],
          )
      ),
    );
  }

  Widget showTransaction(UserTransactionData data, BuildContext context, int index){
    bool income = false;
    if(data.debited == "0"){
      income = false;
    }else{
      income = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 36,
        color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              data.category == "" ? "unassigned".tr : data.category.tr,
              style: TextStyle(fontSize: 15, color: data.category == "" ? Colors.amber : Colors.black),
            ),
            const Spacer(),
            Text(
              income ? data.debited : data.credited,
              style: TextStyle(fontSize: 15, color: income ? Colors.red : Colors.green),
              textAlign: TextAlign.end,
            ),
            Padding(
              padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.1)),
              child: Text(
                "${data.date}",
                style: const TextStyle(fontSize: 15, color: Colors.black,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void getGraphData(int x){
    var regEXP = RegExp('(0.((0[1-9]{1})|([1-9]{1}([0-9]{1})?)))|(([1-9]+[0-9]*)(.([0-9]{1,2}))?)');

    for(int i = 0; i < widget.allTransaction.length; i++){

      var date = DateFormat('dd/MM/yyyy').parse(widget.allTransaction[i].date);
      var mon = date.month;
      var day = date.day;
      double amount = 0;
      double credit = 0;
      double debited = 0;

      for(int j = 0; j < widget.allTransaction[i].debited.length; j++){
        Iterable<Match> matches = regEXP.allMatches(widget.allTransaction[i].debited, j);
        for (final Match m in matches) {
          debited = double.parse(m[0]!);
        }
        break;
      }
      for(int k = 0; k < widget.allTransaction[i].credited.length; k++){
        Iterable<Match> matches = regEXP.allMatches(widget.allTransaction[i].credited, k);
        for (final Match m in matches) {
          credit = double.parse(m[0]!);
        }
        break;
      }
      amount = credit + debited;

      if(monthList[mon] ==  monthList[x+1]) {
        chartData.add(SalesData(day: day, transaction: amount));
        totalExpense = totalExpense + debited;
        totalIncome = totalIncome + credit;
      }
    }

    if(chartData.isEmpty) {
      flag = true;
    }else{
      flag = false;
    }

    //Sorting chartData List according to days
    chartData.sort((a, b) => a.day.compareTo(b.day));
  }

  Widget month(int index){
    return InkWell(
      onTap: (){
        setState(() {
          selected = index;
          chartData.clear();
          totalIncome = 0;
          totalExpense = 0;
          getGraphData(selected);
        });
      },
      child: Container(
        width: 50,
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          color: selected == index ? primarycolor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        
        child: Column(
          
          children: [
            Text(
              "${DateTime.now().year}",
              style: TextStyle(
                color: selected == index ? Colors.grey.shade300 : Colors.grey,
                fontSize: 11
              ),
            ),
            SizedBox(height: 5,),
            Text(
              monthList[index],
              style: TextStyle(
                color: selected == index ? Colors.white : Colors.black,
                fontSize: 18
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData({required this.day, required this.transaction});
  int day;
  double transaction;
}