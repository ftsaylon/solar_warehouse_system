import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
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
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final _tableScrollController = ScrollController();
  final _screenScrollController = ScrollController();

  @override
  void dispose() {
    _tableScrollController.dispose();
    _screenScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scrollbar(
        isAlwaysShown: true,
        controller: _screenScrollController,
        child: ListView(
          controller: _screenScrollController,
          children: [
            if (widget.title != null)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.onCreateNew,
                    child: Text('Create New'),
                  ),
                ],
              ),
            Scrollbar(
              isAlwaysShown: true,
              controller: _tableScrollController,
              child: SingleChildScrollView(
                controller: _tableScrollController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.minWidth),
                  child: DataTable(
                    headingTextStyle: Theme.of(context).textTheme.subtitle1,
                    headingRowColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withOpacity(0.08)),
                    columns: widget.columns,
                    rows: widget.rows,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
