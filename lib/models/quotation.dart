import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';

import 'customer.dart';

class Quotation {
  final String id;
  final String title;
  final Customer customer;
  final double total;
  final List<QuoteItem> quoteItems;
  final List<String> images;
  final DocumentSnapshot documentSnapshot;

  Quotation({
    this.id,
    this.title,
    this.customer,
    this.total,
    this.quoteItems,
    this.images,
    this.documentSnapshot,
  });

  factory Quotation.fromJson(Map<dynamic, dynamic> json) => Quotation(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        customer: Customer.fromJson(json['customer'] ?? {}),
        total: json['total']?.toDouble() ?? 0.0,
        images: json['images'] ?? [],
      );

  factory Quotation.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    return Quotation(
      id: documentSnapshot.id,
      title: data['title'] ?? '',
      customer: Customer.fromJson(data['customer'] ?? {}),
      total: data['total']?.toDouble() ?? 0.0,
      images: data['images'] ?? [],
    );
  }

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

  factory Quotation.initial() => Quotation(
        id: null,
        title: '',
        customer: null,
        total: 0.0,
        quoteItems: [],
        images: [],
      );
}
