import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Quotation>>(
      stream: context.read<Quotations>().quotationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return (Center(child: CircularProgressIndicator()));
        }

        List<Quotation> quotations = snapshot.data;

        final columns = [
          DataColumn(
            label: Text('ID'),
          ),
          DataColumn(
            label: Text('Title'),
          ),
          DataColumn(
            label: Text('Customer'),
          ),
          DataColumn(
            label: Text('Total'),
          ),
        ];

        final rows = quotations
            .map(
              (quotation) => DataRow(
                cells: [
                  DataCell(
                    Text(quotation.id),
                  ),
                  DataCell(
                    Text(quotation.title),
                  ),
                  DataCell(
                    Text(quotation.customer.name),
                  ),
                  DataCell(
                    Text(quotation.total.toStringAsFixed(2)),
                  ),
                ],
              ),
            )
            .toList();

        return CustomDataTable(columns: columns, rows: rows);
      },
    );
  }
}
