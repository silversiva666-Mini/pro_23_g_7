import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';

import '../../controller/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'បង្កើតគណនីរបស់អ្នក'.tr,
          style: AppTextStyle.heading,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username / email
              Text('ឈ្មោះអ្នកប្រើប្រាស់ (អ៊ីមែល)'.tr, style: AppTextStyle.caption),
              const SizedBox(height: 6),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration(
                  hint: 'student@example.com',
                  icon: Icons.mail_outline,
                ),
              ),
              const SizedBox(height: 16),

              // Referral code (optional)
              Text('លេខកូដអញ្ជើញ (មិនចាំបាច់)'.tr, style: AppTextStyle.caption),
              const SizedBox(height: 6),
              TextField(
                controller: controller.referralCodeController,
                decoration: _fieldDecoration(
                  hint: 'ប្រសិនបើអ្នកមានលេខកូដពីមិត្តភក្តិ'.tr,
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Text('ពាក្យសម្ងាត់'.tr, style: AppTextStyle.caption),
              const SizedBox(height: 6),
              TextField(
                controller: controller.passwordController,
                obscureText: _obscurePassword,
                decoration: _fieldDecoration(
                  hint: 'Student@123',
                  icon: Icons.lock_outline,
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
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'យ៉ាងតិច ៨ តួអក្សរ ដោយមានអក្សរធំ អក្សរតូច លេខ និងសញ្ញាពិសេស។'.tr,
                style: AppTextStyle.caption,
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

              // Register button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                      () => ElevatedButton(
                    onPressed:
                    controller.isLoading.value ? null : controller.register,
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
                          Icons.person_add_alt_1,
                          size: 18,
                          color: AppColor.surface,
                        ),
                        const SizedBox(width: 8),
                        Text('ចុះឈ្មោះ'.tr, style: AppTextStyle.button),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColor.textDisabled),
      prefixIcon: Icon(icon, color: AppColor.textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColor.surface,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}