import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:solar_warehouse_system/providers/products.dart';

import 'providers/quotations.dart';

final providers = [
  ChangeNotifierProvider<Quotations>(
    create: (_) => Quotations(),
  ),
  ChangeNotifierProvider<Products>(
    create: (_) => Products(),
  ),
  ChangeNotifierProvider<Customers>(
    create: (_) => Customers(),
  ),
];
