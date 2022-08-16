import 'package:budget_app/Database/Database.dart';
import 'package:intl/intl.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';
class SavingSMS{
  final DataBase _db = DataBase();
  Future<void> savedSMS(String name, String sms) async {
    // String sms = "Your account HBL A/C 0128*****40103 has been debited with PKR 20,000.00 from STARBUCKS on 14/06/2022 13:39:49 for ATM Cash Withdrawal. Remaining balance is PKR 119,950.38.";

    // String sms = "Your account HBL A/C 0128*****40103 has been credited with PKR 20,000.00 from STARBUCKS on 14/06/2022 13:39:49 for Salary. Remaining balance is PKR 119,950.38.";

    // String sms = "You Purchased USD 9.99 at UDEMY ONLINE COURSES in UNITED STATES on card XX939. Your Balance is KWD 5.048";

    // String sms = "Your account 1234 has been debited with KWD 9.145 from HEALTH BOTEGES PHARMAC, ALARDIYAH on 2022-06-14 10:09:53.";

    // String sms = "Your account 1234 has been debited with KWD 5.000 from KNPC 98 , SOUTH SURRA on 2022-06-18 20:29:58 . Your remaining balance is KWD 278.737";

    // String sms = "Your account 1234 has been credited with KWD 5.000 from KNPC 98 , SOUTH SURRA on 2022-06-18 20:29:58 . Your remaining balance is KWD 278.737";

    // String sms = "Your account 1234 has been debited with KWD 10.000 on 2022-06-18 20:29:58 . Your remaining balance is KWD 78.737.";

    // String sms = "Your account 1234 has been credited with KWD 10.000 on 2022-06-18 20:29:58 . Your remaining balance is KWD 78.737.";

    // String sms = "Your credit card 1234 has been debited with KWD 7.145 from TURKISH AIRLINES on 2022-06-14 10:09:53. The available limit of your credit card is 214.375 KWD";

    // String sms = "Your account 7448 has been credited with KWD 500.000 for telex transfer on 2022-07-04 23:55:43 . Your remaining balance is KWD 1,208.570";

    // String sms = "Your account 3384 has been debited with KWD 50.000 for telex transfer on 2022-07-03 11:12:59 . Your remaining balance is KWD 901.270";

    // / String sms = "Dear customer, your account 35XXX034  has been debited for KD 100.000 POS Purchase. Available balance is KD940.000";

    // String sms = "POS payment - Debited by KWD 1.400 Account xx939 Your Balance is KWD 36.400.";

    // / String sms = "Your card xxxx1234 is debited by KWD 4.500 on 23/09/2020 10:36 by MICROSOFT*STORE. Avail. balance is KD 155.400 For help 1805805";

    // / String sms = "Your card xxxx1234 is credited by KWD 4.500 on 23/09/2020 10:36 by MICROSOFT*STORE. Avail. balance is KD 155.400 For help 1805805";

    String date = "";
    String time = "";
    String debited = "0";
    String credited = "0";
    String place = "";
    String bank = "";
    String category = "";

    List<String> keywordList = ["debited", "purchased", "credited"];

    const debitedStartWith = "debited with ";
    const debitedStartFor = "debited for ";
    const debitedStartBy = "debited by ";
    const debitedEndFrom = " from";
    const debitedEndOn = " on";
    const debitedEndFor = " for";

    const creditedStartWith = "credited with ";
    const creditedStartFor = "credited for ";
    const creditedStartBy = "credited by ";
    const creditedEndFrom = " from";
    const creditedEndOn = " on";
    const creditedEndFor = " for";

    const purchaseStart = "purchased ";
    const purchaseEnd = " at";

    const placeStart = "from ";
    const placeEnd = " on";

    const bankStart = "your account ";
    const bankEnd = " ";

    print("Starting Program");

    var dateRegExp = RegExp(
        r'(0[1-9]|[12][0-9]|3[01])[(-|\/| )](0[1-9]|1[012])[(-|\/| )](19|20)\d\d');
    var timeRegExp = RegExp(r'([01]2?\d|2[0-3])(:|-)([0-5]?\d)(:|-)([0-5]?\d)');

    for (int i = 0; i < sms.length; i++) {
      Iterable<Match> matches = dateRegExp.allMatches(sms, i);
      for (final Match m in matches) {
        date = m[0]!;
      }
      break;
    }
    for (int i = 0; i < sms.length; i++) {
      Iterable<Match> matches = timeRegExp.allMatches(sms, i);
      for (final Match m in matches) {
        time = m[0]!;
      }
      break;
    }

    if (date == "" || time == "") {
      DateTime nowTime = DateTime.now();
      date = DateFormat('dd/MM/yyyy').format(nowTime);
      time = "${nowTime.hour}:${nowTime.minute}:${nowTime.second}";
    }
    String id = "${date.replaceAll(RegExp('[^0-9]'), '')}_$time";

    if (sms.toLowerCase().contains("debited")) {
      int length = 0;
      int endDIndex = 0;
      int startDIndex = 0;
      if(sms.toLowerCase().contains(debitedStartWith)){
        startDIndex = sms.toLowerCase().indexOf(debitedStartWith);
        length = debitedStartWith.length;
      }if (sms.toLowerCase().contains(debitedStartFor)) {
        startDIndex = sms.toLowerCase().indexOf(debitedStartFor);
        length = debitedStartFor.length;
      }if (sms.toLowerCase().contains(debitedStartBy)) {
        startDIndex = sms.toLowerCase().indexOf(debitedStartBy);
        length = debitedStartBy.length;
      }

      if(sms.toLowerCase().contains(debitedEndFrom)){
        endDIndex = sms.toLowerCase().indexOf(debitedEndFrom, startDIndex + length);
      }else if (sms.toLowerCase().contains(debitedEndFor)) {
        endDIndex = sms.toLowerCase().indexOf(debitedEndFor, startDIndex + length);
      }else if (sms.toLowerCase().contains(debitedEndOn)) {
        endDIndex = sms.toLowerCase().indexOf(debitedEndOn, startDIndex + length);
      }else if(!(sms.toLowerCase().contains(debitedEndFrom)) || !(sms.toLowerCase().contains(debitedEndFor) || !(sms.toLowerCase().contains(debitedEndOn)))){
        endDIndex = sms.toLowerCase().indexOf(".", startDIndex + length);
      }

      debited = "-${sms.substring(startDIndex + length, endDIndex)}";
      debited = debited.replaceAll(',', '');

    } else if (sms.toLowerCase().contains("credited")) {
      int length = 0;
      int endCIndex = 0;
      int startCIndex = 0;
      if(sms.toLowerCase().contains(creditedStartWith)){
        startCIndex = sms.toLowerCase().indexOf(creditedStartWith);
        length = creditedStartWith.length;
      }if (sms.toLowerCase().contains(creditedStartFor)) {
        startCIndex = sms.toLowerCase().indexOf(creditedStartFor);
        length = creditedStartFor.length;
      }if (sms.toLowerCase().contains(creditedStartBy)) {
        startCIndex = sms.toLowerCase().indexOf(creditedStartBy);
        length = creditedStartBy.length;
      }

      if(sms.toLowerCase().contains(creditedEndFrom)){
        endCIndex = sms.toLowerCase().indexOf(creditedEndFrom, startCIndex + length);
      }else if (sms.toLowerCase().contains(creditedEndFor)){
        endCIndex = sms.toLowerCase().indexOf(creditedEndFor, startCIndex + length);
      }else if (sms.toLowerCase().contains(creditedEndOn)) {
        endCIndex = sms.toLowerCase().indexOf(creditedEndOn, startCIndex + length);
      }else{
        endCIndex = sms.toLowerCase().indexOf(".", startCIndex + length);
      }

      credited = "+${sms.substring(startCIndex + length, endCIndex)}";
      credited = credited.replaceAll(',', '');

    } else if (sms.toLowerCase().contains("purchased")) {
      int endPIndex = 0;
      int startPIndex = sms.toLowerCase().indexOf(purchaseStart);

      endPIndex = sms.toLowerCase().indexOf(purchaseEnd, startPIndex + purchaseStart.length);

      debited = "-${sms.substring(startPIndex + purchaseStart.length, endPIndex)}";
      debited = debited.replaceAll(',', '');

//     debited = debited.replaceAll(RegExp('[^0-9]'), '');

//       var usdConvert = await MoneyConverter.convert(Currency(Currency.USD, amount: double.parse(debited)), Currency(Currency.KWD));
//       debited = usdConvert.toString();
    }

    int startRIndex = sms.toLowerCase().indexOf(placeStart);
    int endRIndex = sms.toLowerCase().indexOf(placeEnd, startRIndex + placeStart.length);
    if(endRIndex == -1){
      endRIndex = sms.toLowerCase().indexOf(" ", startRIndex + placeStart.length);
    }

    place = sms.substring(startRIndex + placeStart.length, endRIndex);

    final startAIndex = sms.toLowerCase().indexOf(bankStart);
    final endAIndex = sms.toLowerCase().indexOf(bankEnd, startAIndex + bankStart.length);

    bank = sms.substring(startAIndex + bankStart.length, endAIndex);

    for (int i = 0; i < 3; i++) {
      if (sms.toLowerCase().contains(keywordList[i])) {
        print("Date: $date");
        print("Time: $time");
        print("ID: $id");
        print("Debited: $debited");
        print("Credited: $credited");
        print("Place: $place");
        print("Bank: $bank");
        print("Category: $category");
        print("\nSuccess!");
        _db.saveSMSInformation(id, name, bank, date, debited, credited, place, time, category);
        break;
      } else {
        print("\nLost!");
      }
    }
  }
}