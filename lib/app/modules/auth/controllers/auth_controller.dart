import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {

  final storage = const FlutterSecureStorage();

  final String baseUrl = "http://192.168.1.5:5000";

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  String? token;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {

    token = await storage.read(key: "token");

    isLoggedIn.value = token != null;
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login(String username, String password) async {

    try {

      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {

        token = data['token'];

        await storage.write(
          key: "token",
          value: token,
        );

        isLoggedIn.value = true;

        Get.offAllNamed(Routes.MAIN_NAV);

      } else {

        Get.snackbar("Error", data['message']);
      }

    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // REGISTER (FIXED)
  // =========================
  Future<bool> register(String username, String password) async {

    try {

      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {

        Get.snackbar("Success", data['message']);
        return true;

      } else {

        Get.snackbar("Error", data['message']);
        return false;
      }

    } catch (e) {

      Get.snackbar("Error", e.toString());
      return false;

    } finally {

      isLoading.value = false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {

    await storage.delete(key: "token");

    token = null;
    isLoggedIn.value = false;

    Get.offAllNamed(Routes.LOGIN);
  }
}