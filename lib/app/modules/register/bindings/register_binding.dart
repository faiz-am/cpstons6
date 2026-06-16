import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class RegisterBinding extends Bindings {

  @override
  void dependencies() {
<<<<<<< HEAD
    // Gunakan instance yang sudah ada dari main.dart
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController());
    }
=======

    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
  }
}
