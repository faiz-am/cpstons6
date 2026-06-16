import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehat_app/app/modules/auth/controllers/auth_controller.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final auth = Get.find<AuthController>();
  
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await auth.storage.read(key: "profile_name") ?? "";
    final phone = await auth.storage.read(key: "profile_phone") ?? "";
    final age = await auth.storage.read(key: "profile_age") ?? "";
    final height = await auth.storage.read(key: "profile_height") ?? "";
    final weight = await auth.storage.read(key: "profile_weight") ?? "";

    setState(() {
      nameController.text = name;
      phoneController.text = phone;
      ageController.text = age;
      heightController.text = height;
      weightController.text = weight;
    });
  }

  Future<void> _saveProfileData() async {
    setState(() => _isLoading = true);

    await auth.storage.write(key: "profile_name", value: nameController.text.trim());
    await auth.storage.write(key: "profile_phone", value: phoneController.text.trim());
    await auth.storage.write(key: "profile_age", value: ageController.text.trim());
    await auth.storage.write(key: "profile_height", value: heightController.text.trim());
    await auth.storage.write(key: "profile_weight", value: weightController.text.trim());

    setState(() => _isLoading = false);

    Get.snackbar(
      "Profil Disimpan",
      "Perubahan profil Anda berhasil disimpan secara aman.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff10b981),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final primaryColor = const Color(0xff2563eb);
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff),
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
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
            children: [
              // Profile Photo Card
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 16,
                            spreadRadius: 2,
                          )
                        ],
                        image: const DecorationImage(
                          image: AssetImage("images/default_avatar.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          Get.snackbar(
                            "Ganti Foto",
                            "Unggah foto profil didukung di platform web/ponsel Anda.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: primaryColor,
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? const Color(0xff080c14) : Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Email Text (Read-Only)
              Obx(() => Text(
                auth.userEmail.value.isNotEmpty ? auth.userEmail.value : "user@sehatkita.com",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xff64748b),
                ),
              )),
              
              const SizedBox(height: 25),

              // Form fields
              _buildCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: "Nama Lengkap",
                      controller: nameController,
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 18),
                    _buildInputField(
                      label: "Nomor Telepon",
                      controller: phoneController,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Health Stats Card
              _buildCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data Fisik & Kesehatan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2563eb),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: "Umur (Tahun)",
                            controller: ageController,
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            label: "Tinggi (Cm)",
                            controller: heightController,
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            label: "Berat (Kg)",
                            controller: weightController,
                            icon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfileData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined),
                            SizedBox(width: 8),
                            Text(
                              "Simpan Perubahan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
      padding: const EdgeInsets.all(20),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : const Color(0xff64748b),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xff0f172a),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xff2563eb), size: 18),
            hintText: "Isi ${label.toLowerCase()}",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: isDark ? const Color(0xff080c14) : const Color(0xfff8fafc),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xff1e293b) : const Color(0xffcbd5e1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff2563eb),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
