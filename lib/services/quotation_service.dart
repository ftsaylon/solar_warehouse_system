import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/quotation.dart';

class QuotationService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Quotation>> streamQuotations() {
    return _db.collection('quotations').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Quotation.fromSnapshot(doc)).toList();
      }
      return <Quotation>[];
    });
  }

  Future<List<Quotation>> fetchQuotations({
    DocumentSnapshot documentSnapshot,
  }) async {
    var query = _db.collection('quotations').limit(10);

    if (documentSnapshot != null)
      query = query.startAfterDocument(documentSnapshot);

    return query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Quotation.fromSnapshot(doc)).toList();
      }
      return <Quotation>[];
    });
  }
}
