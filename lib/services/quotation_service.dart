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
    var query = _db.collection('quotations').limit(20);

    if (documentSnapshot != null)
      query = query.startAfterDocument(documentSnapshot);

    return query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Quotation.fromSnapshot(doc)).toList();
      }
      return <Quotation>[];
    });
  }

  Future<DocumentSnapshot> addQuotation(Quotation quotation) async {
    final newQuotation = _db.collection('quotations').doc();
    var requestBody = quotation.toJson();

    requestBody['date_created'] = FieldValue.serverTimestamp();
    requestBody['date_updated'] = FieldValue.serverTimestamp();

    await newQuotation.set(requestBody);
    return newQuotation.get();
  }

  Future<DocumentSnapshot> updateQuotation(Quotation quotation) async {
    final newQuotation = _db.collection('quotations').doc(quotation.id);
    var requestBody = quotation.toJson();

    requestBody['date_updated'] = FieldValue.serverTimestamp();

    await newQuotation.update(requestBody);
    return newQuotation.get();
  }
}
