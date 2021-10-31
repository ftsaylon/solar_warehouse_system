/* ---------------------------- Flutter Packages ---------------------------- */

import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/screens/customers_screen.dart';
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
  final _screens = <Widget>[
    DashboardScreen(),
    CustomersScreen(),
    ProductsScreen(),
    QuotationsScreen(),
  ];

  final _tabs = [
    CustomTab(
      icon: Icon(Icons.dashboard),
      title: Text('Dashboard'),
    ),
    CustomTab(
      icon: Icon(Icons.contacts),
      title: Text('Customers'),
    ),
    CustomTab(
      icon: Icon(Icons.inventory),
      title: Text('Products'),
    ),
    CustomTab(
      icon: Icon(Icons.assignment),
      title: Text('Quotations'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        appBar: CustomAppBar(
          bottom: TabBar(
            labelPadding: EdgeInsets.all(16),
            tabs: _tabs,
          ),
        ),
        body: TabBarView(children: _screens),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final Text title;
  final Icon icon;

  const CustomTab({
    this.title,
    this.icon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 8),
        title,
      ],
    );
  }
}
