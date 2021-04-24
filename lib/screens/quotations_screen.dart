import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({Key key}) : super(key: key);

  @override
  _QuotationsScreenState createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
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
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      context
          .read<Quotations>()
          .fetchAndSetQuotations()
          .then((_) => setState(() {
                _isLoading = false;
                _isInit = false;
              }));
    }
    super.didChangeDependencies();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    await context.read<Quotations>().fetchAndSetQuotations();
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Quotation> quotations = context.watch<Quotations>().quotations;

    final columns = [
      DataColumn(
        label: Text('ID'),
      ),
      DataColumn(
        label: Text('Title'),
      ),
      DataColumn(
        label: Text('Customer'),
      ),
      DataColumn(
        label: Text('Total'),
      ),
    ];

    final rows = quotations
        .map(
          (quotation) => DataRow(
            cells: [
              DataCell(
                Text(quotation.id),
              ),
              DataCell(
                Text(quotation.title),
              ),
              DataCell(
                Text(quotation.customer.name),
              ),
              DataCell(
                Text(quotation.total.toStringAsFixed(2)),
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
              title: 'Quotations',
              columns: columns,
              rows: rows,
            ),
          );
  }
}
