import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';

import 'customer.dart';

class Quotation extends ChangeNotifier {
  final String id;
  final String title;
  final Customer customer;
  final double total;
  final Map<String, QuoteItem> quoteItems;
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
        images: json['images'] ?? <String>[],
      );

  factory Quotation.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    final quoteItems = (data['quote_items'] as Map<String, dynamic>)
            ?.map((key, value) => MapEntry(key, QuoteItem.fromJson(value))) ??
        {};
    return Quotation(
      id: documentSnapshot.id,
      title: data['title'] ?? '',
      customer: Customer.fromJson(data['customer'] ?? {}),
      total: data['total']?.toDouble() ?? 0.0,
      quoteItems: quoteItems,
      images: data['images']?.cast<String>() ?? <String>[],
      documentSnapshot: documentSnapshot,
    );
  }

  Map<String, dynamic> toJson() {
    final quoteItems =
        this.quoteItems.map((key, value) => MapEntry(value.id, value.toJson()));

    return {
      'title': this.title ?? '',
      'customer_id': this.customer.id ?? '',
      'customer': this.customer.toJson() ?? Customer.initial().toJson(),
      'total': this.total ?? 0.0,
      'quote_items': quoteItems ?? {},
      'images': this.images ?? [],
    };
  }

  Quotation copyWith({
    String id,
    String title,
    Customer customer,
    double total,
    Map<String, QuoteItem> quoteItems,
    List<String> images,
    DocumentSnapshot documentSnapshot,
  }) =>
      Quotation(
        id: id ?? this.id,
        title: title ?? this.title,
        customer: customer ?? this.customer,
        total: total ?? this.total,
        quoteItems: quoteItems ?? this.quoteItems,
        images: images ?? this.images,
        documentSnapshot: documentSnapshot ?? this.documentSnapshot,
      );

  factory Quotation.initial() => Quotation(
        id: null,
        title: '',
        customer: null,
        total: 0.0,
        quoteItems: {},
        images: [],
      );
}
