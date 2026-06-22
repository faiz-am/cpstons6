import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:sehat_app/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import 'profile_settings_view.dart';
import 'privacy_security_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final controller = Get.put(SettingsController());

    return Obx(() {
      final isDark = controller.isDarkModeEnabled.value;
      final scaffoldBg = isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff);
      final cardBg = isDark ? const Color(0xff0f1524) : Colors.white;
      final textMain = isDark ? Colors.white : const Color(0xff0f172a);
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);
      final dividerCol = isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0);

      return Scaffold(
        backgroundColor: scaffoldBg,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final horizontal = w > 700 ? w * 0.12 : w * 0.05;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Kelola preferensi dan akun aplikasi.",
                      style: TextStyle(
                        fontSize: 14,
                        color: textMuted,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _sectionCard(
                      cardBg: cardBg,
                      children: [
                        _item(
                          icon: Icons.history,
                          title: "Riwayat",
                          textMain: textMain,
                          onTap: () {
                            Get.toNamed(Routes.RIWAYAT);
                          },
                        ),
                        _divider(dividerCol),
                        _item(
                          icon: Icons.person_outline,
                          title: "Profil",
                          textMain: textMain,
                          onTap: () {
                            Get.to(() => const ProfileSettingsView());
                          },
                        ),
                        _divider(dividerCol),
                        _item(
                          icon: Icons.security,
                          title: "Privasi & Keamanan",
                          textMain: textMain,
                          onTap: () {
                            Get.to(() => const PrivacySecurityView());
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _sectionCard(
                      cardBg: cardBg,
                      children: [
                        _switchItem(
                          icon: Icons.notifications_none,
                          title: "Notifikasi",
                          textMain: textMain,
                          value: controller.isNotificationEnabled.value,
                          onChanged: controller.toggleNotification,
                        ),
                        _divider(dividerCol),
                        _switchItem(
                          icon: Icons.dark_mode_outlined,
                          title: "Dark Mode",
                          textMain: textMain,
                          value: controller.isDarkModeEnabled.value,
                          onChanged: controller.toggleDarkMode,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _sectionCard(
                      cardBg: cardBg,
                      children: [
                        _logoutItem(
                          onTap: () {
                            auth.logout();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _sectionCard({
    required Color cardBg,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required Color textMain,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xffdbeafe),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xff2563eb),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textMain,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xff94a3b8),
      ),
      onTap: onTap,
    );
  }

  Widget _switchItem({
    required IconData icon,
    required String title,
    required Color textMain,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xffdbeafe),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xff2563eb),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textMain,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xff2563eb),
      ),
    );
  }

  Widget _logoutItem({
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xfffee2e2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.logout,
          color: Colors.red,
          size: 20,
        ),
      ),
      title: const Text(
        "Logout",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.red,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _divider(Color dividerCol) {
    return Divider(
      height: 1,
      color: dividerCol,
    );
  }
}