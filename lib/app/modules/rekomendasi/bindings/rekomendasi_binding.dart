import 'package:get/get.dart';

import '../controllers/rekomendasi_controller.dart';

class RekomendasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekomendasiController>(
      () => RekomendasiController(),
    );
  }
}
