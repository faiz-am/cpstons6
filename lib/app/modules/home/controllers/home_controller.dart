import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/riwayat_model.dart';
import '../../../data/services/api_service.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var displayName = "Pengguna Sehat".obs;
  var latestRiwayat = Rxn<RiwayatModel>();

  // 🟢 VARIABEL REAKTIF DATA MEDIS RIIL
  var statusKesehatan = "Normal".obs;
  var targetKalori = 2000.obs;

  // Memanggil ApiService terpusat
  final ApiService _api = Get.find<ApiService>();
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final email = auth.userEmail.value;

      if (email.isNotEmpty) {
        // 1. Logika Pengambilan Nama Profil
        final savedName = await _storage.read(key: "${email}_profile_name");
        if (savedName != null && savedName.trim().isNotEmpty) {
          displayName.value = savedName;
        } else {
          if (email.contains('@')) {
            displayName.value = email.split('@')[0];
          } else {
            displayName.value = email;
          }
        }

        // 2. INTEGRASI DATA MEDIS RIIL DARI BACKEND FLASK
        // Menembak endpoint status kesehatan untuk kalkulasi BMI real-time dari database MySQL
        final statusResponse = await _api.get('/api/status-kesehatan?username=$email');
        if (statusResponse.statusCode == 200 && statusResponse.body != null) {
          statusKesehatan.value = statusResponse.body['status'] ?? "Normal";
          targetKalori.value = (statusResponse.body['target_kalori'] as num?)?.toInt() ?? 2000;
        }

        // 3. Request mengambil riwayat gizi harian menggunakan endpoint relatif
        final response = await _api.get('/api/ambil-riwayat?username=$email');

        if (response.body != null && response.body['success'] == true) {
          final List dataAsli = response.body['data'];
          if (dataAsli.isNotEmpty) {
            latestRiwayat.value = RiwayatModel.fromJson(dataAsli.first);
          } else {
            latestRiwayat.value = null;
          }
        } else {
          latestRiwayat.value = null;
        }
      }
    } catch (e) {
      print("Eror Fetch Dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}