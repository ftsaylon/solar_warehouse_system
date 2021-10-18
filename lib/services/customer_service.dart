import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/customer.dart';

class CustomerService {
  final _db = FirebaseFirestore.instance;

  Future<List<Customer>> fetchCustomers({
    DocumentSnapshot documentSnapshot,
  }) async {
    var query = _db
        .collection('customers')
        .orderBy(
          'date_updated',
          descending: true,
        )
        .limit(20);

    if (documentSnapshot != null)
      query = query.startAfterDocument(documentSnapshot);

    return query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Customer.fromSnapshot(doc)).toList();
      }
      return <Customer>[];
    });
  }

  Future<DocumentSnapshot> addCustomer(Customer customer) async {
    final newCustomer = _db.collection('customers').doc();
    var requestBody = customer.toJson();

    requestBody['date_created'] = FieldValue.serverTimestamp();
    requestBody['date_updated'] = FieldValue.serverTimestamp();
    requestBody['reference'] = newCustomer;

    await newCustomer.set(requestBody);
    return newCustomer.get();
  }
}
