import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solar_warehouse_system/helpers/currency_util.dart';
import 'package:solar_warehouse_system/helpers/pdf_util.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';
import 'quote_items_table.dart';

class QuotationDetail extends StatefulWidget {
  final Quotation quotation;

  const QuotationDetail({this.quotation, Key key}) : super(key: key);

  @override
  _QuotationDetailState createState() => _QuotationDetailState();
}

class _QuotationDetailState extends State<QuotationDetail> {
  final _scrollController = ScrollController();
  final _pdfUtil = PDFUtil();

  bool _isLoading = false;

  void _createPDF() async {
    setState(() {
      _isLoading = true;
    });
    final pdf = await _pdfUtil.createQuotePDF(widget.quotation);
    setState(() {
      _isLoading = false;
    });
    await _pdfUtil.openPDF(pdf);
  }

  void _downloadPDF() async {
    setState(() {
      _isLoading = true;
    });
    final pdf = await _pdfUtil.createQuotePDF(widget.quotation);
    await _pdfUtil.downloadPDF(pdf);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormDialog(
      title: 'Quote: ${widget.quotation.title}',
      children: _isLoading
          ? [
              Center(
                child: Text('Loading...'),
              ),
            ]
          : [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Address:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Contact Number:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Email Address:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date Created:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Expiration Date:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.quotation.customer.name}'),
                      SizedBox(height: 4),
                      Text('${widget.quotation.customer.address}'),
                      SizedBox(height: 4),
                      Text('${widget.quotation.customer.contactNumber}'),
                      SizedBox(height: 4),
                      Text('${widget.quotation.customer.emailAddress}'),
                      SizedBox(height: 4),
                      Text('PHP ${moneyFormat.format(widget.quotation.total)}'),
                      SizedBox(height: 4),
                      Text(
                          '${DateFormat.yMd().format(widget.quotation.dateCreated)}'),
                      SizedBox(height: 4),
                      Text(
                          '${DateFormat.yMd().format(widget.quotation.dateOfExpiration)}'),
                      SizedBox(height: 4),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _createPDF,
                        child: Text('Create PDF'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _downloadPDF,
                        child: Text('Download PDF'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildQuoteItems(context),
              _buildImages([
                ...widget.quotation.images.map((image) => _buildImage(image)),
              ]),
            ],
    );
  }

  Widget _buildQuoteItems(BuildContext context) {
    return QuoteItemsTable(
      quoteItems: widget.quotation.quoteItems,
      isViewing: true,
    );
  }

  _buildImage(String imageUrl) {
    return Card(
        child: AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    ));
  }

  Widget _buildImages(List<Widget> images) {
    return images.isNotEmpty
        ? Container(
            width: 600,
            height: 300,
            alignment: Alignment.center,
            child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return images[index];
              },
            ),
          )
        : Container();
  }
}
