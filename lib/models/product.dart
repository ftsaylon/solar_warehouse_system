import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double cost;
  final double price;
  final DocumentSnapshot documentSnapshot;

  Product({
    this.id,
    this.name,
    this.cost,
    this.price,
    this.documentSnapshot,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      price: json['price'],
    );
  }

  factory Product.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    return Product(
      id: documentSnapshot.id,
      name: data['name'] ?? '',
      cost: (data['cost'] ?? 0).toDouble(),
      price: (data['price'] ?? 0).toDouble(),
      documentSnapshot: documentSnapshot,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name ?? '',
      'cost': this.cost ?? 0.0,
      'price': this.price ?? 0.0,
    };
  }

  Product copyWith({
    String id,
    String name,
    double cost,
    double price,
    DocumentSnapshot documentSnapshot,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      price: price ?? this.price,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }

  factory Product.initial() => Product(
        id: null,
        name: '',
        cost: 0.0,
        price: 0.0,
      );
}
