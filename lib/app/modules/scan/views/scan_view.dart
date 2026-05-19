import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            final w = constraints.maxWidth;
            final horizontal =
                w > 700 ? w * 0.12 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Scan Makanan",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0f172a),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Upload atau foto makanan untuk mengetahui nutrisi dan rekomendasi kesehatan.",
                    style: TextStyle(
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // IMAGE CARD
                  Container(
                    width: double.infinity,
                    height: 260,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(28),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Container(
                          width: 90,
                          height: 90,

                          decoration: BoxDecoration(
                            color:
                                const Color(0xffdbeafe),

                            borderRadius:
                                BorderRadius.circular(24),
                          ),

                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 42,
                            color: Color(0xff2563eb),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Belum Ada Gambar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Ambil foto makanan untuk dianalisis AI",
                          style: TextStyle(
                            color: Color(0xff64748b),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton.icon(

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xff2563eb),

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          onPressed: () {
                            controller.mockScan();
                          },

                          icon: const Icon(
                            Icons.camera_alt,
                          ),

                          label: const Text(
                            "Camera",
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: ElevatedButton.icon(

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white,

                            foregroundColor:
                                const Color(0xff2563eb),

                            elevation: 0,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              side: const BorderSide(
                                color:
                                    Color(0xff2563eb),
                              ),
                            ),
                          ),

                          onPressed: () {
                            controller.mockScan();
                          },

                          icon: const Icon(
                            Icons.photo_library_outlined,
                          ),

                          label: const Text(
                            "Gallery",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // RESULT CARD
                  Obx(
                    () => Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(22),

                      decoration: BoxDecoration(

                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xff2563eb),
                            Color(0xff3b82f6),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(28),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "Hasil Analisis",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            controller.foodName.value,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [

                              Expanded(
                                child: _infoCard(
                                  title: "Kalori",
                                  value: controller
                                      .calories.value,

                                  icon: Icons
                                      .local_fire_department,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _infoCard(
                                  title: "Status",
                                  value: controller
                                      .status.value,

                                  icon: Icons
                                      .health_and_safety,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // RECOMMENDATION
                  Obx(
                    () => Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.04),

                            blurRadius: 8,

                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.tips_and_updates,
                                color:
                                    Color(0xff2563eb),
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Rekomendasi",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Text(
                            controller
                                .recommendation.value,

                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xff475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.white,
          ),

          const SizedBox(height: 12),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}