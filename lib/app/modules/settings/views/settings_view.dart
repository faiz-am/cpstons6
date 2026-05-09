import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:sehat_app/app/modules/auth/controllers/auth_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
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
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f172a),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Kelola preferensi dan akun aplikasi.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _sectionCard(
                    children: [
                      _item(
                        icon: Icons.history,
                        title: "Riwayat",
                        onTap: () {
                          Get.toNamed(Routes.RIWAYAT);
                        },
                      ),
                      _divider(),
                      _item(
                        icon: Icons.person_outline,
                        title: "Profil",
                        onTap: () {},
                      ),
                      _divider(),
                      _item(
                        icon: Icons.security,
                        title: "Privasi & Keamanan",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Preferences",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _sectionCard(
                    children: [
                      _switchItem(
                        icon: Icons.notifications_none,
                        title: "Notifikasi",
                        value: true,
                      ),
                      _divider(),
                      _switchItem(
                        icon: Icons.dark_mode_outlined,
                        title: "Dark Mode",
                        value: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _sectionCard(
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
  }

  Widget _sectionCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xff0f172a),
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
    required bool value,
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
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (_) {},
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

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Color(0xffe2e8f0),
    );
  }
}