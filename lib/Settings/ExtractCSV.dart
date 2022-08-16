import 'dart:io';

import 'package:budget_app/Database/Database.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelApi{

  static Future create_xlsx({required UserData, required List<UserTransactionData> smsData}) async{

    Workbook workbook = Workbook();
// Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText("ID");
    sheet.getRangeByName('B1').setText("Category");
    sheet.getRangeByName('C1').setText("Bank");
    sheet.getRangeByName('D1').setText("Place");
    sheet.getRangeByName('E1').setText("Date");
    sheet.getRangeByName('F1').setText("Time");
    sheet.getRangeByName('G1').setText("Credited");
    sheet.getRangeByName('H1').setText("Debited");

    for (var i = 0; i < smsData.length; i++) {
      sheet.getRangeByName('A${i + 2}').setText(smsData[i].smsID);
      sheet.getRangeByName('B${i + 2}').setText(smsData[i].category);
      sheet.getRangeByName('C${i + 2}').setText(smsData[i].bank);
      sheet.getRangeByName('D${i + 2}').setText(smsData[i].place);
      sheet.getRangeByName('E${i + 2}').setText(smsData[i].date);
      sheet.getRangeByName('F${i + 2}').setText(smsData[i].time);
      sheet.getRangeByName('G${i + 2}').setText(smsData[i].credited);
      sheet.getRangeByName('H${i + 2}').setText(smsData[i].debited);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationDocumentsDirectory()).path;
    final String filename = '$path/smsData.xlsx';
    final File file = File(filename);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }

}