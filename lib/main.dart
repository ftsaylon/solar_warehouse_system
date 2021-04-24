/* ---------------------------- Flutter Packages ---------------------------- */

import 'package:flutter/material.dart';

/* --------------------------- 3rd-Party Packages --------------------------- */

import 'package:provider/provider.dart';

/* --------------------------------- Screens -------------------------------- */

import 'screens/root_screen.dart';

/* --------------------------------- Helpers -------------------------------- */

import 'services.dart';
import 'providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = Services();
  await services.setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Solar Warehouse System',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: RootScreen(),
        routes: {},
      ),
    );
  }
}
