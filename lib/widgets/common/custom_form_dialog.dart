import 'package:flutter/material.dart';

class CustomFormDialog extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Function saveForm;
  final GlobalKey<FormState> formKey;

  const CustomFormDialog({
    this.title,
    this.children,
    this.saveForm,
    this.formKey,
    Key key,
  }) : super(key: key);

  @override
  _CustomFormDialogState createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<CustomFormDialog> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    await widget.saveForm();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: (_isLoading)
              ? [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              : [
                  ...widget.children,
                  _buildActionButtons(context),
                ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).unselectedWidgetColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
