import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solar_warehouse_system/models/job_order.dart';

class JobOrderService {
  final _db = FirebaseFirestore.instance;

  Future<List<JobOrder>> fetchQuotations({
    DocumentSnapshot documentSnapshot,
  }) async {
    var query = _db.collection('job_orders').limit(20);

    if (documentSnapshot != null)
      query = query.startAfterDocument(documentSnapshot);

    return query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => JobOrder.fromSnapshot(doc)).toList();
      }
      return <JobOrder>[];
    });
  }

  Future<DocumentSnapshot> addJobOrder(JobOrder jobOrder) async {
    final newJobOrder = _db.collection('job_orders').doc();
    var requestBody = jobOrder.toJson();

    requestBody['date_created'] = FieldValue.serverTimestamp();
    requestBody['date_updated'] = FieldValue.serverTimestamp();

    await newJobOrder.set(requestBody);
    return newJobOrder.get();
  }

  Future<DocumentSnapshot> updateJobOrder(JobOrder jobOrder) async {
    final newJobOrder = _db.collection('job_orders').doc(jobOrder.id);
    var requestBody = jobOrder.toJson();

    requestBody['date_updated'] = FieldValue.serverTimestamp();

    await newJobOrder.update(requestBody);
    return newJobOrder.get();
  }

  Future<void> deleteJobOrder(JobOrder jobOrder) async {
    await _db.collection('job_orders').doc(jobOrder.id).delete();
  }
}
