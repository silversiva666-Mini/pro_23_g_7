import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/service/storage_service.dart';

import '../repository/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
    if (usernameController.text.trim().isEmpty) {
      errorMessage.value = 'Username is required';
      return;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password is required';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final (String? token, String? error) = await _authRepo.login(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (error != null) {
      errorMessage.value = error;
      return;
    }

    if (token == null) {
      errorMessage.value = 'Token not found';
      return;
    }
    await _storageService.saveString('token', token);
    print('LOGIN TOKEN: $token');

    // TODO:
    // Save token here

    Get.offAllNamed('/post-create');
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}