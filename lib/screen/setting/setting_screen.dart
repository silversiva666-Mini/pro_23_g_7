import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.surface,
        elevation: 0,
        surfaceTintColor: AppColor.surface,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // PROFILE CARD
            // =================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColor.surface,
                    child: Text(
                      'AD',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            color: AppColor.textDisabled,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Admin',
                          style: TextStyle(
                            color: AppColor.surface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          'admin@example.com',
                          style: TextStyle(
                            color: AppColor.textDisabled,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =================================================
            // ACCOUNT
            // =================================================
            _sectionTitle('Account'),

            const SizedBox(height: 8),

            _settingItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColor.textSecondary,
              ),
              onTap: () {
                // TODO: Edit Profile
              },
            ),

            const SizedBox(height: 22),

            // =================================================
            // PREFERENCES
            // =================================================
            _sectionTitle('Preferences'),

            const SizedBox(height: 8),

            _settingItem(
              icon: Icons.translate,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: AppColor.textSecondary,
                  ),
                ],
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),

            _settingItem(
              icon: Icons.wifi,
              title: 'Network',
              subtitle: 'Internet connection status',
              trailing: const Text(
                'Connected',
                style: TextStyle(
                  color: AppColor.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {},
            ),

            const SizedBox(height: 22),

            // =================================================
            // ABOUT
            // =================================================
            _sectionTitle('About'),

            const SizedBox(height: 8),

            _settingItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Application information',
              trailing: const Text(
                '1.0.0',
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12,
                ),
              ),
              onTap: () {},
            ),

            const SizedBox(height: 28),

            // =================================================
            // LOGOUT
            // =================================================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog();
                },
                icon: const Icon(
                  Icons.logout,
                  color: AppColor.surface,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColor.surface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.danger,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================
  Widget _sectionTitle(String title) {
    return const Padding(
      padding: EdgeInsets.only(left: 4),
      child: SizedBox(),
    ).copyWithTitle(title);
  }

  // ==========================================================
  // SETTING ITEM
  // ==========================================================
  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      ),

      leading: Icon(
        icon,
        color: AppColor.textSecondary,
        size: 22,
      ),

      title: Text(
        title,
        style: const TextStyle(
          color: AppColor.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColor.textSecondary,
          fontSize: 11,
        ),
      ),

      trailing: trailing,
      onTap: onTap,
    );
  }

  // ==========================================================
  // LANGUAGE
  // ==========================================================
  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Language',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: AppColor.primary,
                ),
                title: const Text('English'),
                onTap: () {
                  Get.updateLocale(
                    const Locale('en', 'US'),
                  );

                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: AppColor.primary,
                ),
                title: const Text('Khmer'),
                onTap: () {
                  Get.updateLocale(
                    const Locale('km', 'KH'),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================
  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: AppColor.surface,
      buttonColor: AppColor.danger,

      onConfirm: () {
        Get.back();

        // TODO: Clear login token

        Get.offAllNamed('/login');
      },
    );
  }
}

// ============================================================
// Helper for section title
// ============================================================
extension SectionTitleExtension on Widget {
  Widget copyWithTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColor.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}