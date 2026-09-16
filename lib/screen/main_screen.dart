import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/screen/home/home_screen.dart';
import 'package:pro_23/screen/post/post_list_screen.dart';
import 'package:pro_23/screen/post/post_screen.dart';
import 'package:pro_23/screen/setting/setting_screen.dart';
import 'package:pro_23/screen/user/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [HomeScreen(), PostListScreen(), UserScreen(), SettingScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: AppColor.primary,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColor.surface),
            label: 'Home'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article, color: AppColor.surface),
            label: 'Post'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person, color: AppColor.surface),
            label: 'User'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppColor.surface),
            label: 'Setting'.tr,
          ),
        ],
      ),
    );
  }
}