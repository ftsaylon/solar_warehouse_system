import 'package:provider/provider.dart';

import 'providers/quotations.dart';

final providers = [
  ChangeNotifierProvider<Quotations>(
    create: (_) => Quotations(),
  ),
];
