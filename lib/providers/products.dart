import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/services/product_service.dart';

class Products extends ChangeNotifier {
  final _productsService = GetIt.I<ProductService>();

  List<Product> _products = [];

  List<Product> get products => [..._products];

  Stream<List<Product>> productsStream() {
    return _productsService.streamProducts();
  }

  Future<void> fetchAndSetProducts() async {
    final newProducts = (_products.isEmpty)
        ? await _productsService.fetchProducts()
        : await _productsService.fetchProducts(
            documentSnapshot: _products.last.documentSnapshot,
          );

    _products.addAll(newProducts);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProductDoc = await _productsService.addProduct(product);
    if (newProductDoc != null) {
      product = product.copyWith(
        id: newProductDoc.id,
        documentSnapshot: newProductDoc,
      );
      _products.insert(0, product);
      notifyListeners();
    }
  }
}
