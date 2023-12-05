import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;
  const PreviewScreen({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed("/nav"),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text("Preview"),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }
}
