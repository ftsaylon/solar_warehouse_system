import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/customers.dart';
import 'package:solar_warehouse_system/providers/job_orders.dart';
import 'package:solar_warehouse_system/providers/products.dart';
import 'package:solar_warehouse_system/providers/quote_items.dart';

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
  ChangeNotifierProvider<QuoteItems>(
    create: (_) => QuoteItems(),
  ),
  ChangeNotifierProvider<JobOrders>(
    create: (_) => JobOrders(),
  ),
];
