import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/product.dart';

class ProductForm extends StatefulWidget {
  final Product product;

  static const routeName = '/edit-quotation';

  const ProductForm({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _costFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  var _editedProduct = Product.initial();

  var _initValues = {
    'name': '',
    'cost': 0.0,
    'price': 0.0,
  };

  @override
  void initState() {
    if (widget.product != null) {
      _editedProduct = widget.product;
      _initValues = {
        'name': _editedProduct.name,
        'cost': _editedProduct.cost,
        'price': _editedProduct.price,
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _costFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();

    if (isValid) return;

    _formKey.currentState.save();

    // TODO: Implement save
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _initValues['name'],
              decoration: InputDecoration(labelText: 'name'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_costFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = _editedProduct.copyWith(name: value);
              },
            ),
            TextFormField(
              initialValue: _initValues['cost'],
              decoration: InputDecoration(labelText: 'Cost'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _costFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
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
                _editedProduct = _editedProduct.copyWith(
                  cost: double.parse(value),
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {},
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
                _editedProduct = _editedProduct.copyWith(
                  price: double.parse(value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
