import 'dart:convert';
import 'package:get/get.dart';
import '../../../data/models/tip_model.dart';
import '../../../data/services/api_service.dart'; // Import ApiService terpusat kamu

class InsightController extends GetxController {
  var isLoading = false.obs;
  var tips = <TipModel>[].obs;

  // MEMPERBAIKAI: Menggunakan ApiService global terpusat
  final ApiService _api = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _loadLocalTips();
    fetchTips();
  }

  void _loadLocalTips() {
    tips.value = [
      TipModel(
        id: 1,
        title: "Cukupi kebutuhan air",
        description: "Minum air putih minimal 2 liter setiap hari agar tubuh tetap terhidrasi.",
        icon: "water",
      ),
      TipModel(
        id: 2,
        title: "Aktif bergerak",
        description: "Lakukan jalan kaki ringan atau olahraga sedang minimal 15-30 menit setiap hari.",
        icon: "walk",
      ),
      TipModel(
        id: 3,
        title: "Tidur cukup",
        description: "Tidur berkualitas selama 7-8 jam per malam membantu pemulihan sel tubuh.",
        icon: "sleep",
      ),
    ];
  }

  Future<void> fetchTips() async {
    try {
      if (tips.isEmpty) {
        isLoading.value = true;
      }

      print("Fetching tips from terpusat: ${_api.baseUrl}/api/tips");

      // MEMPERBAIKAI: Ganti request http lama ke _api.get dan naikkan timeout ke 10 detik
      // Ini akan menyembuhkan TimeoutException saat tarikan awal server
      final response = await _api.get('/api/tips').timeout(const Duration(seconds: 10));

      print("Tips response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> jsonData = response.body;
        if (jsonData.isNotEmpty) {
          tips.value = jsonData.map((e) => TipModel.fromJson(e)).toList();
          print("Loaded ${tips.length} tips from API successfully");
        }
      }
    } catch (e) {
      print("ERROR FETCHING TIPS FROM BACKEND: $e");
    } finally {
      isLoading.value = false;
    }
  }
}