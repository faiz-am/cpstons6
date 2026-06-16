import 'package:get/get.dart';
import '../../../data/models/riwayat_model.dart';

class RiwayatController extends GetxController {

  final riwayatList = <RiwayatModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy Data
    riwayatList.add(
      RiwayatModel(
        tanggal: "23 Juni 2025",
        sarapan: "Nasi Goreng 200gr",
        makanSiang: "Ayam Geprek 250gr",
        makanMalam: "Mie Goreng 200gr",
        aktivitas: "Ringan",
        gulaDarah: 180,
        rekomendasi:
            "Kurangi konsumsi makanan tinggi karbohidrat sederhana dan tambahkan sayuran.",
      ),
    );
  }

  void tambahRiwayat(RiwayatModel data) {
    riwayatList.insert(0, data);
  }
}

