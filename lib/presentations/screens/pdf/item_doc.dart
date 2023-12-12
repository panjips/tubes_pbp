import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:tubes_pbp/presentations/screens/pdf/custom_row.dart';

pw.Widget itemColumn(List<CustomRow> elements) {
  final List<pw.TableRow> rows = [];
  final List<PdfColor> rowColors = [PdfColors.white, PdfColors.blue50];

  for (var i = 0; i < elements.length; i++) {
    final CustomRow element = elements[i];
    final PdfColor rowColor = rowColors[i % rowColors.length];

    rows.add(
      pw.TableRow(
        children: [
          pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(5),
            color: rowColor,
            child: pw.Text(element.itemName),
          ),
          pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(5),
            color: rowColor,
            child: pw.Text(element.itemPrice),
          ),
          pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(5),
            color: rowColor,
            child: pw.Text(element.amount),
          ),
          pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(5),
            color: rowColor,
            child: pw.Text(element.subTotalProduct),
          ),
        ],
      ),
    );
  }

  return pw.Table(children: rows);
}
