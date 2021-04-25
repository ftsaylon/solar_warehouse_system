import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({
    Key key,
    @required this.columns,
    @required this.rows,
    this.title,
    this.onCreateNew,
  }) : super(key: key);

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String title;
  final Function onCreateNew;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (title != null)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              ElevatedButton(
                onPressed: onCreateNew,
                child: Text('Create New'),
              ),
            ],
          ),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            headingTextStyle: Theme.of(context).textTheme.subtitle1,
            headingRowColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withOpacity(0.08)),
            columns: columns,
            rows: rows,
          ),
        ),
      ],
    );
  }
}
