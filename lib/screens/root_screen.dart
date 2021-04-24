/* ---------------------------- Flutter Packages ---------------------------- */

import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/screens/products_screen.dart';
import 'package:solar_warehouse_system/widgets/common/custom_app_bar.dart';

/* --------------------------------- Screens -------------------------------- */

import 'dashboard_screen.dart';
import 'quotations_screen.dart';

/* --------------------------------- Widgets -------------------------------- */

/* --------------------------------- Helpers -------------------------------- */

class RootScreen extends StatefulWidget {
  RootScreen({Key key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    QuotationsScreen(),
    ProductsScreen(),
  ];

  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: _buildNavigationRail(),
                  ),
                ),
              );
            },
          ),
          VerticalDivider(),
          Expanded(
            child: _widgetOptions[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      extended: true,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assignment),
          selectedIcon: Icon(Icons.assignment),
          label: Text('Quotations'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory),
          selectedIcon: Icon(Icons.inventory),
          label: Text('Products'),
        ),
      ],
    );
  }
}
