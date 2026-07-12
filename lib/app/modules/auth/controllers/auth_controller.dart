import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart'; // Import ApiService kamu

const String _webClientId = '875638165481-hpnqk2mjsj1mguen4tl4blpfudk2tqfu.apps.googleusercontent.com';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  // MEMPERBAIKAI: Panggil instansi ApiService global
  final ApiService _api = Get.find<ApiService>();

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  RxString userEmail = "".obs;

  String? token;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    token = await storage.read(key: "token");
    isLoggedIn.value = token != null;
    if (isLoggedIn.value) {
      userEmail.value = await storage.read(key: "username") ?? "";
    }
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;

      // MEMPERBAIKAI: Ambil nilai baseUrl otomatis dari ApiService
      final response = await http.post(
        Uri.parse("${_api.baseUrl}/api/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        token = data['token'];
        await storage.write(key: "token", value: token);
        await storage.write(key: "username", value: username);

        userEmail.value = username;
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
  // REGISTER
  // =========================
  Future<bool> register(String username, String password) async {
    try {
      isLoading.value = true;

      // MEMPERBAIKAI: Ambil nilai baseUrl otomatis dari ApiService
      final response = await http.post(
        Uri.parse("${_api.baseUrl}/api/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        Get.toNamed(Routes.VERIFY_OTP, arguments: username);
        return true;
      } else {
        Get.snackbar(
          "Gagal",
          data['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
  // VERIFY OTP
  // =========================
  Future<void> verifyOTP(String username, String otp) async {
    try {
      isLoading.value = true;

      // MEMPERBAIKAI: Ambil nilai baseUrl otomatis dari ApiService
      final response = await http.post(
        Uri.parse("${_api.baseUrl}/api/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        Get.snackbar(
          "Berhasil! ✅",
          "Email terverifikasi. Silakan login.",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          "Kode OTP Salah",
          data['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // GOOGLE SIGN-IN
  // =========================
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? _webClientId : null,
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Get.snackbar("Error", "Gagal mendapatkan data pengguna Google.");
        isLoading.value = false;
        return;
      }

      final String? idToken = await firebaseUser.getIdToken();
      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token autentikasi.");
        isLoading.value = false;
        return;
      }

      // MEMPERBAIKAI: Ambil nilai baseUrl otomatis dari ApiService
      final response = await http.post(
        Uri.parse("${_api.baseUrl}/api/firebase-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_token": idToken,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        token = data['token'];
        await storage.write(key: "token", value: token);

        if (firebaseUser.email != null) {
          await storage.write(key: "username", value: firebaseUser.email);
          userEmail.value = firebaseUser.email!;
        }

        isLoggedIn.value = true;
        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        Get.snackbar("Error", data['message'] ?? "Sinkronisasi backend gagal.");
      }
    } catch (e) {
      Get.snackbar("Error", "Google login gagal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await storage.delete(key: "token");
    await storage.delete(key: "username");

    userEmail.value = "";
    token = null;
    isLoggedIn.value = false;

    Get.offAllNamed(Routes.LOGIN);
  }
}