import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:solar_warehouse_system/widgets/common/custom_data_table.dart';
import 'package:solar_warehouse_system/widgets/features/quotations/quotation_detail.dart';
import 'package:solar_warehouse_system/widgets/features/quotations/quotation_form.dart';

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
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await context.read<Quotations>().fetchAndSetQuotations();

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
      DataColumn(
        label: Text('Actions'),
      ),
    ];

    final rows = quotations.map((quotation) {
      return DataRow(
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
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.open_in_new),
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => QuotationDetail(
                      quotation: quotation,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => QuotationForm(
                      quotation: quotation,
                      isEditing: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => QuotationForm(
                      quotation: quotation,
                      isDuplicating: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

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
              onCreateNew: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => QuotationForm(),
              ),
            ),
          );
  }
}
