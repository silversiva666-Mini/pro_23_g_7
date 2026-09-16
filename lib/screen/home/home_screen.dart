import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/controller/home_controller.dart';
import 'package:pro_23/controller/language_controller.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';

import '../../model/post_model.dart';
import '../../model/slider_model.dart';

/// Same screen as [HomeScreen], but `banners` and `latestPosts` now live in
/// [HomeController1] instead of being fields on the widget.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No binding for this route — the screen creates the controller itself.
    // `Get.put` returns the existing instance on rebuild, so this is safe here.
    final HomeController controller = Get.put(HomeController());

    final LanguageController languageController =
    Get.find<LanguageController>();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColor.primary,
              padding: const EdgeInsets.only(top: 50, left: 30, bottom: 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColor.surface,
                    child: Text(
                      'AD',
                      style: AppTextStyle.title.copyWith(
                        color: AppColor.primaryDark,
                        fontSize: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  Text(
                    'getx_basic'.tr,
                    style: AppTextStyle.title.copyWith(
                      color: AppColor.surface,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'admin@example.com',
                    style: AppTextStyle.body.copyWith(
                      color: AppColor.surface,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.people_outline),

              title: Text('Users'.tr),

              onTap: () {},
            ),

            // ===================================================
            // NEW USER
            // ===================================================
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),

              title: Text('New user'.tr),

              onTap: () {},
            ),

            const Divider(),

            // ===================================================
            // LANGUAGE
            // ===================================================
            ListTile(
              leading: const Icon(Icons.translate),

              title: Text('language'.tr),

              trailing: Text(
                languageController.currentLanguage == 'km'
                    ? 'khmer'.tr
                    : 'english'.tr,

                style: AppTextStyle.caption.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Click Language
              onTap: () {
                _showLanguageDialog(languageController);
              },
            ),

            // ===================================================
            // CONNECTION
            // ===================================================
            ListTile(
              leading: const Icon(Icons.signal_cellular_alt),

              title: Text('Connection'.tr),

              trailing: Text(
                'Online'.tr,

                style: AppTextStyle.caption.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),
            const Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: AppColor.danger),

              title: Text(
                'Logout'.tr,
                style: AppTextStyle.error,
              ),

              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        title: Text('Home'.tr),

        backgroundColor: AppColor.primaryLight,
      ),
      // =========================
      // Body
      // =========================
      body: SafeArea(
        child: Obx(() {
          // =========================
          // Loading
          // =========================
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 20),

            children: <Widget>[
              // =========================
              // Carousel
              // =========================
              CarouselSlider(
                items: controller.banners.map((SliderModel banner) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.primaryLight,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        // =========================
                        // Image
                        // =========================
                        Image.network(
                          banner.fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                            );
                          },
                        ),

                        // =========================
                        // Dark Overlay
                        // =========================
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.transparent,
                                AppColor.textPrimary.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),

                        // =========================
                        // Banner Text
                        // =========================
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                banner.title,
                                style: AppTextStyle.heading.copyWith(
                                  color: AppColor.surface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              if (banner.subtitle != null &&
                                  banner.subtitle!.isNotEmpty)
                                Text(
                                  banner.subtitle!,
                                  style: AppTextStyle.caption.copyWith(
                                    color: AppColor.surface.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                options: CarouselOptions(
                  height: 190,
                  viewportFraction: 0.88,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: true,
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // Latest Posts Title
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Latest Posts'.tr,
                  style: AppTextStyle.heading.copyWith(fontSize: 20),
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // Post List
              // =========================
              ...controller.latestPosts.map((PostModel post) {
                final String url = post.fullImageUrl;

                return Card(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        // =========================
                        // Post Image
                        // =========================
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return ColoredBox(
                                  color: AppColor.primaryLight,
                                  child: const Icon(Icons.article_outlined),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // =========================
                        // Post Information
                        // =========================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                post.title,
                                style: AppTextStyle.heading.copyWith(
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                post.author?.displayName ?? 'Unknown',
                                style: AppTextStyle.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  void _showLanguageDialog(LanguageController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('language'.tr),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // ENGLISH
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text('english'.tr),
              onTap: () {
                controller.changeLanguage('en');
                Get.back();
              },
            ),

            // KHMER
            ListTile(
              leading: const Text('🇰🇭', style: TextStyle(fontSize: 24)),

              title: Text('khmer'.tr),

              onTap: () {
                controller.changeLanguage('km');

                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}