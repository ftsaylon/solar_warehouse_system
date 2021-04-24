import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/providers/products.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';

import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isInit;
  bool _isLoading;
  bool _isLoadingMore;

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;
    _isLoadingMore = false;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await context.read<Products>().fetchAndSetProducts();

      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    await context.read<Products>().fetchAndSetProducts();
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = context.watch<Products>().products;

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
                Text(product.price.toStringAsFixed(2)),
              ),
            ],
          ),
        )
        .toList();

    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : LazyLoadScrollView(
            isLoading: _isLoadingMore,
            onEndOfPage: _loadMore,
            child: CustomDataTable(
              title: 'Products',
              columns: columns,
              rows: rows,
              onCreateNew: () => context.read<Products>().addProduct(Product(
                    name: 'New Product',
                    cost: 100.0,
                    price: 200.0,
                  )),
            ),
          );
  }
}
