import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/tip_model.dart';

class InsightController extends GetxController {

  var isLoading = false.obs;
  var tips = <TipModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load local fallback tips immediately so they display instantly
    _loadLocalTips();
    // Fetch latest tips from backend in the background
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
      // Hanya tampilkan spinner jika data tips kosong
      if (tips.isEmpty) {
        isLoading.value = true;
      }

      // Gunakan IP 10.0.2.2 untuk emulator Android agar bisa terhubung ke localhost host OS
      final domain = (GetPlatform.isAndroid && !GetPlatform.isWeb) ? '10.0.2.2:5000' : '127.0.0.1:5000';
      final url = 'http://$domain/api/tips';

      print("Fetching tips from: $url");

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));

      print("Tips response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
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