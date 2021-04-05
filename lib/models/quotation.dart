import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';

import 'customer.dart';

class Quotation {
  final String id;
  final String title;
  final Customer customer;
  final double total;
  final List<QuoteItem> quoteItems;
  final List<String> images;

  Quotation({
    this.id,
    this.title,
    this.customer,
    this.total,
    this.quoteItems,
    this.images,
  });
}
