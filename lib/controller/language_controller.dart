import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {

  // Current language
  String get currentLanguage {
    return Get.locale?.languageCode == 'km'
        ? 'km'
        : 'en';
  }

  void changeLanguage(String languageCode) {

    if (languageCode == 'km') {
      Get.updateLocale(
        const Locale('km', 'KH'),
      );
    } else {
      Get.updateLocale(
        const Locale('en', 'US'),
      );
    }
  }
}