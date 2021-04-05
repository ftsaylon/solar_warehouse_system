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

  factory Quotation.fromJson(Map<dynamic, dynamic> json) => Quotation(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        // customer: json['customer'] ?? '',
        total: json['total']?.toDouble() ?? 0.0,
        images: json['images'] ?? [],
      );

  Quotation copyWith({
    String title,
    Customer customer,
    double total,
    List<QuoteItem> quoteItems,
    List<String> images,
  }) =>
      Quotation(
        title: title ?? this.title,
        customer: customer ?? this.customer,
        total: total ?? this.total,
        quoteItems: quoteItems ?? this.quoteItems,
        images: images ?? this.images,
      );
}
