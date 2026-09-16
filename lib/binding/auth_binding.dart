import 'package:get/get.dart';
import 'package:pro_23/service/storage_service.dart';
import 'package:pro_23/controller/auth_controller.dart';
import 'package:pro_23/repository/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}