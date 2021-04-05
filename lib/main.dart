import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/screens/quotations_screen.dart';
import 'package:solar_warehouse_system/services.dart';

import 'providers.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = Services();
  await services.setup();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Solar Warehouse System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: QuotationsScreen(),
      ),
    );
  }
}
