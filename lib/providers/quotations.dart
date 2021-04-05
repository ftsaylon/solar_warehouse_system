import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/quotation.dart';

class Quotations extends ChangeNotifier {
  List<Quotation> _quotations = [];

  List<Quotation> get quotations => _quotations;
}
