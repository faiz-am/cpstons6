import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoggedIn.value = true;
      Get.offAllNamed('/main-nav');
    } else {
      Get.snackbar("Error", "Email & Password wajib diisi");
    }
  }

  void register(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      Get.snackbar("Success", "Register berhasil");
      Get.back();
    } else {
      Get.snackbar("Error", "Data tidak boleh kosong");
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}