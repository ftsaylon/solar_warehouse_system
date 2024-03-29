import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Product>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      }
      return <Product>[];
    });
  }

  Future<List<Product>> fetchProducts({
    DocumentSnapshot documentSnapshot,
  }) async {
    var query = _db
        .collection('products')
        .orderBy(
          'date_updated',
          descending: true,
        )
        .limit(20);

    if (documentSnapshot != null)
      query = query.startAfterDocument(documentSnapshot);

    return query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      }
      return <Product>[];
    });
  }

  Future<DocumentSnapshot> addProduct(Product product) async {
    final newProduct = _db.collection('products').doc();
    var requestBody = product.toJson();

    requestBody['date_created'] = FieldValue.serverTimestamp();
    requestBody['date_updated'] = FieldValue.serverTimestamp();

    await newProduct.set(requestBody);
    return newProduct.get();
  }
}
