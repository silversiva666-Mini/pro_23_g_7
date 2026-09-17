import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pro_23/binding/auth_binding.dart';
import 'package:pro_23/controller/language_controller.dart';
import 'package:pro_23/controller/network_controller.dart';
import 'package:pro_23/core_translation/core_translation.dart';
import 'package:pro_23/screen/Auth/login_screen.dart';
import 'package:pro_23/screen/main_screen.dart';
import 'package:pro_23/screen/post/post_create.dart';
import 'package:pro_23/screen/post/post_list_screen.dart';
import 'package:pro_23/service/storage_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final StorageService storage = Get.put(
    StorageService(),
    permanent: true,
  );

  // Remember Login
  final String? token = await storage.getToken();

  final bool hasToken = token != null && token.isNotEmpty;

  // ✅ NEW: Read the language saved by the user.
  final String? savedLanguage =
  await storage.getString('language');

  // ✅ NEW: Default to English if no language was saved.
  final Locale initialLocale = savedLanguage == 'km'
      ? const Locale('km', 'KH')
      : const Locale('en', 'US');

  Get.put(LanguageController());

  Get.put<NetworkController>(
    NetworkController(),
    permanent: true,
  );

  // ✅ CHANGED: Pass the saved language to MyApp.
  runApp(
    MyApp(
      hasToken: hasToken,
      initialLocale: initialLocale,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasToken;

  // ✅ NEW: Receive the saved language.
  final Locale initialLocale;

  // ✅ CHANGED: Added initialLocale to the constructor.
  const MyApp({
    super.key,
    required this.hasToken,
    required this.initialLocale,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      translations: CoreTranslation(),

      // ✅ CHANGED: Use the saved language instead of always English.
      locale: initialLocale,

      // ✅ CHANGED: Use English as the fallback language.
      fallbackLocale: const Locale('en', 'US'),

      // Remember Login — unchanged.
      initialRoute: hasToken ? '/' : '/login',

      getPages: [
        GetPage(
          name: '/',
          page: () => const MainScreen(),
        ),

        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),

        GetPage(
          name: '/post_list',
          page: () => const PostListScreen(),
        ),

        GetPage(
          name: '/post_create',
          page: () => const PostCreateScreen(),
        ),
      ],

      // Internet checker — unchanged.
      builder: (context, child) {
        return InternetWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

// =====================================================
// INTERNET WRAPPER — UNCHANGED
// =====================================================

class InternetWrapper extends StatelessWidget {
  final Widget child;

  const InternetWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController =
    Get.find<NetworkController>();

    return Obx(() {
      return Stack(
        children: [
          // Your normal app
          child,

          // Show red banner when internet is OFF
          if (!networkController.isConnected.value)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Material(
                  color: Colors.red,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 28,
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

// =====================================================
// NO INTERNET SCREEN — UNCHANGED
// =====================================================

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 90,
                  color: Colors.grey,
                ),

                SizedBox(height: 20),

                Text(
                  'No internet connection',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Please connect to Wi-Fi or mobile data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}