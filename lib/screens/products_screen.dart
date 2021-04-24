import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/providers/products.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';

import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: context.read<Products>().productsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return (Center(child: CircularProgressIndicator()));
        }

        List<Product> products = snapshot.data;

        final columns = [
          DataColumn(
            label: Text('ID'),
          ),
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Cost'),
          ),
          DataColumn(
            label: Text('Price'),
          ),
        ];

        final rows = products
            .map(
              (product) => DataRow(
                cells: [
                  DataCell(
                    Text(product.id),
                  ),
                  DataCell(
                    Text(product.name),
                  ),
                  DataCell(
                    Text(product.cost.toStringAsFixed(2)),
                  ),
                  DataCell(
                    Text(product.cost.toStringAsFixed(2)),
                  ),
                ],
              ),
            )
            .toList();

        return CustomDataTable(
          title: 'Products',
          columns: columns,
          rows: rows,
        );
      },
    );
  }
}
