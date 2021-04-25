import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';
import 'package:solar_warehouse_system/widgets/features/customers/customer_form.dart';

class CustomersScreen extends StatefulWidget {
  CustomersScreen({Key key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool _isInit;
  bool _isLoading;
  bool _isLoadingMore;

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;
    _isLoadingMore = false;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await context.read<Customers>().fetchAndSetCustomers();

      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    await context.read<Customers>().fetchAndSetCustomers();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Customer> customers = context.watch<Customers>().customers;
    final columns = [
      DataColumn(
        label: Text('ID'),
      ),
      DataColumn(
        label: Text('Name'),
      ),
      DataColumn(
        label: Text('Email Address'),
      ),
      DataColumn(
        label: Text('Contact Number'),
      ),
      DataColumn(
        label: Text('Address'),
      ),
    ];

    final rows = customers
        .map(
          (customer) => DataRow(
            cells: [
              DataCell(
                Text(customer.id),
              ),
              DataCell(
                Text(customer.name),
              ),
              DataCell(
                Text(customer.emailAddress),
              ),
              DataCell(
                Text(customer.contactNumber),
              ),
              DataCell(
                Text(customer.address),
              ),
            ],
          ),
        )
        .toList();

    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : LazyLoadScrollView(
            isLoading: _isLoadingMore,
            onEndOfPage: _loadMore,
            child: CustomDataTable(
              title: 'Customers',
              columns: columns,
              rows: rows,
              onCreateNew: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => CustomerForm(),
              ),
            ),
          );
  }
}
