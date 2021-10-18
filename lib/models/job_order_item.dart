import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class JobOrderItem {
  final String id;
  final String name;
  final int quantity;
  final DocumentReference productReference;

  JobOrderItem({
    this.id,
    this.name,
    this.quantity,
    this.productReference,
  });

  factory JobOrderItem.fromJson(Map<String, dynamic> json) {
    return JobOrderItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      productReference: json['product_reference'],
    );
  }

  factory JobOrderItem.initial() => JobOrderItem(
        id: Uuid().v1(),
        name: '',
        quantity: 0,
        productReference: null,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': this.name ?? '',
      'quantity': this.quantity ?? 0,
      'product_reference': this.productReference,
    };
  }

  JobOrderItem copyWith({
    String id,
    String name,
    int quantity,
    String quotationId,
    DocumentReference productReference,
  }) =>
      JobOrderItem(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        productReference: productReference ?? this.productReference,
      );
}
