import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class LoginBinding extends Bindings {

  @override
  void dependencies() {
    // Gunakan instance yang sudah ada dari main.dart
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController());
    }
  }
}
