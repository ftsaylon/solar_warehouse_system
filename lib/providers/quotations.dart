import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
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

  Future<void> updateQuotation(Quotation quotation) async {
    final updatedQuotationDoc =
        await _quotationsService.updateQuotation(quotation);
    if (updatedQuotationDoc != null) {
      quotation = quotation.copyWith(
        documentSnapshot: updatedQuotationDoc,
      );
      final index =
          _quotations.indexWhere((element) => element.id == quotation.id);
      if (index >= 0) _quotations[index] = quotation;
      notifyListeners();
    }
  }

  Future<void> deleteQuotation(Quotation quotation) async {
    await _quotationsService.deleteQuotation(quotation);
    _quotations.removeWhere((element) => element.id == quotation.id);
    notifyListeners();
  }
}
