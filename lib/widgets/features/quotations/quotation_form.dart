import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/helpers/image_util.dart';
import 'package:solar_warehouse_system/models/customer.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';
import 'package:solar_warehouse_system/widgets/common/custom_form_dialog.dart';
import 'package:solar_warehouse_system/widgets/features/customers/customer_form.dart';
import 'package:solar_warehouse_system/widgets/features/quotations/quote_items_table.dart';

class QuotationForm extends StatefulWidget {
  final Quotation quotation;
  final bool isDuplicating;
  final bool isEditing;

  QuotationForm({
    this.quotation,
    this.isEditing,
    this.isDuplicating,
    Key key,
  }) : super(key: key);

  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _scrollController = ScrollController();

  bool _isInit;
  bool _isLoading;

  var _editedQuotation = Quotation.initial();
  var _initValues = {
    'title': '',
  };

  bool get isEditing => widget.isEditing ?? false;
  bool get isDuplicating => widget.isDuplicating ?? false;

  @override
  void initState() {
    _isInit = true;
    _isLoading = false;

    if (isEditing || isDuplicating) {
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

      if (isEditing || isDuplicating) {
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
    final quotationsProvider = context.read<Quotations>();

    _editedQuotation = _editedQuotation.copyWith(
      quoteItems: quoteItemsProvider.quoteItems,
      total: quoteItemsProvider.total,
    );

    if (isEditing) {
      await quotationsProvider.updateQuotation(_editedQuotation);
    } else {
      await quotationsProvider.addQuotation(_editedQuotation);
    }

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
              _buildImagePicker(),
              _editedQuotation.images.isEmpty
                  ? Center(child: Text('No images yet'))
                  : _buildImages([
                      ..._editedQuotation.images
                          .map((image) => _buildImage(image)),
                    ]),
            ],
          );
  }

  _buildImage(String imageUrl) {
    return Card(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  _editedQuotation.images.remove(imageUrl);
                });
              },
              child: ClipOval(
                child: Container(
                  width: 25,
                  height: 25,
                  color: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImages(List<Widget> images) {
    return Container(
      width: 600,
      height: 300,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: GridView.builder(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return images[index];
          },
        ),
      ),
    );
  }

  Widget _buildSelectCustomer(BuildContext context) {
    var initCustomer;
    final customersProvider = context.watch<Customers>();
    final customers = customersProvider.customers;
    if (isEditing || isDuplicating) {
      initCustomer = customersProvider.findById(_editedQuotation.customer.id);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DropdownButtonFormField<Customer>(
            value: initCustomer ?? null,
            items: customers
                .map<DropdownMenuItem<Customer>>(
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
          ),
        ),
        ElevatedButton(
          onPressed: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => CustomerForm(),
          ),
          child: Text('Create New Customer'),
        ),
      ],
    );
  }

  Widget _buildQuoteItems(BuildContext context) {
    final quoteItems = context.watch<QuoteItems>().quoteItems;
    return QuoteItemsTable(
      quoteItems: quoteItems,
      isViewing: false,
    );
  }

  Widget _buildImagePicker() {
    final imagePicker = _ImagePicker(
      setQuoteImages: (List<String> imageUrls) {
        setState(() {
          _editedQuotation = _editedQuotation
              .copyWith(images: [...imageUrls, ..._editedQuotation.images]);
        });
      },
    );

    return imagePicker;
  }
}

class _ImagePicker extends StatefulWidget {
  final Function setQuoteImages;

  _ImagePicker({
    Key key,
    this.setQuoteImages,
  }) : super(key: key);

  @override
  __ImagePickerState createState() => __ImagePickerState();
}

class __ImagePickerState extends State<_ImagePicker> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final quotationsProvider = context.read<Quotations>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _isLoading
            ? () {}
            : () async {
                final images = await pickImage(context);
                setState(() {
                  _isLoading = true;
                });
                final imageUrls =
                    await quotationsProvider.uploadQuotationImages(images);
                setState(() {
                  _isLoading = false;
                });
                widget.setQuoteImages(imageUrls);
              },
        child: (!_isLoading)
            ? Text('Upload Images')
            : Text('Uploading images. Please wait...'),
      ),
    );
  }
}
