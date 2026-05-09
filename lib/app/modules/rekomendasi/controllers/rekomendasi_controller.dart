import 'package:get/get.dart';

class RekomendasiController extends GetxController {
  var data = {}.obs;

  @override
  void onInit() {
    data.value = Get.arguments ?? {};
    super.onInit();
  }

  int get kalori => 1500;

  String get saran {
    switch (data["penyakit"]) {
      case "Diabetes":
        return "Kurangi gula";
      case "Hipertensi":
        return "Kurangi garam";
      case "Obesitas":
        return "Kurangi kalori";
      default:
        return "Sehat 👍";
    }
  }
}