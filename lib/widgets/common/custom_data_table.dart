import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({
    Key key,
    @required this.columns,
    @required this.rows,
  }) : super(key: key);

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      ],
    );
  }
}
