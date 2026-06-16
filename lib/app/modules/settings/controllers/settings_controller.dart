<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isNotificationEnabled = true.obs;
  RxBool isDarkModeEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with current Get theme mode
    isDarkModeEnabled.value = Get.isDarkMode;
  }

  void toggleNotification(bool val) {
    isNotificationEnabled.value = val;
    Get.snackbar(
      "Notifikasi",
      val ? "Notifikasi diaktifkan" : "Notifikasi dinonaktifkan",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: val ? Colors.green.withOpacity(0.8) : Colors.grey.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleDarkMode(bool val) {
    isDarkModeEnabled.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    Get.snackbar(
      "Tema Aplikasi",
      val ? "Dark Mode diaktifkan" : "Light Mode diaktifkan",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff2563eb).withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
=======
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
}
