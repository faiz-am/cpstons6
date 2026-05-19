import 'package:get/get.dart';

class ScanController extends GetxController {

  var foodName = "Belum ada makanan".obs;
  var calories = "0 kcal".obs;
  var status = "Belum dianalisis".obs;

  var recommendation =
      "Upload foto makanan untuk mulai analisis."
          .obs;

  void mockScan() {

    foodName.value = "Bakso";
    calories.value = "220 kcal";
    status.value = "Tidak Cocok";

    recommendation.value =
        "Bakso memiliki sodium tinggi sehingga kurang baik untuk penderita hipertensi.";
  }
}