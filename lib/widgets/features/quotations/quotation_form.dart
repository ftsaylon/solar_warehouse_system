import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;

    if (widget.quotation != null) {
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
    await context.read<Quotations>().addQuotation(_editedQuotation);
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
                decoration: InputDecoration(labelText: 'Product Title'),
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
    return Column(
      children: [
        ..._editedQuotation.quoteItems
            .map((item) => ListTile(title: Text(item.name)))
            .toList(),
        ElevatedButton(
          onPressed: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => QuoteItemForm(),
          ),
          child: Text('Add Item'),
        ),
      ],
    );
  }
}
