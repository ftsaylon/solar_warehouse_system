import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Function confirm;
  final GlobalKey<FormState> formKey;

  ConfirmDialog({
    Key key,
    this.title,
    this.children,
    this.confirm,
    this.formKey,
  }) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  void _confirm() async {
    setState(() {
      _isLoading = true;
    });
    await widget.confirm();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: (_isLoading)
            ? [
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : [
                if (widget.children != null) ...widget.children,
                _buildActionButtons(context),
              ],
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
              onPressed: _confirm,
              child: Text('Confirm'),
            ),
          ),
        ),
        SizedBox(width: 12),
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
