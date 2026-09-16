import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';

import '../../controller/user_controller.dart';
import '../../model/user_model.dart';
import 'package:pro_23/screen/register/register_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserController controller = Get.put(UserController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final nearBottom =
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200;
      if (nearBottom) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        backgroundColor: AppColor.primaryLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => Get.to(() => const RegisterScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty && controller.users.isEmpty) {
          return Center(
            child: Text(controller.errorMessage.value, style: AppTextStyle.error),
          );
        }

        if (controller.users.isEmpty) {
          return Center(
            child: Text('No users yet'.tr, style: AppTextStyle.caption),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount:
          controller.users.length + (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.users.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final UserModel user = controller.users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.primaryLight.withOpacity(0.15),
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: AppTextStyle.heading.copyWith(
                      color: AppColor.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                title: Text(user.username, style: AppTextStyle.body),
                subtitle: Text(user.email, style: AppTextStyle.caption),
              ),
            );
          },
        );
      }),
    );
  }
}