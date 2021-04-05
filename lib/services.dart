import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/services/quotation_service.dart';

class Services {
  final getIt = GetIt.instance;

  Future<void> setup() async {
    await Firebase.initializeApp();
    getIt.registerSingleton<QuotationService>(QuotationService());
  }
}
