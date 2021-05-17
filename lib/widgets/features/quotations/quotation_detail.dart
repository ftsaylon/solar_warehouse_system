import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';
import 'package:provider/provider.dart';
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
        _buildQuoteItems(context),
      ],
    );
  }

  Widget _buildQuoteItems(BuildContext context) {
    final quoteItems = context.watch<QuoteItems>().quoteItems;
    return QuoteItemsTable(quoteItems: quoteItems);
  }
}
