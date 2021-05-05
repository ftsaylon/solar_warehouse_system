import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';
import 'package:solar_warehouse_system/services/quotation_service.dart';

class Quotations extends ChangeNotifier {
  final _quotationsService = GetIt.I<QuotationService>();

  List<Quotation> _quotations = [];

  List<Quotation> get quotations => [..._quotations];

  Stream<List<Quotation>> quotationsStream() {
    return _quotationsService.streamQuotations();
  }

  Future<void> fetchAndSetQuotations() async {
    final newQuotations = (_quotations.isEmpty)
        ? await _quotationsService.fetchQuotations()
        : await _quotationsService.fetchQuotations(
            documentSnapshot: _quotations.last.documentSnapshot,
          );

    _quotations.addAll(newQuotations);
    notifyListeners();
  }

  Future<void> addQuotation(Quotation quotation) async {
    final newQuotationDoc = await _quotationsService.addQuotation(quotation);
    if (newQuotationDoc != null) {
      quotation = quotation.copyWith(
        id: newQuotationDoc.id,
        documentSnapshot: newQuotationDoc,
      );
      _quotations.insert(0, quotation);
      notifyListeners();
    }
  }
}
