import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/services/customer_service.dart';
import 'package:solar_warehouse_system/services/product_service.dart';
import 'package:solar_warehouse_system/services/quotation_service.dart';
import 'package:solar_warehouse_system/services/uploader_service.dart';

class Services {
  final getIt = GetIt.instance;

  Future<void> setup() async {
    await Firebase.initializeApp();
    getIt.registerSingleton<QuotationService>(QuotationService());
    getIt.registerSingleton<ProductService>(ProductService());
    getIt.registerSingleton<CustomerService>(CustomerService());
    getIt.registerSingleton<UploaderService>(UploaderService());
  }
}
