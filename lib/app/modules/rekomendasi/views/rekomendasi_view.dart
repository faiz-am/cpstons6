import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rekomendasi_controller.dart';

class RekomendasiView extends GetView<RekomendasiController> {
  const RekomendasiView({super.key});

  @override
  Widget build(BuildContext context) {
    double w = Get.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Analisis Nutrisi & Saran", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isBahaya = controller.statusKondisi.value == "Bahaya";

        return SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // 1. HEADER RINGKASAN ENERGI (KALORI)
              // ====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isBahaya 
                        ? [Colors.red.shade400, Colors.red.shade600] 
                        : [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: (isBahaya ? Colors.red : Colors.lightGreen).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TOTAL ASUPAN ENERGI", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text("${controller.totalKalori.value} kcal", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(isBahaya ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isBahaya ? "Melebihi ambang batas anjuran kesehatan Anda!" : "Asupan kalori harian terpantau seimbang.",
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ====================================================
              // 2. CARD SARAN DOKTER / BACKEND
              // ====================================================
              const Text("Rekomendasi Medis & Solusi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.analytics_outlined, color: isBahaya ? Colors.red : Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.saranText.value,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800], fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ====================================================
              // 3. BREAKDOWN MAKRONUTRISI & MIKRONUTRISI
              // ====================================================
              const Text("Rincian Nutrisi Terkonsumsi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _macroBar("Protein", controller.totalProtein.value, "gram", Colors.orange, controller.persenProtein.value),
                    const Divider(height: 24),
                    _macroBar("Karbohidrat", controller.totalKarbohidrat.value, "gram", Colors.amber.shade700, controller.persenKarbo.value),
                    const Divider(height: 24),
                    _macroBar("Lemak", controller.totalLemak.value, "gram", Colors.red.shade400, controller.persenLemak.value),
                    const Divider(height: 24),
                    _macroBar("Gula (Glukosa)", controller.totalGula.value, "gram", Colors.pink.shade300, controller.persenGula.value),
                    const Divider(height: 24),
                    _macroBar("Sodium (Garam)", controller.totalSodium.value, "mg", Colors.blueGrey, controller.persenSodium.value),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ====================================================
              // 4. RIWAYAT MENU YANG DIINPUT USER
              // ====================================================
              const Text("Daftar Makan Anda Hari Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _foodCardMini("Pagi", controller.dataInputan["pagi"] ?? "-", Icons.wb_sunny_outlined, Colors.orange.shade100),
                  const SizedBox(width: 10),
                  _foodCardMini("Siang", controller.dataInputan["siang"] ?? "-", Icons.lunch_dining_outlined, Colors.blue.shade100),
                  const SizedBox(width: 10),
                  _foodCardMini("Malam", controller.dataInputan["malam"] ?? "-", Icons.nightlight_outlined, Colors.indigo.shade100),
                ],
              ),
              
              const SizedBox(height: 35),
              
              // ====================================================
              // 5. TOMBOL SIMPAN DATA (DI TENGAH BAWAH)
              // ====================================================
              Center(
                child: SizedBox(
                  width: w * 0.9, // Lebar proporsional 90% layar
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.simpanDataKeRiwayat();
                    },
                    icon: const Icon(Icons.save_rounded, color: Colors.white),
                    label: const Text(
                      "SIMPAN KE RIWAYAT & BERANDA",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBahaya ? Colors.red.shade600 : Colors.greenAccent.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // Widget Pembantu untuk Membuat Progress Bar Nutrisi
  Widget _macroBar(String title, double value, String unit, Color color, double percentage) {
    double checkedPercentage = percentage.isNaN || percentage.isInfinite ? 0.0 : percentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14)),
            Text("${value.toStringAsFixed(2)} $unit", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: checkedPercentage.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // Widget Pembantu untuk Card Makanan Kecil di bawah (Sudah Bersih dari Tombol)
  Widget _foodCardMini(String waktu, String namaMakanan, IconData icon, Color bagColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: bagColor, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(waktu, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(
              namaMakanan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}