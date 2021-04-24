import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/services/quotation_service.dart';

class Quotations extends ChangeNotifier {
  final _quotationsService = GetIt.I<QuotationService>();

  Stream<List<Quotation>> quotationsStream() {
    return _quotationsService.fetchQuotations();
  }
}
