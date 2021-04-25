import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';

class CustomerForm extends StatefulWidget {
  final Customer customer;

  CustomerForm({
    this.customer,
    Key key,
  }) : super(key: key);

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  var _editedCustomer = Customer.initial();

  var _initValues = {
    'name': '',
    'email': '',
    'contact': '',
    'address': '',
  };

  @override
  void initState() {
    if (widget.customer != null) {
      _editedCustomer = widget.customer;
      _initValues = {
        'name': _editedCustomer.name,
        'email': _editedCustomer.emailAddress,
        'contact': _editedCustomer.contactNumber,
        'address': _editedCustomer.address,
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _contactFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    await context.read<Customers>().addCustomer(_editedCustomer);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormDialog(
      formKey: _formKey,
      title: 'New Customer',
      saveForm: () => _saveForm(context),
      children: [
        TextFormField(
          initialValue: _initValues['name'],
          decoration: InputDecoration(labelText: 'Customer Name'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _editedCustomer = _editedCustomer.copyWith(name: value);
          },
        ),
        TextFormField(
          initialValue: _initValues['email'],
          decoration: InputDecoration(labelText: 'Email Address'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_contactFocusNode);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _editedCustomer = _editedCustomer.copyWith(emailAddress: value);
          },
        ),
        TextFormField(
          initialValue: _initValues['contact'],
          decoration: InputDecoration(labelText: 'Contact Number'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_addressFocusNode);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _editedCustomer = _editedCustomer.copyWith(contactNumber: value);
          },
        ),
        TextFormField(
          initialValue: _initValues['address'],
          decoration: InputDecoration(labelText: 'Address'),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _editedCustomer = _editedCustomer.copyWith(address: value);
          },
        ),
      ],
    );
  }
}
