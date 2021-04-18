import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Quotation>>(
        stream: context.read<Quotations>().quotationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (Center(child: CircularProgressIndicator()));
          }

          List<Quotation> quotations = snapshot.data;

          return ListView.builder(
            itemCount: quotations.length,
            itemBuilder: (context, index) {
              final quotation = quotations[index];
              return ListTile(
                title: Text(quotation.title),
              );
            },
          );
        },
      ),
    );
  }
}
