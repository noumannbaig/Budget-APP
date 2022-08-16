import 'dart:io';

import 'package:budget_app/Database/Database.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfAPI{

  static Future<File> generatePdf
      ({required UserData userData, required List<UserTransactionData> smsData}) async{
    final document = PdfDocument();

    final page = document.pages.add();

    

    createPdf(userData, smsData, page);

    return saveFile(document);
  }

  static void createPdf(UserData userData, List<UserTransactionData> smsData, PdfPage page){
    final pageSize = page.getClientSize();

    final data = '''Name: ${userData.name}    email: ${userData.email}''';
    
    page.graphics.drawString(
      data,
      PdfStandardFont(PdfFontFamily.helvetica, 22),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      bounds: const Rect.fromLTRB(30, 50, 0, 0)
    );

    final grid = PdfGrid();
    grid.columns.add(count: 8);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = "ID";
    headerRow.cells[1].value = "Category";
    headerRow.cells[2].value = "Bank";
    headerRow.cells[3].value = "Place";
    headerRow.cells[4].value = "Date";
    headerRow.cells[5].value = "Time";
    headerRow.cells[6].value = "Credited";
    headerRow.cells[7].value = "Debited";

    headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    for(int i = 0; i < smsData.length; i++){
      final row = grid.rows.add();
      row.cells[0].value = smsData[i].smsID;
      row.cells[1].value = smsData[i].category;
      row.cells[2].value = smsData[i].bank;
      row.cells[3].value = smsData[i].place;
      row.cells[4].value = smsData[i].date;
      row.cells[5].value = smsData[i].time;
      row.cells[6].value = smsData[i].credited;
      row.cells[7].value = smsData[i].debited;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);

    for(int i = 0; i < headerRow.cells.count; i++){
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5,left: 5,top: 5, right: 5);
    }

    for(int i = 0; i < grid.rows.count; i++){
      final row = grid.rows[i];
      for(int j = 0; j < row.cells.count; j++){
        final cell = row.cells[j];

        cell.style.cellPadding = PdfPaddings(bottom: 5,left: 5,top: 5, right: 5);
      }
    }

    grid.draw(
      page: page,
      bounds: const Rect.fromLTRB(30, 100, 30, 0)
    )!;
  }

  static Future<File> saveFile(PdfDocument document) async{
    final path = await getApplicationDocumentsDirectory();
    final fileName = '${path.path}/smsData${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);
    
    file.writeAsBytes(document.save());
    document.dispose();

    return file;
  }

}