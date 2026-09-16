import 'package:get/get.dart';
import 'package:pro_23/controller/post_controller.dart';
import 'package:pro_23/service/storage_service.dart';

import 'package:pro_23/repository/post_repository.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<PostRepository>(() => PostRepository());

  }
}