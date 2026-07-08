import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  // Fungsi helper untuk menentukan warna label status kondisi kesehatan
  Color _ambilWarnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'kurang':
        return Colors.blue.shade600;
      case 'normal':
        return Colors.green.shade600;
      case 'berlebih':
      case 'peringatan':
        return Colors.orange.shade700;
      case 'bahaya':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Riwayat Rekomendasi Gizi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.ambilDataRiwayat(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.riwayatList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  "Belum ada riwayat konsumsi",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.ambilDataRiwayat(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.riwayatList.length,
            itemBuilder: (context, index) {
              final data = controller.riwayatList[index];
              final warnaStatus = _ambilWarnaStatus(data.statusKondisi);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Kartu: Tanggal & Badge Status Kondisi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                data.tanggal,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xff2563eb).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "SKOR: ${data.skor}",
                                  style: const TextStyle(
                                    color: Color(0xff2563eb),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: warnaStatus.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  data.statusKondisi.toUpperCase(),
                                  style: TextStyle(
                                    color: warnaStatus,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),

                      // Daftar Makanan yang Dikonsumsi
                      const Text(
                        "Menu Konsumsi Harian",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildItemMenu(context, "🍳 Sarapan", data.sarapan, data.fotoPagi),
                      _buildItemMenu(context, "🍱 Siang", data.makanSiang, data.fotoSiang),
                      _buildItemMenu(context, "🌙 Malam", data.makanMalam, data.fotoMalam),

                      const SizedBox(height: 16),
                      
                      // Ringkasan Total Nutrisi yang Masuk (Gaya Grid)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildNutrisiMini("🔥 Kalori", "${data.kalori.toStringAsFixed(0)} kkal"),
                                _buildNutrisiMini("🥩 Protein", "${data.protein.toStringAsFixed(1)}g"),
                                _buildNutrisiMini("🍞 Karbo", "${data.karbohidrat.toStringAsFixed(1)}g"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildNutrisiMini("🥑 Lemak", "${data.lemak.toStringAsFixed(1)}g"),
                                _buildNutrisiMini("🍬 Gula", "${data.gula.toStringAsFixed(1)}g"),
                                _buildNutrisiMini("🧂 Sodium", "${data.sodium.toStringAsFixed(0)}mg"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kotak Saran Rekomendasi AI Gizi
                      if (data.rekomendasi.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.green.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome_rounded, color: Colors.green.shade700, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Analisis & Saran Gizi AI",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.rekomendasi,
                                style: TextStyle(
                                  height: 1.45,
                                  fontSize: 13,
                                  color: Colors.green.shade900.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Widget Pembantu untuk Baris Menu Makanan beserta Foto Clickable
  Widget _buildItemMenu(BuildContext context, String label, String value, String base64Str) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13))),
          const Text(": ", style: TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87),
            ),
          ),
          if (base64Str.isNotEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(15),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          base64Decode(base64Str),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(base64Str),
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget Pembantu untuk Grid Informasi Indikator Angka Nutrisi
  Widget _buildNutrisiMini(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}