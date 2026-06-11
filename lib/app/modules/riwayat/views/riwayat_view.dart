import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
      automaticallyImplyLeading: true,
      title: const Text("Riwayat Rekomendasi"),
      centerTitle: true,
    ),
      body: Obx(() {
        if (controller.riwayatList.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada riwayat",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.riwayatList.length,
          itemBuilder: (context, index) {
            final data = controller.riwayatList[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal
                    Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 8),
                        Text(
                          data.tanggal,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // Input makanan
                    const Text(
                      "Komposisi Makanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("🍳 Sarapan : ${data.sarapan}"),
                    const SizedBox(height: 4),

                    Text("🍱 Makan Siang : ${data.makanSiang}"),
                    const SizedBox(height: 4),

                    Text("🌙 Makan Malam : ${data.makanMalam}"),

                    const SizedBox(height: 12),

                    // Data kesehatan
                    Text(
                      "🩸 Gula Darah : ${data.gulaDarah} mg/dL",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "🚶 Aktivitas : ${data.aktivitas}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Rekomendasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Rekomendasi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data.rekomendasi,
                            style: const TextStyle(
                              height: 1.5,
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
        );
      }),
    );
  }
}