import 'package:get/get.dart';

import '../service/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
  }
}