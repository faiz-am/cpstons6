import 'package:get/get.dart';
import '../../../data/models/riwayat_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/services/api_service.dart';

class AnalyticsController extends GetxController {
  final isLoading = false.obs;
  final isFoodsLoading = false.obs;
  final ApiService _api = Get.find<ApiService>();

  // State Data Eksternal (Big Data FatSecret Dataset)
  final bigDataSummary = <String, dynamic>{}.obs;
  final topCaloriesFoods = <Map<String, dynamic>>[].obs;
  final bigDataFoods = <Map<String, dynamic>>[].obs;

  // State Data Internal (User Records MySQL)
  final userHistoryList = <RiwayatModel>[].obs;
  final userMacroAverage = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    try {
      isLoading.value = true;
      final email = Get.find<AuthController>().userEmail.value;

      // 1. Ambil Analitik Data Eksternal
      final bigDataResponse = await _api.get('/api/bigdata/analytics');
      if (bigDataResponse.statusCode == 200 && bigDataResponse.body != null && bigDataResponse.body['success'] == true) {
        bigDataSummary.value = bigDataResponse.body['summary'] ?? {};
        final List rawCal = bigDataResponse.body['top_calories'] ?? [];
        topCaloriesFoods.value = rawCal.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      await fetchBigDataFoods("");

      // 2. Ambil Analitik Data Internal User
      final historyResponse = await _api.get('/api/ambil-riwayat?username=$email');
      if (historyResponse.statusCode == 200 && historyResponse.body != null && historyResponse.body['success'] == true) {
        final List dataAsli = historyResponse.body['data'] ?? [];
        
        // Mapping riwayat
        userHistoryList.value = dataAsli.map((e) => RiwayatModel.fromJson(e)).toList();

        // Hitung rata-rata makro internal untuk Grafik Batang Internal
        if (userHistoryList.isNotEmpty) {
          double totalProtein = 0;
          double totalKarbo = 0;
          double totalLemak = 0;

          for (var item in userHistoryList) {
            totalProtein += item.protein;
            totalKarbo += item.karbohidrat;
            totalLemak += item.lemak;
          }

          userMacroAverage.value = {
            'Protein': totalProtein / userHistoryList.length,
            'Karbohidrat': totalKarbo / userHistoryList.length,
            'Lemak': totalLemak / userHistoryList.length,
          };
        }
      }
    } catch (e) {
      print("Error in AnalyticsController: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBigDataFoods(String search) async {
    try {
      isFoodsLoading.value = true;
      final response = await _api.get('/api/bigdata/foods?search=$search');
      if (response.statusCode == 200 && response.body != null && response.body['success'] == true) {
        final List rawFoods = response.body['foods'] ?? [];
        bigDataFoods.value = rawFoods.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print("Error in fetchBigDataFoods: $e");
    } finally {
      isFoodsLoading.value = false;
    }
  }
}