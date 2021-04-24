import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/services/product_service.dart';

class Products extends ChangeNotifier {
  final _productsService = GetIt.I<ProductService>();

  Stream<List<Product>> productsStream() {
    return _productsService.fetchQuotations();
  }
}
