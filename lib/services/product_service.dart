import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Product>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Product.fromJson(doc.data()))
            .toList();
      }
      return <Product>[];
    });
  }
}
