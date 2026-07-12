import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/riwayat_model.dart';
import '../../../data/services/api_service.dart'; // Import ApiService terpusat kamu

class RiwayatController extends GetxController {
  final riwayatList = <RiwayatModel>[].obs;
  final isLoading = false.obs;
  
  // MEMPERBAIKAI: Panggil instansi ApiService global (IP diatur dari satu tempat)
  final ApiService _api = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    ambilDataRiwayat();
  }

  Future<void> ambilDataRiwayat() async {
    try {
      isLoading.value = true;
      final email = Get.find<AuthController>().userEmail.value;
      
      // MEMPERBAIKAI: Menggunakan endpoint relatif terpusat via ApiService
      // 🟢 UBAH MENJADI:
      final response = await _api.get('/api/ambil-riwayat?username=$email');

      if (response.status.hasError) {
        Get.snackbar("Eror Koneksi", "Gagal memuat riwayat dari server backend");
        return;
      }

      if (response.body != null && response.body['success'] == true) {
        final List dataAsli = response.body['data'];
        riwayatList.value = dataAsli.map((e) => RiwayatModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Eror Fetch Riwayat: $e");
    } finally {
      isLoading.value = false;
    }
  }
}