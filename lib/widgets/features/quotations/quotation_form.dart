import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';
import 'package:solar_warehouse_system/widgets/features/quotations/quote_item_form.dart';

class QuotationForm extends StatefulWidget {
  final Quotation quotation;
  QuotationForm({this.quotation, Key key}) : super(key: key);

  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();

  bool _isInit;
  bool _isLoading;

  var _editedQuotation = Quotation.initial();
  var _initValues = {
    'title': '',
  };

  bool get isEditing => widget.quotation != null;

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;

    if (isEditing) {
      _editedQuotation = widget.quotation;
      _initValues = {
        'title': _editedQuotation.title,
      };
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await context.read<Customers>().fetchAndSetCustomers();

      if (isEditing) {
        context
            .read<QuoteItems>()
            .fetchAndSetQuoteItems(_editedQuotation.quoteItems);
      }

      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    final quoteItemsProvider = context.read<QuoteItems>();
    _editedQuotation = _editedQuotation.copyWith(
      quoteItems: quoteItemsProvider.quoteItems,
      total: quoteItemsProvider.total,
    );
    await context.read<Quotations>().addQuotation(_editedQuotation);
    quoteItemsProvider.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomFormDialog(
            formKey: _formKey,
            title: 'New Quotation',
            saveForm: () => _saveForm(context),
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Quotation Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedQuotation = _editedQuotation.copyWith(title: value);
                },
              ),
              _buildSelectCustomer(context),
              _buildQuoteItems(context),
            ],
          );
  }

  Widget _buildSelectCustomer(BuildContext context) {
    final customers = context.watch<Customers>().customers;
    return DropdownButtonFormField(
      items: customers
          .map<DropdownMenuItem>(
            (customer) => DropdownMenuItem<Customer>(
              value: customer,
              child: Text(customer.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        _editedQuotation = _editedQuotation.copyWith(customer: value);
      },
      decoration: InputDecoration(labelText: 'Select Customer'),
    );
  }

  Widget _buildQuoteItems(BuildContext context) {
    final quoteItems = context.watch<QuoteItems>().quoteItems;
    final columns = [
      DataColumn(
        label: Text('Name'),
      ),
      DataColumn(
        label: Text('Quantity'),
      ),
      DataColumn(
        label: Text('Rate'),
      ),
      DataColumn(
        label: Text('Tax'),
      ),
      DataColumn(
        label: Text('SubTotal'),
      ),
    ];
    final rows = quoteItems.values
        .map((quoteItem) => DataRow(cells: [
              DataCell(
                Text(quoteItem.name),
              ),
              DataCell(
                Text(quoteItem.quantity.toString()),
              ),
              DataCell(
                Text(quoteItem.rate.toStringAsFixed(2)),
              ),
              DataCell(
                Text(quoteItem.tax.toStringAsFixed(2)),
              ),
              DataCell(
                Text(quoteItem.subTotal.toStringAsFixed(2)),
              ),
            ]))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Quote Items'),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => QuoteItemForm(),
              ),
              child: Text('Add Item'),
            ),
          ],
        ),
        DataTable(
          headingTextStyle: Theme.of(context).textTheme.subtitle1,
          headingRowColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor.withOpacity(0.08)),
          columns: columns,
          rows: rows,
        ),
      ],
    );
  }
}
