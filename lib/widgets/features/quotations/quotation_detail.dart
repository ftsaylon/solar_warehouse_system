import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';
import 'quote_items_table.dart';

class QuotationDetail extends StatelessWidget {
  final Quotation quotation;

  const QuotationDetail({this.quotation, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFormDialog(
      title: 'Quote: ${quotation.title}',
      children: [
        Row(
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
              ],
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${quotation.customer.name}'),
                SizedBox(height: 4),
                Text('${quotation.customer.address}'),
                SizedBox(height: 4),
                Text('${quotation.customer.contactNumber}'),
                SizedBox(height: 4),
                Text('${quotation.customer.emailAddress}'),
                SizedBox(height: 4),
                Text('PHP ${quotation.total}'),
                SizedBox(height: 4),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildQuoteItems(context),
      ],
    );
  }

  Widget _buildQuoteItems(BuildContext context) {
    return QuoteItemsTable(
      quoteItems: quotation.quoteItems,
      isViewing: true,
    );
  }
}
