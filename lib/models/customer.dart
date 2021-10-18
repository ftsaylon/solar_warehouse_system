import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String emailAddress;
  final String contactNumber;
  final String address;
  final DocumentSnapshot documentSnapshot;
  final DocumentReference documentReference;

  Customer({
    this.id,
    this.name,
    this.emailAddress,
    this.contactNumber,
    this.address,
    this.documentSnapshot,
    this.documentReference,
  });

  factory Customer.fromJson(Map<dynamic, dynamic> json) {
    var id = '';

    if (json['reference'] != null)
      id = (json['reference'] as DocumentReference).id;

    return Customer(
      id: id,
      name: json['name'] ?? '',
      emailAddress: json['email_address'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      documentReference: json['reference'],
    );
  }

  factory Customer.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    return Customer(
      id: documentSnapshot.id,
      name: data['name'] ?? '',
      emailAddress: data['email_address'] ?? '',
      contactNumber: data['contact_number'] ?? '',
      address: data['address'] ?? '',
      documentSnapshot: documentSnapshot,
      documentReference: documentSnapshot.reference,
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
      'email_address': this.emailAddress ?? '',
      'contact_number': this.contactNumber ?? '',
      'address': this.address ?? '',
      'reference': this.documentReference ?? this?.documentSnapshot?.reference,
    };
  }

  Customer copyWith({
    String id,
    String name,
    String emailAddress,
    String contactNumber,
    String address,
    DocumentSnapshot documentSnapshot,
    DocumentReference documentReference,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
      documentReference: documentReference ?? this.documentReference,
    );
  }
}
