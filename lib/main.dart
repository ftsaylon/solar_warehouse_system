import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/screens/root_screen.dart';
import 'package:solar_warehouse_system/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      ),
    );
  }
}
