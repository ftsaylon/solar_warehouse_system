import 'package:flutter/material.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations'),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile();
          },
        ),
      ),
    );
  }
}
