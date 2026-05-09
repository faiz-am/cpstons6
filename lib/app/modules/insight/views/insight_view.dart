import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insight_controller.dart';

class InsightView extends GetView<InsightController> {
  const InsightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final horizontal = w > 700 ? w * 0.12 : w * 0.05;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Insight",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f172a),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Ringkasan dan rekomendasi gaya hidup sehat.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2563eb),
                            Color(0xff3b82f6),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Skor Sehat: ${controller.skorSehat.value}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.insightText.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => _metricCard(
                            title: "Kalori",
                            value: controller.kalori.value,
                            icon: Icons.local_fire_department_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => _metricCard(
                            title: "Aktivitas",
                            value: controller.aktivitas.value,
                            icon: Icons.directions_run,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rekomendasi",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0f172a),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...controller.rekomendasi.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "• $e",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xff2563eb),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff64748b),
            ),
          ),
        ],
      ),
    );
  }
}