import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/product.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';
import 'package:solar_warehouse_system/providers/products.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';
import 'package:provider/provider.dart';

class QuoteItemForm extends StatefulWidget {
  final QuoteItem quoteItem;

  QuoteItemForm({this.quoteItem, Key key}) : super(key: key);

  @override
  _QuoteItemFormState createState() => _QuoteItemFormState();
}

class _QuoteItemFormState extends State<QuoteItemForm> {
  final _formKey = GlobalKey<FormState>();
  // final _nameFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _rateFocusNode = FocusNode();
  final _taxFocusNode = FocusNode();

  bool _isInit;
  bool _isLoading;

  var _editedQuoteItem = QuoteItem.initial();
  var _initValues = {
    'quantity': '',
    'rate': '',
    'tax': '12',
  };

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;

    if (widget.quoteItem != null) {
      _editedQuoteItem = widget.quoteItem;
      _initValues = {
        'quantity': _editedQuoteItem.quantity.toString(),
        'rate': _editedQuoteItem.rate.toString(),
        'tax': _editedQuoteItem.toString(),
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

      await context.read<Products>().fetchAndSetProducts();

      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _quantityFocusNode.dispose();
    _rateFocusNode.dispose();
    _taxFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    context.read<QuoteItems>().addQuoteItem(_editedQuoteItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormDialog(
      formKey: _formKey,
      title: 'New Quote Item',
      saveForm: () => _saveForm(context),
      children: [
        _buildSelectProduct(context),
        TextFormField(
          initialValue: _initValues['quantity'],
          decoration: InputDecoration(labelText: 'Quantity'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_rateFocusNode);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a quantity.';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number.';
            }
            if (int.parse(value) <= 0) {
              return 'Please enter a number greater than zero.';
            }
            return null;
          },
          onSaved: (value) {
            _editedQuoteItem = _editedQuoteItem.copyWith(
              quantity: int.parse(value),
            );
          },
        ),
        TextFormField(
          initialValue: _initValues['rate'],
          decoration: InputDecoration(labelText: 'Rate'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_taxFocusNode);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a price.';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number.';
            }
            if (double.parse(value) <= 0) {
              return 'Please enter a number greater than zero.';
            }
            return null;
          },
          onSaved: (value) {
            _editedQuoteItem = _editedQuoteItem.copyWith(
              rate: double.parse(value),
            );
          },
        ),
        TextFormField(
          initialValue: _initValues['tax'],
          decoration: InputDecoration(labelText: 'Tax'),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a tax rate.';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number.';
            }
            if (double.parse(value) <= 0) {
              return 'Please enter a number greater than zero.';
            }
            return null;
          },
          onSaved: (value) {
            _editedQuoteItem = _editedQuoteItem.copyWith(
              tax: double.parse(value),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectProduct(BuildContext context) {
    final products = context.watch<Products>().products;
    return DropdownButtonFormField(
      items: products
          .map<DropdownMenuItem<Product>>(
            (product) => DropdownMenuItem<Product>(
              value: product,
              child: Text(product.name),
            ),
          )
          .toList(),
      onChanged: (Product value) {
        _editedQuoteItem = _editedQuoteItem.copyWith(
          name: value.name,
          rate: value.price,
          productReference: value.documentSnapshot.reference,
        );
      },
      decoration: InputDecoration(labelText: 'Select Product'),
    );
  }
}
