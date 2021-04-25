import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteItem {
  final String id;
  final String name;
  final int quantity;
  final double rate;
  final double tax;
  final DocumentReference productReference;

  QuoteItem({
    this.id,
    this.name,
    this.quantity,
    this.rate,
    this.tax,
    this.productReference,
  });

  factory QuoteItem.fromJson(Map<dynamic, dynamic> json) {
    return QuoteItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      rate: json['rate'] ?? 0.0,
      tax: json['tax'] ?? 0.0,
      productReference: json['product_reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name ?? '',
      'quantity': this.quantity ?? 0,
      'rate': this.rate ?? 0.0,
      'tax': this.tax ?? 0.0,
      'product_reference': this.productReference,
    };
  }
}
