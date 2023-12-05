import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/data/model/ticket.dart';
import 'package:test_slicing/data/model/user.dart';
import 'package:test_slicing/data/repository/auth_repository.dart';
import 'package:test_slicing/data/repository/destinasi_respository.dart';
import 'package:test_slicing/data/repository/ticket_repository.dart';
import 'package:test_slicing/presentations/screens/pdf/custom_row.dart';
import 'package:test_slicing/presentations/screens/pdf/item_doc.dart';
import 'package:test_slicing/presentations/screens/pdf/pdf_preview.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<void> createPdf(
  BuildContext context,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? idPengguna = prefs.getString('id_user');
  String? idTicket = prefs.getString('id_ticket');

  Ticket dataTicket = await TicketRepository().findTicketApi(idTicket!);

  User? dataUser = await AuthRepository().showProfile(idPengguna!);

  Destinasi? dataDestinasi =
      await DestinasiRepositroy().getDestinasiFromApi(dataTicket.idDestinasi!);

  final imageBytes = await fileFromImageUrl(
      dataUser.urlPhoto ??
          "https://firebasestorage.googleapis.com/v0/b/final-project-pbp.appspot.com/o/avatar-icon.png?alt=media&token=9927b326-a030-4ee1-97cc-eb66165ec05a&_gl=1*eidyur*_ga*MTYzNTI5NjU5LjE2OTU5MDYwOTI.*_ga_CW55HF8NVT*MTY5OTE5MTU5Ny4zMy4xLjE2OTkxOTE3MTUuOC4wLjA.",
      dataTicket.idTicket!);

  pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
    return pw.MemoryImage(imageBytes);
  }

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

  final List<CustomRow> elements = [
    CustomRow('Item Name', "Item Price", "Amount", "Total Payment"),
    CustomRow("Ticket ${dataDestinasi.nama}", dataDestinasi.hargaTiketMasuk!,
        dataTicket.jumlahTicket!, dataTicket.totalHarga!),
  ];

  pw.Widget table = itemColumn(elements);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF();
      },
      build: (pw.Context context) {
        return [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 24),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Identitas Diri ",
                          style: const pw.TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        pw.Container(
                          margin: const pw.EdgeInsets.only(top: 4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              valueDataDiri(
                                  "${dataUser.firstName} ${dataUser.lastName}")
                            ],
                          ),
                        ),
                        pw.Container(
                          margin: const pw.EdgeInsets.only(top: 4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [valueDataDiri(dataUser.username)],
                          ),
                        ),
                        pw.Container(
                          margin: const pw.EdgeInsets.only(top: 4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [valueDataDiri(dataUser.email)],
                          ),
                        ),
                      ],
                    ),
                  ),
                  imageFormInput(pdfImageProvider, imageBytes),
                ],
              ),
              pw.SizedBox(height: 30),
              table,
              pw.SizedBox(height: 60),
              pw.Text('Scan this qr code to enterance gate'),
              barcodeKotak(idTicket),
              pw.Text(idTicket),
              pw.SizedBox(height: 30),
              greetingThanks(),
            ],
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
          color: PdfColor.fromHex('#FFDB59'),
          child: footerPDF(dataTicket.tanggalTicket!),
        );
      },
    ),
  );

  // ignore: use_build_context_synchronously
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
      style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue),
    ),
  );
}

pw.Padding imageFormInput(
    pw.ImageProvider Function(Uint8List imageBytes) pdfImageProvider,
    Uint8List image) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: pw.FittedBox(
      child: pw.Image(pdfImageProvider(image), width: 64),
      fit: pw.BoxFit.fitHeight,
      alignment: pw.Alignment.center,
    ),
  );
}

Future<Uint8List> fileFromImageUrl(String imgUrl, String idTicket) async {
  final response = await http.get(Uri.parse(imgUrl));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final file = File(p.join(documentDirectory.path, '$idTicket.jpg'));
  file.writeAsBytesSync(response.bodyBytes);

  return file.readAsBytesSync();
}

pw.Padding greetingThanks() {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Column(
      children: [
        pw.Text(
            'Dear Customern, thank you trust our service, we hope u enjoy your holiday.'),
        pw.SizedBox(height: 30),
        pw.Text('King regards'),
        pw.SizedBox(height: 30),
        pw.Text('Jogja Vacation'),
      ],
    ),
  );
}

pw.Padding barcodeKotak(String id) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    child: pw.Center(
      child: pw.BarcodeWidget(
        barcode:
            pw.Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high),
        data: id,
        width: 128,
        height: 128,
      ),
    ),
  );
}

pw.Text valueDataDiri(String text) {
  return pw.Text(
    text,
    style: const pw.TextStyle(
      fontSize: 12,
    ),
  );
}
