import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class InputController extends GetxController {
  // Base URL Flask (Gunakan 10.0.2.2 untuk emulator Android)
  final String baseUrl = "http://127.0.0.1:5000";

  // Makanan & Porsi Controller
  final pagiC = TextEditingController();
  final siangC = TextEditingController();
  final malamC = TextEditingController();

  final pagiPorsiC = TextEditingController();
  final siangPorsiC = TextEditingController();
  final malamPorsiC = TextEditingController();

  // RxString untuk Satuan (Defaut: gram)
  var pagiSatuan = "gram".obs;
  var siangSatuan = "gram".obs;
  var malamSatuan = "gram".obs;

  // RxList untuk pilihan makanan dari DB
  var daftarMakanan = <String>[].obs;

  // RxString untuk pilihan makanan terpilih
  var pagiMakanan = "".obs;
  var siangMakanan = "".obs;
  var malamMakanan = "".obs;

  @override
  void onInit() {
    super.onInit();
    ambilDaftarMakanan();
  }

  Future<void> ambilDaftarMakanan() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/api/makanan"),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        daftarMakanan.value = data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      print("Koneksi Flask error / Gagal ambil makanan: $e");
    }

    // Fallback jika DB kosong / koneksi bermasalah
    if (daftarMakanan.isEmpty) {
      daftarMakanan.value = [
        "Ayam Goreng",
        "Bubur Ayam",
        "Mie Ayam",
        "Mie Goreng",
        "Nasi Goreng",
        "Nasi Lengko",
        "Sate Kambing",
        "Sayur Asem",
        "Sayur Bayam",
        "Telur Dadar"
      ];
    }

    // Set nilai awal
    pagiMakanan.value = daftarMakanan.first;
    siangMakanan.value = daftarMakanan.first;
    malamMakanan.value = daftarMakanan.first;

    pagiC.text = pagiMakanan.value;
    siangC.text = siangMakanan.value;
    malamC.text = malamMakanan.value;
  }

  // Aktivitas & Penyakit
  var aktivitas = "Ringan".obs;
  final aktivitasList = ["Ringan", "Sedang", "Berat"];

  var penyakit = "Tidak ada".obs;
  final List<String> penyakitList = ["Tidak ada", "Diabetes", "Hipertensi", "Obesitas"];

  // Form Penyakit
  final gulaDarahC = TextEditingController();
  final sistolikC = TextEditingController();
  final diastolikC = TextEditingController();
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();

  // Image Picker
  final picker = ImagePicker();
  var pagiImage = Rx<Uint8List?>(null);
  var siangImage = Rx<Uint8List?>(null);
  var malamImage = Rx<Uint8List?>(null);

  var pagiBase64 = "".obs;
  var siangBase64 = "".obs;
  var malamBase64 = "".obs;

  Future<void> pickImage(String type) async {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Get.back();
                  _processPickImage(type, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Get.back();
                  _processPickImage(type, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processPickImage(String type, ImageSource source) async {
    try {
      final picked = await picker.pickImage(source: source, imageQuality: 70);
      if (picked != null) {
        // Tampilkan loading dialog
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

        // Baca bytes secara asynchronous (kompatibel web & mobile)
        final bytes = await picked.readAsBytes();

        // Upload ke endpoint deteksi makanan di backend
        var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/api/predict-makanan"));
        request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: picked.name));
        var streamedResponse = await request.send().timeout(const Duration(seconds: 10));
        var response = await http.Response.fromStream(streamedResponse);

        Get.back(); // Tutup loading dialog

        if (response.statusCode == 200) {
          var resData = jsonDecode(response.body);
          if (resData['success'] == true) {
            String predicted = resData['predicted_food'];
            double confidence = resData['confidence'] != null ? (resData['confidence'] as num).toDouble() : 0.0;

            // Set makanan terpilih otomatis
            if (type == "pagi") {
              pagiMakanan.value = predicted;
              pagiC.text = predicted;
            } else if (type == "siang") {
              siangMakanan.value = predicted;
              siangC.text = predicted;
            } else if (type == "malam") {
              malamMakanan.value = predicted;
              malamC.text = predicted;
            }

            Get.snackbar(
              "Deteksi Sukses", 
              "Makanan terdeteksi: $predicted (${confidence.toStringAsFixed(1)}%)",
              backgroundColor: Colors.green, 
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM
            );
          } else {
            Get.snackbar("Deteksi Gagal", "Gagal mengklasifikasi gambar", backgroundColor: Colors.orange, colorText: Colors.white);
          }
        } else {
          Get.snackbar("Eror Server", "Gagal memproses gambar pada server", backgroundColor: Colors.red, colorText: Colors.white);
        }

        // Konversi ke base64 untuk disimpan ke riwayat
        final base64String = base64Encode(bytes);

        if (type == "pagi") {
          pagiImage.value = bytes;
          pagiBase64.value = base64String;
        } else if (type == "siang") {
          siangImage.value = bytes;
          siangBase64.value = base64String;
        } else if (type == "malam") {
          malamImage.value = bytes;
          malamBase64.value = base64String;
        }
      }
    } catch (e) {
      Get.back(); // Pastikan loading tertutup jika crash
      print("Eror proses gambar: $e");
      Get.snackbar("Eror Proses", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ====================================================
  // 🔍 SUGGESTION DARI BACKEND RIIL (FIXED ROUTE)
  // ====================================================
  Future<List<String>> dapatkanRekomendasiMakanan(String query) async {
    if (query.trim().isEmpty) return [];
    
    try {
      // Pastikan endpoint di bawah ini sesuai dengan prefix blueprint Flask kamu (misal: /api/makanan)
      final res = await http.get(
        Uri.parse("$baseUrl/api/makanan?search=${Uri.encodeComponent(query)}"),
      ).timeout(const Duration(seconds: 2));

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      print("Koneksi Flask error / Data tidak ditemukan: $e");
    }

    // KOSONGKAN LIST LOKAL: Hapus data dummy agar jika database kosong, 
    // sistem tidak memunculkan data palsu yang membingungkan.
    return []; 
  }

  // ====================================================
  // 🚀 SUBMIT KE BACKEND FLASK
  // ====================================================
  Future<void> submitData() async {
    if (pagiC.text.isEmpty || siangC.text.isEmpty || malamC.text.isEmpty) {
      Get.snackbar("Error", "Semua makanan harus diisi");
      return;
    }
    if (pagiPorsiC.text.isEmpty || siangPorsiC.text.isEmpty || malamPorsiC.text.isEmpty) {
      Get.snackbar("Error", "Porsi makanan harus diisi");
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // 1. Ambil Kalkulasi Gizi dari Backend untuk Makanan Pagi, Siang, Malam
      var giziPagi = await _tembakApiGizi(pagiC.text, pagiPorsiC.text, pagiSatuan.value);
      var giziSiang = await _tembakApiGizi(siangC.text, siangPorsiC.text, siangSatuan.value);
      var giziMalam = await _tembakApiGizi(malamC.text, malamPorsiC.text, malamSatuan.value);

      Get.back(); // Tutup loading dialog

      // 2. Satukan paket data untuk dikirim ke halaman Rekomendasi
      // === PASTIKAN STRUKTUR DI INPUT_CONTROLLER SEPERTI INI ===
    final Map<String, dynamic> rekapData = {
      // 1. Mengirimkan paket data gizi hasil hitungan Flask
      "gizi_pagi": giziPagi,   
      "gizi_siang": giziSiang, 
      "gizi_malam": giziMalam, 
      
      // 2. Mengirim parameter kondisi kesehatan fisik
      "aktivitas": aktivitas.value,
      "penyakit": penyakit.value,
      "gula_darah": gulaDarahC.text,
      "sistolik": sistolikC.text,
      "diastolik": diastolikC.text,
      "tinggi": tinggiC.text,
      "berat": beratC.text,

      // 3. Mengirim String teks nama makanan untuk widget kotak di bawah
      "pagi": "${pagiC.text} (${pagiPorsiC.text} ${pagiSatuan.value})",      
      "siang": "${siangC.text} (${siangPorsiC.text} ${siangSatuan.value})",
      "malam": "${malamC.text} (${malamPorsiC.text} ${malamSatuan.value})",

      // 4. Mengirim base64 foto makanan ke rekomendasi (untuk nanti disimpan ke riwayat)
      "foto_pagi": pagiBase64.value,
      "foto_siang": siangBase64.value,
      "foto_malam": malamBase64.value,
    };

    // Pindah halaman dengan membawa rekapData
    Get.toNamed(
      Routes.REKOMENDASI,
      arguments: rekapData,
    );

    } catch (e) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", e.toString());
    }
  }

  // Helper function untuk POST request ke Flask
  Future<Map<String, dynamic>?> _tembakApiGizi(String nama, String porsi, String satuan) async {
    final respon = await http.post(
      Uri.parse("$baseUrl/api/hitung-gizi"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama_makanan": nama,
        "jumlah_porsi": porsi,
        "satuan": satuan,
      }),
    );

    if (respon.statusCode == 200) {
      var jsonRes = jsonDecode(respon.body);
      return jsonRes['data'];
    } else {
      var msg = jsonDecode(respon.body)['message'] ?? "Gagal memproses data";
      throw "Makanan '$nama' bermasalah: $msg";
    }
  }

  @override
  void onClose() {
    pagiC.dispose(); siangC.dispose(); malamC.dispose();
    pagiPorsiC.dispose(); siangPorsiC.dispose(); malamPorsiC.dispose();
    gulaDarahC.dispose(); sistolikC.dispose(); diastolikC.dispose();
    tinggiC.dispose(); beratC.dispose();
    super.onClose();
  }
}