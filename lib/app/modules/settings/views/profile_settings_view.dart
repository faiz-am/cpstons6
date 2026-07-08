import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  bool isEditingPersonal = false;
  bool isEditingPhysical = false;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final email = auth.userEmail.value;
      if (email.isEmpty) return;

      final name = await auth.storage.read(key: "${email}_profile_name") ?? "";
      final phone = await auth.storage.read(key: "${email}_profile_phone") ?? "";
      final age = await auth.storage.read(key: "${email}_profile_age") ?? "";
      final height = await auth.storage.read(key: "${email}_profile_height") ?? "";
      final weight = await auth.storage.read(key: "${email}_profile_weight") ?? "";
      final imageBase64 = await auth.storage.read(key: "${email}_profile_image") ?? "";

      setState(() {
        nameController.text = name;
        phoneController.text = phone;
        ageController.text = age;
        heightController.text = height;
        weightController.text = weight;
        _base64Image = imageBase64.isNotEmpty ? imageBase64 : null;
      });
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  Future<void> _saveProfileData() async {
    try {
      setState(() => _isLoading = true);

      final email = auth.userEmail.value;
      if (email.isEmpty) {
        throw Exception("Email pengguna tidak ditemukan. Silakan login kembali.");
      }

      await auth.storage.write(key: "${email}_profile_name", value: nameController.text.trim());
      await auth.storage.write(key: "${email}_profile_phone", value: phoneController.text.trim());
      await auth.storage.write(key: "${email}_profile_age", value: ageController.text.trim());
      await auth.storage.write(key: "${email}_profile_height", value: heightController.text.trim());
      await auth.storage.write(key: "${email}_profile_weight", value: weightController.text.trim());

      if (_base64Image != null) {
        await auth.storage.write(key: "${email}_profile_image", value: _base64Image);
      }

      setState(() {
        _isLoading = false;
        isEditingPersonal = false;
        isEditingPhysical = false;
      });

      Get.snackbar(
        "Profil Disimpan",
        "Perubahan profil Anda berhasil disimpan secara aman.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff10b981),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        "Gagal Menyimpan",
        "Terjadi kesalahan saat menyimpan data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 70,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Str = base64Encode(bytes);
        setState(() {
          _base64Image = base64Str;
        });

        final email = auth.userEmail.value;
        if (email.isNotEmpty) {
          await auth.storage.write(key: "${email}_profile_image", value: base64Str);
        }

        Get.snackbar(
          "Foto Diperbarui",
          "Foto profil berhasil diperbarui.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff10b981),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal Memilih Foto",
        "Terjadi kesalahan saat memilih foto: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  ImageProvider _getProfileImageProvider() {
    if (_base64Image != null && _base64Image!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(_base64Image!));
      } catch (e) {
        print("Error decoding base64 image: $e");
      }
    }
    return const AssetImage("images/default_avatar.png");
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
                        image: DecorationImage(
                          image: _getProfileImageProvider(),
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
                        onTap: _pickImage,
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

              // Card 1: Informasi Pribadi
              _buildCard(
                isDark: isDark,
                child: isEditingPersonal 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Edit Informasi Pribadi",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isEditingPersonal = false;
                                  _loadProfileData(); // Reset data jika batal
                                });
                              },
                              child: const Text("Batal", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Informasi Pribadi",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isEditingPersonal = true;
                                });
                              },
                              icon: const Icon(Icons.edit_outlined, color: Color(0xff2563eb), size: 20),
                              tooltip: "Edit Informasi Pribadi",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildDisplayRow(
                          label: "Nama Lengkap",
                          value: nameController.text.isNotEmpty ? nameController.text : "Belum diisi",
                          icon: Icons.person_outline,
                          isDark: isDark,
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildDisplayRow(
                          label: "Nomor Telepon",
                          value: phoneController.text.isNotEmpty ? phoneController.text : "Belum diisi",
                          icon: Icons.phone_outlined,
                          isDark: isDark,
                        ),
                      ],
                    ),
              ),

              const SizedBox(height: 18),

              // Card 2: Data Fisik & Kesehatan
              _buildCard(
                isDark: isDark,
                child: isEditingPhysical
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Edit Data Fisik & Kesehatan",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isEditingPhysical = false;
                                  _loadProfileData(); // Reset data jika batal
                                });
                              },
                              child: const Text("Batal", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Data Fisik & Kesehatan",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2563eb),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isEditingPhysical = true;
                                });
                              },
                              icon: const Icon(Icons.edit_outlined, color: Color(0xff2563eb), size: 20),
                              tooltip: "Edit Data Fisik",
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatDisplay(
                              label: "Umur",
                              value: ageController.text.isNotEmpty ? "${ageController.text} Tahun" : "-",
                              icon: Icons.calendar_today_outlined,
                              isDark: isDark,
                            ),
                            _buildStatDisplay(
                              label: "Tinggi",
                              value: heightController.text.isNotEmpty ? "${heightController.text} Cm" : "-",
                              icon: Icons.height,
                              isDark: isDark,
                            ),
                            _buildStatDisplay(
                              label: "Berat",
                              value: weightController.text.isNotEmpty ? "${weightController.text} Kg" : "-",
                              icon: Icons.monitor_weight_outlined,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
              ),

              const SizedBox(height: 30),

              // Action button (selalu dapat diklik)
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

  Widget _buildDisplayRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xff2563eb), size: 22),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xff0f172a),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatDisplay({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff080c14) : const Color(0xfff8fafc),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xff2563eb), size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xff0f172a),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
