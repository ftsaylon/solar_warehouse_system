import 'dart:html' as html;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:solar_warehouse_system/models/job_order.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class PDFUtil {
  Future<Uint8List> createFile(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final data = response.bodyBytes;
    return data;
  }

  Future<pw.Document> createJobOrderPDF(JobOrder jobOrder) async {
    final pdf = pw.Document();
    final jobOrderItems = jobOrder.jobOrderItems;

    final rows = jobOrderItems.values
        .map(
          (quoteItem) => pw.TableRow(
            children: [
              pw.Text(quoteItem.name),
              pw.Text(quoteItem.quantity.toString()),
            ],
          ),
        )
        .toList();

    List<Uint8List> imagesData = [];

    for (var i = 0; i < jobOrder.images.length; i++) {
      final newImageData = await createFile(jobOrder.images[i]);
      imagesData.add(newImageData);
    }

    final images = imagesData.map((imageData) {
      final _image = pw.MemoryImage(imageData);
      return pw.Image(_image);
    }).toList();

    final ByteData logoData = await rootBundle.load('assets/Solar_Logo.png');
    final Uint8List logoList = logoData.buffer.asUint8List();

    final logo = pw.MemoryImage(logoList);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                createHeader(logo),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text(
                      'JOB ORDER: ',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromHex('#21A9E0'),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      jobOrder.title,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Customer:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Address:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Contact Number:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Email Address:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 16),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${jobOrder.customer.name}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${jobOrder.customer.address}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${jobOrder.customer.contactNumber}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${jobOrder.customer.emailAddress}'),
                        pw.SizedBox(height: 2),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Table(
                  children: <pw.TableRow>[
                    pw.TableRow(
                      children: [
                        pw.Text(
                          'Item',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Quantity',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ...rows
                  ],
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

  Future<pw.Document> createQuotePDF(Quotation quotation) async {
    final pdf = pw.Document();
    final quoteItems = quotation.quoteItems;

    final rows = quoteItems.values
        .map(
          (quoteItem) => pw.TableRow(
            children: [
              pw.Text(quoteItem.name),
              pw.Text(quoteItem.quantity.toString()),
              pw.Text(quoteItem.rate.toStringAsFixed(2)),
              pw.Text(quoteItem.tax.toStringAsFixed(2)),
              pw.Text(quoteItem.subTotal.toStringAsFixed(2)),
            ],
          ),
        )
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

    final ByteData logoData = await rootBundle.load('assets/Solar_Logo.png');
    final Uint8List logoList = logoData.buffer.asUint8List();

    final logo = pw.MemoryImage(logoList);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                createHeader(logo),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text(
                      'QUOTATION: ',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromHex('#21A9E0'),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      quotation.title,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Customer:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Address:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Contact Number:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Email Address:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Total:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 16),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${quotation.customer.name}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${quotation.customer.address}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${quotation.customer.contactNumber}'),
                        pw.SizedBox(height: 2),
                        pw.Text('${quotation.customer.emailAddress}'),
                        pw.SizedBox(height: 2),
                        pw.Text('PHP ${quotation.total}'),
                        pw.SizedBox(height: 2),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Table(
                  children: <pw.TableRow>[
                    pw.TableRow(
                      children: [
                        pw.Text(
                          'Item',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Quantity',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Rate',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Tax',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Subtotal',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ...rows
                  ],
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

  Future<String> openPDF(pw.Document pdf) async {
    try {
      final bytes = await pdf.save();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
      return '${pdf.document.documentID}';
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<String> downloadPDF(pw.Document pdf) async {
    try {
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
      return '${pdf.document.documentID}';
    } catch (e) {
      print(e);
      return e;
    }
  }

  pw.Row createHeader(pw.MemoryImage logo) {
    return pw.Row(
      children: [
        pw.Image(logo, width: 120, height: 120),
        pw.SizedBox(width: 16),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'SOLAR INNOVATION ADS CORPORATION',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '6915 M Emilio Aguinaldo Highway, Panapaan IV, District 1',
              style: pw.TextStyle(
                fontSize: 11,
              ),
            ),
            pw.Text(
              'Bacoor City, Cavite 4102',
              style: pw.TextStyle(
                fontSize: 11,
              ),
            ),
            pw.Text(
              '(046) 519-7614',
              style: pw.TextStyle(
                fontSize: 11,
              ),
            ),
            pw.Text(
              'info@solarads.com.ph',
              style: pw.TextStyle(
                fontSize: 11,
              ),
            ),
            pw.Text(
              'solarads.com.ph',
              style: pw.TextStyle(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
