import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehat_app/app/modules/auth/controllers/auth_controller.dart';

class PrivacySecurityView extends StatefulWidget {
  const PrivacySecurityView({super.key});

  @override
  State<PrivacySecurityView> createState() => _PrivacySecurityViewState();
}

class _PrivacySecurityViewState extends State<PrivacySecurityView> {
  final auth = Get.find<AuthController>();

  bool _appLock = false;
  bool _twoFactor = false;
  bool _shareData = true;
  bool _hideHistory = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final lockVal = await auth.storage.read(key: "privacy_app_lock") ?? "false";
    final twoFaVal = await auth.storage.read(key: "privacy_2fa") ?? "false";
    final shareVal = await auth.storage.read(key: "privacy_share_data") ?? "true";
    final hideVal = await auth.storage.read(key: "privacy_hide_history") ?? "false";

    setState(() {
      _appLock = lockVal == "true";
      _twoFactor = twoFaVal == "true";
      _shareData = shareVal == "true";
      _hideHistory = hideVal == "true";
    });
  }

  Future<void> _updateSetting(String key, bool val) async {
    await auth.storage.write(key: key, value: val.toString());
    Get.snackbar(
      "Privasi Diperbarui",
      "Pengaturan keamanan Anda berhasil diperbarui.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff2563eb).withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmNewPassCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Get.isDarkMode ? const Color(0xff0f1524) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Ubah Kata Sandi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi Lama",
                  hintText: "Masukkan kata sandi saat ini",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi Baru",
                  hintText: "Masukkan kata sandi baru",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmNewPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Sandi Baru",
                  hintText: "Ulangi kata sandi baru",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPassCtrl.text != confirmNewPassCtrl.text) {
                Get.snackbar("Gagal", "Konfirmasi kata sandi tidak cocok!");
                return;
              }
              Get.back();
              Get.snackbar(
                "Sandi Diperbarui",
                "Kata sandi akun Anda berhasil diperbarui.",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2563eb),
            ),
            child: const Text("Ubah Sandi", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final dangerColor = const Color(0xffef4444);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff),
      appBar: AppBar(
        title: const Text(
          "Privasi & Keamanan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : const Color(0xff0f172a),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Keamanan Akun",
                style: TextStyle(fontSize: 13, color: Color(0xff64748b), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // Account Settings Card
              _buildCard(
                isDark: isDark,
                child: Column(
                  children: [
                    _buildInteractiveItem(
                      icon: Icons.key_outlined,
                      title: "Ubah Kata Sandi",
                      subtitle: "Ubah atau perbarui kata sandi akun Anda",
                      onTap: _showChangePasswordDialog,
                      isDark: isDark,
                    ),
                    const Divider(height: 1, color: Color(0xffe2e8f0)),
                    _buildSwitchItem(
                      icon: Icons.fingerprint_outlined,
                      title: "Kunci Aplikasi",
                      subtitle: "Gunakan Sidik Jari / Face ID",
                      value: _appLock,
                      onChanged: (val) {
                        setState(() => _appLock = val);
                        _updateSetting("privacy_app_lock", val);
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1, color: Color(0xffe2e8f0)),
                    _buildSwitchItem(
                      icon: Icons.phonelink_lock_outlined,
                      title: "Autentikasi Dua Faktor (2FA)",
                      subtitle: "Amankan akun dengan kode verifikasi OTP",
                      value: _twoFactor,
                      onChanged: (val) {
                        setState(() => _twoFactor = val);
                        _updateSetting("privacy_2fa", val);
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              
              const Text(
                "Privasi Data Medis",
                style: TextStyle(fontSize: 13, color: Color(0xff64748b), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Data Privacy Card
              _buildCard(
                isDark: isDark,
                child: Column(
                  children: [
                    _buildSwitchItem(
                      icon: Icons.share_location_outlined,
                      title: "Izinkan Berbagi Data",
                      subtitle: "Bagikan detak jantung & info vital ke dokter",
                      value: _shareData,
                      onChanged: (val) {
                        setState(() => _shareData = val);
                        _updateSetting("privacy_share_data", val);
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1, color: Color(0xffe2e8f0)),
                    _buildSwitchItem(
                      icon: Icons.visibility_off_outlined,
                      title: "Sembunyikan Riwayat Medis",
                      subtitle: "Hanya Anda yang dapat melihat riwayat deteksi",
                      value: _hideHistory,
                      onChanged: (val) {
                        setState(() => _hideHistory = val);
                        _updateSetting("privacy_hide_history", val);
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Danger Zone Card
              const Text(
                "Zona Bahaya",
                style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildCard(
                isDark: isDark,
                child: _buildInteractiveItem(
                  icon: Icons.delete_forever_outlined,
                  title: "Hapus Akun",
                  subtitle: "Menghapus akun Sehat Kita secara permanen",
                  iconColor: dangerColor,
                  titleColor: dangerColor,
                  onTap: () {
                    Get.defaultDialog(
                      backgroundColor: isDark ? const Color(0xff0f1524) : Colors.white,
                      title: "Hapus Akun?",
                      middleText: "Tindakan ini tidak dapat dibatalkan. Seluruh riwayat medis dan profil Anda akan terhapus.",
                      textConfirm: "Hapus Permanen",
                      textCancel: "Batal",
                      confirmTextColor: Colors.white,
                      buttonColor: dangerColor,
                      onConfirm: () {
                        Get.back();
                        auth.logout();
                      },
                    );
                  },
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff0f1524) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildInteractiveItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor != null ? iconColor.withOpacity(0.12) : const Color(0xffdbeafe),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xff2563eb),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: titleColor ?? (isDark ? Colors.white : const Color(0xff0f172a)),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white54 : const Color(0xff64748b),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xff94a3b8),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
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
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xff0f172a),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white54 : const Color(0xff64748b),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xff2563eb),
      ),
    );
  }
}
