import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/services/customer_service.dart';

class Customers extends ChangeNotifier {
  final _customerService = GetIt.I<CustomerService>();

  List<Customer> _customers = [];

  List<Customer> get customers => [..._customers];

  Customer findById(String id) {
    return _customers.firstWhere((customer) => customer.id == id);
  }

  Future<void> fetchAndSetCustomers() async {
    final newCustomers = (_customers.isEmpty)
        ? await _customerService.fetchCustomers()
        : await _customerService.fetchCustomers(
            documentSnapshot: _customers.last.documentSnapshot,
          );

    _customers.addAll(newCustomers);
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    final newCustomerDoc = await _customerService.addCustomer(customer);
    if (newCustomerDoc != null) {
      customer = customer.copyWith(
        id: newCustomerDoc.id,
        documentSnapshot: newCustomerDoc,
        documentReference: newCustomerDoc.reference,
      );
      _customers.insert(0, customer);
      notifyListeners();
    }
  }
}
