import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/service/storage_service.dart';

class LanguageController extends GetxController {

  final StorageService _storageService = Get.find<StorageService>();

  // Current language
  String get currentLanguage {
    return Get.locale?.languageCode == 'km'
        ? 'km'
        : 'en';
  }
  Future<void> changeLanguage(String languageCode) async {


    final String language =
    languageCode == 'km' ? 'km' : 'en';


    await _storageService.saveString(
      'language',
      language,
    );

    // Update the app language immediately.
    if (language == 'km') {
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