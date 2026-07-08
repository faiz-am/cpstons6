import 'package:get/get.dart';
import '../../../data/models/riwayat_model.dart';
import '../../auth/controllers/auth_controller.dart';

class AnalyticsController extends GetxController {
  final isLoading = false.obs;
  final String baseUrl = "http://127.0.0.1:5000/api";
  final GetConnect _connect = GetConnect();

  // Big Data state
  final bigDataSummary = <String, dynamic>{}.obs;
  final topCaloriesFoods = <Map<String, dynamic>>[].obs;
  final topProteinFoods = <Map<String, dynamic>>[].obs;

  // User History state
  final userHistoryList = <RiwayatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    try {
      isLoading.value = true;
      final email = Get.find<AuthController>().userEmail.value;

      // 1. Fetch Big Data Analytics
      final bigDataResponse = await _connect.get('$baseUrl/bigdata/analytics');
      if (bigDataResponse.status.hasError) {
        print("Error fetching Big Data Analytics from backend");
      } else if (bigDataResponse.body != null && bigDataResponse.body['success'] == true) {
        bigDataSummary.value = bigDataResponse.body['summary'] ?? {};
        
        final List rawCal = bigDataResponse.body['top_calories'] ?? [];
        topCaloriesFoods.value = rawCal.map((e) => Map<String, dynamic>.from(e)).toList();

        final List rawProt = bigDataResponse.body['top_protein'] ?? [];
        topProteinFoods.value = rawProt.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      // 2. Fetch User History Data
      final historyResponse = await _connect.get('$baseUrl/ambil-riwayat?username=$email');
      if (historyResponse.status.hasError) {
        print("Error fetching User History from backend");
      } else if (historyResponse.body != null && historyResponse.body['success'] == true) {
        final List dataAsli = historyResponse.body['data'] ?? [];
        userHistoryList.value = dataAsli.map((e) => RiwayatModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error in AnalyticsController: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
