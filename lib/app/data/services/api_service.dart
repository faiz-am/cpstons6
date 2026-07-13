import 'package:get/get.dart';

class ApiService extends GetConnect {
  // =========================================================================
  // CUKUP GANTI SATU BARIS IP DI BAWAH INI SAJA SAAT PINDAH WI-FI / ONLINE
  // =========================================================================
  final String _ipLokal = "192.168.1.13"; 

  @override
  void onInit() {
    // Menetapkan Base URL utama ke server Flask
    baseUrl = "http://$_ipLokal:5000";
    
    // Konfigurasi timeout global (30 detik)
    timeout = const Duration(seconds: 30);
    
    super.onInit();
  }
}