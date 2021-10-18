import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/job_order.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/services/job_order_servicer.dart';

class JobOrders extends ChangeNotifier {
  final _jobOrdersService = GetIt.I<JobOrderService>();

  List<JobOrder> _jobOrders = [];
  List<JobOrder> get jobOrders => [..._jobOrders];

  Future<void> fetchAndSetQuotations() async {
    final newQuotations = (_jobOrders.isEmpty)
        ? await _jobOrdersService.fetchQuotations()
        : await _jobOrdersService.fetchQuotations(
            documentSnapshot: _jobOrders.last.documentSnapshot,
          );

    _jobOrders.addAll(newQuotations);
    notifyListeners();
  }

  Future<void> createJobOrderFromQuotation(Quotation quotation) async {
    var newJobOrder = JobOrder.fromQuotation(quotation);
    addJobOrder(newJobOrder);
  }

  Future<void> addJobOrder(JobOrder jobOrder) async {
    final newJobOrderDoc = await _jobOrdersService.addJobOrder(jobOrder);

    if (newJobOrderDoc != null) {
      final DateTime dateCreated = newJobOrderDoc.get('date_created')?.toDate();
      jobOrder = jobOrder.copyWith(
        id: newJobOrderDoc.id,
        documentSnapshot: newJobOrderDoc,
        dateCreated: dateCreated,
        dateOfExpiration: dateCreated.add(Duration(days: 30)),
      );
      _jobOrders.insert(0, jobOrder);
      notifyListeners();
    }
  }
}
