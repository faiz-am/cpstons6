import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/riwayat_model.dart';

class RiwayatController extends GetxController {
  final riwayatList = <RiwayatModel>[].obs;
  final isLoading = false.obs;
  
  // Masukkan url backend sesuai dengan konfigurasi Flask kamu
  final String baseUrl = "http://127.0.0.1:5000/api"; 
  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    ambilDataRiwayat();
  }

  Future<void> ambilDataRiwayat() async {
    try {
      isLoading.value = true;
      final email = Get.find<AuthController>().userEmail.value;
      final response = await _connect.get('$baseUrl/ambil-riwayat?username=$email');

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