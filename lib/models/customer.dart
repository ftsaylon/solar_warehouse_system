import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String emailAddress;
  final String contactNumber;
  final String address;
  final DocumentSnapshot documentSnapshot;

  Customer({
    this.id,
    this.name,
    this.emailAddress,
    this.contactNumber,
    this.address,
    this.documentSnapshot,
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

  factory Customer.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    return Customer(
      id: documentSnapshot.id,
      name: data['name'] ?? '',
      emailAddress: data['emailAddress'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
    );
  }

  factory Customer.initial() => Customer(
        id: null,
        name: '',
        contactNumber: '',
        address: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'name': this.name ?? '',
      'emailAddress': this.emailAddress ?? '',
      'contactNumber': this.contactNumber ?? '',
      'address': this.address ?? '',
    };
  }

  Customer copyWith({
    String name,
    String emailAddress,
    String contactNumber,
    String address,
    DocumentSnapshot documentSnapshot,
  }) {
    return Customer(
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }
}
