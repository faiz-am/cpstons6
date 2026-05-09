import 'package:get/get.dart';

class InsightController extends GetxController {
  final skorSehat = 82.obs;
  final kalori = "1,240 kcal".obs;
  final aktivitas = "45 mins".obs;

  final insightText =
      "Aktivitas hari ini cukup baik. Menjaga pola makan teratur dapat membantu meningkatkan skor sehat harian."
          .obs;

  final rekomendasi = <String>[
    "Perbanyak konsumsi air putih",
    "Tambahkan aktivitas fisik 10–15 menit",
    "Kurangi makanan tinggi gula dan garam",
  ].obs;
}