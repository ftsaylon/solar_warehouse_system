import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/job_order_item.dart';
import 'package:solar_warehouse_system/models/quotation.dart';

import 'customer.dart';

class JobOrder {
  final String id;
  final String title;
  final Customer customer;
  final Map<String, JobOrderItem> jobOrderItems;
  final List<String> images;
  final DocumentSnapshot documentSnapshot;
  final DateTime dateCreated;

  JobOrder({
    this.id,
    this.title,
    this.customer,
    this.jobOrderItems,
    this.images,
    this.documentSnapshot,
    this.dateCreated,
  });

  factory JobOrder.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();
    final jobOrderItems = (data['quote_items'] as Map<String, dynamic>)?.map(
            (key, value) => MapEntry(key, JobOrderItem.fromJson(value))) ??
        {};
    return JobOrder(
      id: documentSnapshot.id,
      title: data['title'] ?? '',
      customer: Customer.fromJson(data['customer'] ?? {}),
      images: data['images']?.cast<String>() ?? <String>[],
      dateCreated: data['date_created']?.toDate() ?? DateTime.now(),
      documentSnapshot: documentSnapshot,
      jobOrderItems: jobOrderItems,
    );
  }

  factory JobOrder.fromQuotation(Quotation quotation) {
    return JobOrder(
      customer: quotation.customer,
      images: quotation.images,
      jobOrderItems: quotation.quoteItems.map(
        (key, value) => MapEntry(
          key,
          JobOrderItem(
            name: value.name,
            productReference: value.productReference,
            quantity: value.quantity,
          ),
        ),
      ),
      title: quotation.title,
    );
  }

  Map<String, dynamic> toJson() {
    final jobOrderItems = this
        .jobOrderItems
        .map((key, value) => MapEntry(value.id, value.toJson()));

    return {
      'title': this.title ?? '',
      'customer_id': this.customer.id ?? '',
      'customer': this.customer.toJson(),
      'jobOrderItems': jobOrderItems ?? {},
      'images': this.images ?? [],
    };
  }

  JobOrder copyWith({
    String id,
    String title,
    Customer customer,
    double total,
    Map<String, JobOrderItem> jobOrderItems,
    List<String> images,
    DateTime dateCreated,
    DateTime dateOfExpiration,
    DocumentSnapshot documentSnapshot,
  }) =>
      JobOrder(
        id: id ?? this.id,
        title: title ?? this.title,
        customer: customer ?? this.customer,
        jobOrderItems: jobOrderItems ?? this.jobOrderItems,
        images: images ?? this.images,
        dateCreated: dateCreated ?? this.dateCreated,
        documentSnapshot: documentSnapshot ?? this.documentSnapshot,
      );

  factory JobOrder.initial() => JobOrder(
        id: null,
        title: '',
        customer: null,
        jobOrderItems: {},
        images: [],
      );
}
