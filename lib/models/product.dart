class Product {
  final String id;
  final String name;
  final double cost;
  final double price;

  Product({
    this.id,
    this.name,
    this.cost,
    this.price,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      price: json['price'],
    );
  }

  Product copyWith({
    String name,
    double cost,
    double price,
  }) {
    return Product(
      name: name ?? this.name,
      cost: cost ?? this.cost,
      price: price ?? this.price,
    );
  }
}
