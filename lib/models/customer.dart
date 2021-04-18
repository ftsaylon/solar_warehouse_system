class Customer {
  final String id;
  final String name;
  final String emailAddress;
  final String contactNumber;
  final String address;

  Customer({
    this.id,
    this.name,
    this.emailAddress,
    this.contactNumber,
    this.address,
  });

  factory Customer.fromJson(Map<dynamic, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Customer copyWith({
    String name,
    String emailAddress,
    String contactNumber,
    String address,
  }) {
    return Customer(
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
    );
  }
}
