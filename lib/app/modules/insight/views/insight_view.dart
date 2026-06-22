import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/insight_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class InsightView extends StatelessWidget {
  const InsightView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InsightController());
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsCtrl.isDarkModeEnabled.value;
      final scaffoldBg = isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff);
      final cardBg = isDark ? const Color(0xff0f1524) : Colors.white;
      final textMain = isDark ? Colors.white : const Color(0xff0f172a);
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);

      return Scaffold(
        backgroundColor: scaffoldBg,
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
                    Text(
                      "Tips Sehat",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Panduan sederhana untuk menjaga gaya hidup sehat setiap hari.",
                      style: TextStyle(
                        fontSize: 14,
                        color: textMuted,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _headerCard(),

                    const SizedBox(height: 18),

                    if (controller.isLoading.value)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (controller.tips.isEmpty)
                      Center(
                        child: Text(
                          "Data tips kosong",
                          style: TextStyle(color: textMain),
                        ),
                      )
                    else
                      Column(
                        children: controller.tips.map((tip) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _tipCard(
                              icon: _getIcon(tip.icon),
                              title: tip.title,
                              description: tip.description,
                              cardBg: cardBg,
                              textMain: textMain,
                              textMuted: textMuted,
                              isDark: isDark,
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _headerCard() {
    return Container(
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.white,
          ),

          SizedBox(height: 14),

          Text(
            "For You",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Kebiasaan kecil yang konsisten setiap hari dapat membantu menjaga kesehatan tubuh dalam jangka panjang.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color cardBg,
    required Color textMain,
    required Color textMuted,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xff1e293b) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1e293b) : const Color(0xffdbeafe),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isDark ? const Color(0xff00f0ff) : const Color(0xff2563eb),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textMain,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'water':
        return Icons.water_drop_outlined;

      case 'food':
        return Icons.restaurant_outlined;

      case 'walk':
        return Icons.directions_walk_outlined;

      case 'sleep':
        return Icons.bedtime_outlined;

      default:
        return Icons.health_and_safety_outlined;
    }
  }
}