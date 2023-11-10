import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_slicing/presentations/screens/pdf/custom_row.dart';
import 'package:test_slicing/presentations/screens/pdf/pdf_preview.dart';

Future<void> createPdf(
  BuildContext context,
) async {
  final doc = pw.Document();
  final pdfTheme = pw.PageTheme(
    buildBackground: (context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex("#FFBD59"),
            width: 1,
          ),
        ),
      );
    },
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF();
      },
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                ),
                
                barcodeGaris('12345')
              ],
            ),
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
          color: PdfColor.fromHex('#FFDB59'),
          child: footerPDF("2020-11-02"),
        );
      },
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: doc),
    ),
  );
}

pw.Header headerPDF() {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(colors: [
        PdfColor.fromHex('#FCDF8A'),
        PdfColor.fromHex('#F38381'),
      ], begin: pw.Alignment.topLeft, end: pw.Alignment.bottomRight),
    ),
    child: pw.Center(
      child: pw.Text(
        "Ticket",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
      ),
    ),
  );
}

pw.Center footerPDF(String formattedDate) {
  return pw.Center(
    child: pw.Text(
      'Created At $formattedDate',
      style: pw.TextStyle(fontSize: 10, color: PdfColors.blue),
    ),
  );
}

pw.Padding barcodeGaris(String id){
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: pw.Center(
      child: pw.BarcodeWidget(
        data: id,
        width: 200,
        height: 50,
        barcode: pw.Barcode.code128(escapes: true),
      ),
    )
  );
}