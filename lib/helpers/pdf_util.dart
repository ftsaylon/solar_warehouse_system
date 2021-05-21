import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:http/http.dart' as http;

class PDFUtil {
  Future<Uint8List> createFile(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final data = response.bodyBytes;
    return data;
  }

  Future<pw.Document> createQuotePDF(Quotation quotation) async {
    final pdf = pw.Document();
    final quoteItems = quotation.quoteItems;

    final rows = quoteItems.values
        .map((quoteItem) => pw.TableRow(children: [
              pw.Text(quoteItem.name),
              pw.Text(quoteItem.quantity.toString()),
              pw.Text(quoteItem.rate.toStringAsFixed(2)),
              pw.Text(quoteItem.tax.toStringAsFixed(2)),
              pw.Text(quoteItem.subTotal.toStringAsFixed(2)),
            ]))
        .toList();

    List<Uint8List> imagesData = [];

    for (var i = 0; i < quotation.images.length; i++) {
      final newImageData = await createFile(quotation.images[i]);
      imagesData.add(newImageData);
    }

    final images = imagesData.map((imageData) {
      final _image = pw.MemoryImage(imageData);
      return pw.Image(_image);
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(quotation.title),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: <pw.TableRow>[...rows],
                ),
                ...images,
              ],
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  void openPDF(pw.Document pdf) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
  }

  void downloadPDF(pw.Document pdf) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = 'some_name.pdf';
    html.document.body?.children?.add(anchor);
    anchor.click();
    html.document.body?.children?.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
