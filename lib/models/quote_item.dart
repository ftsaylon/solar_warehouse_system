import 'package:solar_warehouse_system/models/product.dart';

class QuoteItem {
  final String id;
  final Product product;
  final int quantity;
  final double rate;
  final double tax;

  QuoteItem({
    this.id,
    this.product,
    this.quantity,
    this.rate,
    this.tax,
  });
}
