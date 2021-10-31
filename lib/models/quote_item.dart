import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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

  factory QuoteItem.initial() => QuoteItem(
        id: Uuid().v1(),
        name: '',
        quantity: 0,
        rate: 0.0,
        tax: 0.0,
        productReference: null,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': this.name ?? '',
      'quantity': this.quantity ?? 0,
      'rate': this.rate ?? 0.0,
      'tax': this.tax ?? 0.0,
      'product_reference': this.productReference,
    };
  }

  QuoteItem copyWith({
    String id,
    String name,
    int quantity,
    double rate,
    double tax,
    DocumentReference productReference,
  }) =>
      QuoteItem(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        rate: rate ?? this.rate,
        tax: tax ?? this.tax,
        productReference: productReference ?? this.productReference,
      );

  double get subTotal =>
      (this.quantity * this.rate) +
      ((this.quantity * this.rate) * (this.tax / 100));
}
