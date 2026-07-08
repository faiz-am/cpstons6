import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';

class RekomendasiController extends GetxController {
  final String baseUrl = "http://127.0.0.1:5000"; // Sesuaikan IP-mu

  var isLoading = true.obs;
  var isSaved = false.obs;
  
  // Data Ringkasan Gizi Total (Hasil Kalkulasi)
  var totalKalori = 0.0.obs;
  var totalProtein = 0.0.obs;
  var totalKarbohidrat = 0.0.obs;
  var totalLemak = 0.0.obs;
  var totalGula = 0.0.obs;
  var totalSodium = 0.0.obs;
  
  var saranText = "".obs;
  var statusKondisi = "Normal".obs;
  
  // Tampungan arguments mentah dari halaman input
  var dataInputan = {}.obs;

  // Variabel untuk persentase Progress Bar (0.0 sampai 1.0)
  var persenProtein = 0.0.obs;
  var persenKarbo = 0.0.obs;
  var persenLemak = 0.0.obs;
  var persenGula = 0.0.obs;
  var persenSodium = 0.0.obs;
  var healthScore = 100.obs;

  @override
  void onInit() {
    super.onInit();
    analisisDataKesehatan();
  }

  Future<void> analisisDataKesehatan() async {
    try {
      isLoading.value = true;
      
      // Ambil arguments paket data dari InputView
      Map<String, dynamic> argumentsData = Get.arguments ?? {};
      dataInputan.value = argumentsData;

      final respon = await http.post(
        Uri.parse("$baseUrl/api/proses-rekomendasi"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(argumentsData),
      );

      if (respon.statusCode == 200) {
        var hasil = jsonDecode(respon.body)['data'];
        
        // FUNGSI HELPER SUPER AMAN: Kebal dari "Invalid double" & spasi liar
        double ambilAngka(dynamic nilai) {
          if (nilai == null) return 0.0;
          // Jika sudah bertipe num/int/double, langsung kembalikan nilainya
          if (nilai is num) return nilai.toDouble();
          
          // Jika bertipe String, bersihkan spasi lalu parsing secara aman
          String teksAngka = nilai.toString().trim();
          return double.tryParse(teksAngka) ?? 0.0;
        }

        // Pemetaan data gizi dari Flask ke RxDouble secara berurutan & aman
        totalKalori.value       = ambilAngka(hasil['total_kalori']);
        totalProtein.value      = ambilAngka(hasil['total_protein']);
        totalKarbohidrat.value  = ambilAngka(hasil['total_karbohidrat']);
        totalLemak.value        = ambilAngka(hasil['total_lemak']);
        totalGula.value         = ambilAngka(hasil['total_gula']);
        totalSodium.value       = ambilAngka(hasil['total_sodium']);
        
        saranText.value     = hasil['saran']?.toString() ?? "Pola makan harian cukup baik.";
        statusKondisi.value = hasil['status_kondisi']?.toString() ?? "Normal";
        healthScore.value   = hasil['skor'] is int ? hasil['skor'] : (hasil['skor'] as num?)?.toInt() ?? 80;

        // Hitung persentase bar dinamis (skala target gizi harian normal)
        persenProtein.value = totalProtein.value / 60.0;
        persenKarbo.value   = totalKarbohidrat.value / 300.0;
        persenLemak.value   = totalLemak.value / 65.0;
        persenGula.value    = totalGula.value / 50.0;
        persenSodium.value  = totalSodium.value / 2000.0;

      } else {
        var msg = jsonDecode(respon.body)['message'] ?? "Gagal memproses rekomendasi.";
        saranText.value = "Error Server: $msg";
      }
    } catch (e) {
      saranText.value = "Terjadi kesalahan sistem: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi simpan data ke riwayat dengan sinkronisasi ke Home & Riwayat
  Future<void> simpanDataKeRiwayat() async {
    if (isSaved.value) return; // Mencegah penyimpanan ganda
    try {
      final email = Get.find<AuthController>().userEmail.value;

      // Siapkan body data yang akan dikirim ke endpoint simpan
      Map<String, dynamic> bodySimpan = {
        "username": email,
        "pagi": dataInputan["pagi"] ?? "-",
        "siang": dataInputan["siang"] ?? "-",
        "malam": dataInputan["malam"] ?? "-",
        "total_kalori": totalKalori.value,
        "total_protein": totalProtein.value,
        "total_karbohidrat": totalKarbohidrat.value,
        "total_lemak": totalLemak.value,
        "total_gula": totalGula.value,
        "total_sodium": totalSodium.value,
        "saran": saranText.value,
        "status_kondisi": statusKondisi.value,
        "foto_pagi": dataInputan["foto_pagi"] ?? "",
        "foto_siang": dataInputan["foto_siang"] ?? "",
        "foto_malam": dataInputan["foto_malam"] ?? "",
        "skor": healthScore.value,
      };

      final respon = await http.post(
        Uri.parse("$baseUrl/api/simpan-riwayat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodySimpan),
      );

      if (respon.statusCode == 200) {
        isSaved.value = true;

        // Sinkronisasi data di Home & Riwayat jika controller terdaftar
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().fetchDashboardData();
        }
        if (Get.isRegistered<RiwayatController>()) {
          await Get.find<RiwayatController>().ambilDataRiwayat();
        }

        var msg = jsonDecode(respon.body)['message'];
        Get.snackbar(
          "Sukses", 
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Arahkan kembali ke halaman utama (Dashboard & Riwayat) setelah berhasil menyimpan
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/main-nav');
        });
      } else {
        var msg = jsonDecode(respon.body)['message'] ?? "Gagal menyimpan.";
        Get.snackbar("Gagal", msg, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error Jaringan", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}