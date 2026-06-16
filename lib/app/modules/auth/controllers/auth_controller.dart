import 'dart:convert';

<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';

// =====================================================================
// PENTING: Ganti nilai di bawah dengan Web Client ID dari Firebase
// Console Anda:
// Firebase Console → Project Settings → General → Web API Key
// atau Google Cloud Console → APIs & Credentials → OAuth 2.0 Client IDs
// Pilih tipe "Web application" dan salin Client ID-nya
// =====================================================================
const String _webClientId =
    '875638165481-hpnqk2mjsj1mguen4tl4blpfudk2tqfu.apps.googleusercontent.com';

=======
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../routes/app_pages.dart';

>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
class AuthController extends GetxController {

  final storage = const FlutterSecureStorage();

<<<<<<< HEAD
  final String baseUrl = "http://127.0.0.1:5000";

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  RxString userEmail = "".obs;
=======
  final String baseUrl = "https://update-blatancy-comfort.ngrok-free.dev";

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af

  String? token;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {

    token = await storage.read(key: "token");

    isLoggedIn.value = token != null;
<<<<<<< HEAD
    if (isLoggedIn.value) {
      userEmail.value = await storage.read(key: "username") ?? "";
    }
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login(String username, String password) async {

    try {

      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/login"),
<<<<<<< HEAD
        headers: {
          "Content-Type": "application/json",
        },
=======
        headers: {"Content-Type": "application/json"},
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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

<<<<<<< HEAD
        await storage.write(
          key: "username",
          value: username,
        );

        userEmail.value = username;
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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
<<<<<<< HEAD
  // REGISTER
=======
  // REGISTER (FIXED)
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
  // =========================
  Future<bool> register(String username, String password) async {

    try {

      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/register"),
<<<<<<< HEAD
        headers: {
          "Content-Type": "application/json",
        },
=======
        headers: {"Content-Type": "application/json"},
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
<<<<<<< HEAD
        // Navigasi ke halaman verifikasi OTP, bawa email sebagai argument
        Get.toNamed(Routes.VERIFY_OTP, arguments: username);
        return true;
      } else {
        Get.snackbar(
          "Gagal",
          data['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
=======

        Get.snackbar("Success", data['message']);
        return true;

      } else {

        Get.snackbar("Error", data['message']);
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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
<<<<<<< HEAD
  // VERIFY OTP
  // =========================
  Future<void> verifyOTP(String username, String otp) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("$baseUrl/api/verify-otp"),
        headers: {
          "Content-Type": "application/json",
        },
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
        // Arahkan ke halaman login setelah verifikasi berhasil
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

      // 1. Jalankan Google Sign-In flow
      // Untuk Flutter Web, clientId WAJIB diisi
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? _webClientId : null,
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancel login
        isLoading.value = false;
        return;
      }

      // 2. Dapatkan autentikasi details dari request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Buat credential baru untuk Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Masuk ke Firebase dengan credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Get.snackbar("Error", "Gagal mendapatkan data pengguna Google.");
        isLoading.value = false;
        return;
      }

      // Dapatkan ID Token untuk dikirim ke backend
      final String? idToken = await firebaseUser.getIdToken();
      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token autentikasi.");
        isLoading.value = false;
        return;
      }

      // 5. Sinkronisasi dengan backend kita dengan ID Token
      final response = await http.post(
        Uri.parse("$baseUrl/api/firebase-login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id_token": idToken,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        token = data['token'];

        await storage.write(
          key: "token",
          value: token,
        );

        if (firebaseUser.email != null) {
          await storage.write(
            key: "username",
            value: firebaseUser.email,
          );
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
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
  // LOGOUT
  // =========================
  Future<void> logout() async {

    await storage.delete(key: "token");
<<<<<<< HEAD
    await storage.delete(key: "username");

    userEmail.value = "";
=======

>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
    token = null;
    isLoggedIn.value = false;

    Get.offAllNamed(Routes.LOGIN);
  }
}