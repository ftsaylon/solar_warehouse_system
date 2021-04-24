import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/products.dart';

import 'providers/quotations.dart';

final providers = [
  ChangeNotifierProvider<Quotations>(
    create: (_) => Quotations(),
  ),
  ChangeNotifierProvider<Products>(
    create: (_) => Products(),
  ),
];
