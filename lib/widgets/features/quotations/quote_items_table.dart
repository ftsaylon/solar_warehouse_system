import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';
import 'package:solar_warehouse_system/widgets/common/delete_dialog.dart';
import 'package:solar_warehouse_system/widgets/features/products/product_form.dart';
import 'package:solar_warehouse_system/widgets/features/quotations/quote_item_form.dart';
import 'package:provider/provider.dart';

class QuoteItemsTable extends StatelessWidget {
  final Map<String, QuoteItem> quoteItems;
  final bool isViewing;

  const QuoteItemsTable({
    @required this.quoteItems,
    @required this.isViewing,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = [
      DataColumn(
        label: Text('Name'),
      ),
      DataColumn(
        label: Text('Quantity'),
      ),
      DataColumn(
        label: Text('Rate'),
      ),
      DataColumn(
        label: Text('Tax'),
      ),
      DataColumn(
        label: Text('SubTotal'),
      ),
      if (!isViewing)
        DataColumn(
          label: Text('Actions'),
        ),
    ];
    final rows = quoteItems.values
        .map((quoteItem) => DataRow(cells: [
              DataCell(
                Text(quoteItem.name),
              ),
              DataCell(
                Text(quoteItem.quantity.toString()),
              ),
              DataCell(
                Text(quoteItem.rate.toStringAsFixed(2)),
              ),
              DataCell(
                Text(quoteItem.tax.toStringAsFixed(2)),
              ),
              DataCell(
                Text(quoteItem.subTotal.toStringAsFixed(2)),
              ),
              if (!isViewing)
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title:
                                'Are you sure you want to delete ${quoteItem.name}?',
                            confirm: () async {
                              context
                                  .read<QuoteItems>()
                                  .deleteQuoteItem(quoteItem);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ]))
        .toList();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isViewing)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Quote Items'),
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => QuoteItemForm(),
                  ),
                  child: Text('Add Quote Item'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => ProductForm(),
                  ),
                  child: Text('Create New Product'),
                ),
              ],
            ),
          DataTable(
            headingTextStyle: Theme.of(context).textTheme.subtitle1,
            headingRowColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withOpacity(0.08)),
            columns: columns,
            rows: rows,
          ),
        ],
      ),
    );
  }
}
