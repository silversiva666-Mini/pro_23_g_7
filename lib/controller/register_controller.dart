import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/auth_repository.dart';
import 'user_controller.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> register() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required'.tr;
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final (user, error) = await _authRepository.register(
      email: email,
      password: password,
      referralCode: referralCodeController.text.trim().isEmpty
          ? null
          : referralCodeController.text.trim(),
    );

    isLoading.value = false;

    if (error != null || user == null) {
      errorMessage.value = error ?? 'Registration failed';
      return;
    }

    // This is the step that makes the new account show up in UserScreen:
    // both screens share the same UserController instance via Get.find.
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().addUser(user);
    }

    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    referralCodeController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}