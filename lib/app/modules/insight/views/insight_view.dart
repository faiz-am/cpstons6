import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/insight_controller.dart';
<<<<<<< HEAD
import '../../settings/controllers/settings_controller.dart';
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af

class InsightView extends StatelessWidget {
  const InsightView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InsightController());
<<<<<<< HEAD
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
=======

    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            final horizontal =
                w > 700 ? w * 0.12 : w * 0.05;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tips Sehat",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f172a),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Panduan sederhana untuk menjaga gaya hidup sehat setiap hari.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 22),

                  _headerCard(),

                  const SizedBox(height: 18),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.tips.isEmpty) {
                      return const Center(
                        child: Text(
                          "Data tips kosong",
                        ),
                      );
                    }

                    return Column(
                      children:
                          controller.tips.map((tip) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _tipCard(
                            icon: _getIcon(tip.icon),
                            title: tip.title,
                            description:
                                tip.description,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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
<<<<<<< HEAD
        crossAxisAlignment: CrossAxisAlignment.start,
=======
        crossAxisAlignment:
            CrossAxisAlignment.start,
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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
<<<<<<< HEAD
    required Color cardBg,
    required Color textMain,
    required Color textMuted,
    required bool isDark,
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xff1e293b) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
=======
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
<<<<<<< HEAD
              color: isDark ? const Color(0xff1e293b) : const Color(0xffdbeafe),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isDark ? const Color(0xff00f0ff) : const Color(0xff2563eb),
=======
              color: const Color(0xffdbeafe),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xff2563eb),
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
<<<<<<< HEAD
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textMain,
=======
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(0xff0f172a),
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
<<<<<<< HEAD
                  style: TextStyle(
                    fontSize: 13,
                    color: textMuted,
=======
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff64748b),
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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