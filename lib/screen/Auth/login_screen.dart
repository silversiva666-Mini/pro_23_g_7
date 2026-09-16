import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';

import '../../controller/auth_controller.dart';
import 'package:pro_23/screen/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.find<AuthController>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.textPrimary.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lock icon in a tinted circle
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColor.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'សូមស្វាគមន៍ការត្រឡប់មកវិញ',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.title.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ចូលទៅគណនីរបស់អ្នក',
                    style: AppTextStyle.caption,
                  ),
                  const SizedBox(height: 28),

                  // Username / Email label + field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ឈ្មោះអ្នកប្រើប្រាស់'.tr,
                      style: AppTextStyle.caption,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.usernameController,
                    decoration: InputDecoration(
                      hintText: 'admin@example.com',
                      hintStyle: TextStyle(color: AppColor.textDisabled),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: AppColor.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColor.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.primary),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password label + field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ពាក្យសម្ងាត់'.tr,
                      style: AppTextStyle.caption,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(color: AppColor.textDisabled),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColor.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColor.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColor.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.primary),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  // Error message
                  Obx(() {
                    if (controller.errorMessage.value.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          controller.errorMessage.value,
                          style: AppTextStyle.error,
                        ),
                      );
                    }
                    return const SizedBox();
                  }),

                  const SizedBox(height: 24),

                  // Log In button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                          () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.surface,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login,
                              size: 18,
                              color: AppColor.surface,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ចូលទៅប្រើប្រាស់'.tr,
                              style: AppTextStyle.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sign-up link
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const RegisterScreen());
                    },
                    child: Text(
                      'មិនទាន់មានគណនីមែនទេ? ចុះឈ្មោះ'.tr,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}