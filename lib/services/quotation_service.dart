import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/quotation.dart';

class QuotationService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Quotation>> fetchQuotations() {
    return _db.collection('quotations').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Quotation.fromJson(doc.data()))
            .toList();
      }
      return <Quotation>[];
    });
  }
}
