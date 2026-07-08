import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsCtrl.isDarkModeEnabled.value;
      final scaffoldBg = isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff);
      final cardBg = isDark ? const Color(0xff0f1524) : Colors.white;
      final textMain = isDark ? Colors.white : const Color(0xff0f172a);
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);
      final accentColor = const Color(0xff2563eb);

      final latest = controller.latestRiwayat.value;
      final isNormal = latest == null || latest.statusKondisi == 'Normal';
      final score = latest == null ? 0 : latest.skor;

      return Scaffold(
        backgroundColor: scaffoldBg,
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor,
          onPressed: () {
            Get.bottomSheet(
              _chatBot(cardBg, textMain, textMuted, isDark),
              isScrollControlled: true,
            );
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: accentColor,
            onRefresh: () => controller.fetchDashboardData(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final horizontal = w > 700 ? w * 0.12 : w * 0.05;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontal,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),

                      // Welcome Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Halo, ${controller.displayName.value}! 👋",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: textMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pantau aktivitas sehat harianmu.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh, color: accentColor),
                            onPressed: () => controller.fetchDashboardData(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Loading Overlay or Overview Card
                      if (controller.isLoading.value && latest == null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        _overviewCard(cardBg, textMain, textMuted, isDark, score, latest),

                      const SizedBox(height: 18),

                      // AI Recommendation Card
                      _insightCard(isNormal, latest),

                      const SizedBox(height: 18),

                      // Meal logs (Sarapan, Siang, Malam)
                      if (latest != null) ...[
                        _mealLogsCard(context, cardBg, textMain, textMuted, isDark, latest),
                        const SizedBox(height: 18),
                      ],

                      // Grid of Nutrients
                      Row(
                        children: [
                          Expanded(
                            child: _smallCard(
                              title: "Protein",
                              value: latest != null ? "${latest.protein.toStringAsFixed(1)} g" : "0.0 g",
                              subtitle: latest != null 
                                  ? "${(latest.protein / 60 * 100).toStringAsFixed(0)}% dari target 60g"
                                  : "Target: 60g",
                              icon: Icons.egg_alt_outlined,
                              cardBg: cardBg,
                              textMain: textMain,
                              textMuted: textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _smallCard(
                              title: "Karbohidrat",
                              value: latest != null ? "${latest.karbohidrat.toStringAsFixed(1)} g" : "0.0 g",
                              subtitle: latest != null 
                                  ? "${(latest.karbohidrat / 300 * 100).toStringAsFixed(0)}% dari target 300g"
                                  : "Target: 300g",
                              icon: Icons.rice_bowl_outlined,
                              cardBg: cardBg,
                              textMain: textMain,
                              textMuted: textMuted,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _smallCard(
                              title: "Lemak",
                              value: latest != null ? "${latest.lemak.toStringAsFixed(1)} g" : "0.0 g",
                              subtitle: latest != null 
                                  ? "${(latest.lemak / 65 * 100).toStringAsFixed(0)}% dari target 65g"
                                  : "Target: 65g",
                              icon: Icons.cookie_outlined,
                              cardBg: cardBg,
                              textMain: textMain,
                              textMuted: textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _smallCard(
                              title: "Sodium & Gula",
                              value: latest != null 
                                  ? "${latest.sodium.toStringAsFixed(0)}mg / ${latest.gula.toStringAsFixed(1)}g"
                                  : "0mg / 0g",
                              subtitle: "Batasan garam & gula harian",
                              icon: Icons.grain_outlined,
                              cardBg: cardBg,
                              textMain: textMain,
                              textMuted: textMuted,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _overviewCard(
    Color cardBg,
    Color textMain,
    Color textMuted,
    bool isDark,
    int score,
    dynamic latest,
  ) {
    final hasData = latest != null;
    final isNormal = !hasData || latest.statusKondisi == 'Normal';
    final progressVal = hasData ? (latest.kalori / 2000.0).clamp(0.0, 1.0) : 0.0;
    
    // Dynamic score ring color
    final Color ringColor = !hasData 
        ? Colors.grey.shade400
        : (isNormal ? const Color(0xff10b981) : const Color(0xffef4444));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xff1e293b) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textMain,
                ),
              ),
              Chip(
                backgroundColor: isDark ? const Color(0xff1e293b) : const Color(0xffeff6ff),
                side: BorderSide.none,
                label: Text(
                  hasData ? latest.tanggal : "Belum Ada Data",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xff2563eb),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ringColor,
                    width: 7,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasData ? "$score" : "-",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Skor Sehat",
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricItem(
                      icon: Icons.local_fire_department_outlined,
                      title: "Kalori",
                      value: hasData ? "${latest.kalori.toStringAsFixed(0)} kcal" : "0 kcal",
                    ),
                    const SizedBox(height: 12),
                    _MetricItem(
                      icon: Icons.health_and_safety_outlined,
                      title: "Kondisi Tubuh",
                      value: hasData ? latest.statusKondisi : "Belum terinput",
                      valueColor: hasData 
                          ? (isNormal ? const Color(0xff10b981) : const Color(0xffef4444))
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (hasData) ...[
            const SizedBox(height: 20),
            // Progress Bar Target Kalori
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Target Kalori Harian",
                      style: TextStyle(color: textMuted, fontSize: 12),
                    ),
                    Text(
                      "${(progressVal * 100).toStringAsFixed(0)}% tercapai",
                      style: TextStyle(
                        color: ringColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressVal,
                    minHeight: 8,
                    backgroundColor: isDark ? const Color(0xff1e293b) : Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Benchmarking 2,000 kcal",
                  style: TextStyle(color: textMuted, fontSize: 11),
                ),
              ],
            ),
          ],

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.INPUT),
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2563eb),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              label: Text(hasData ? "Perbarui Nutrisi Hari Ini" : "Mulai Input Menu Gizi"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard(bool isNormal, dynamic latest) {
    final hasData = latest != null;
    final Color startColor = !hasData 
        ? const Color(0xff64748b)
        : (isNormal ? const Color(0xff2563eb) : const Color(0xffef4444));
    final Color endColor = !hasData
        ? const Color(0xff475569)
        : (isNormal ? const Color(0xff3b82f6) : const Color(0xfff87171));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(height: 14),
          Text(
            hasData ? "Rekomendasi Gizi AI" : "Morning Insight",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasData 
                ? latest.rekomendasi 
                : "Belum ada riwayat gizi hari ini. Lengkapi menu makanan pagi, siang, dan malam agar AI dapat menyusun analisis gizi & rekomendasi kesehatan yang dipersonalisasi untuk Anda.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealLogsCard(
    BuildContext context,
    Color cardBg,
    Color textMain,
    Color textMuted,
    bool isDark,
    dynamic latest,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xff1e293b) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Menu Konsumsi Hari Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textMain,
            ),
          ),
          const SizedBox(height: 16),
          _mealRow(context, Icons.wb_sunny_outlined, "Sarapan (Pagi)", latest.sarapan, latest.fotoPagi, textMain, textMuted, const Color(0xfff59e0b)),
          const Divider(height: 20, thickness: 0.5),
          _mealRow(context, Icons.wb_twilight_outlined, "Makan Siang", latest.makanSiang, latest.fotoSiang, textMain, textMuted, const Color(0xff3b82f6)),
          const Divider(height: 20, thickness: 0.5),
          _mealRow(context, Icons.nightlight_outlined, "Makan Malam", latest.makanMalam, latest.fotoMalam, textMain, textMuted, const Color(0xff8b5cf6)),
        ],
      ),
    );
  }

  Widget _mealRow(
    BuildContext context,
    IconData icon,
    String mealType,
    String mealContent,
    String base64Str,
    Color textMain,
    Color textMuted,
    Color iconBgColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconBgColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                mealContent,
                style: TextStyle(
                  fontSize: 14,
                  color: textMain,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
    );
  }

  Widget _smallCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color cardBg,
    required Color textMain,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xff2563eb),
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg, Color textMain, bool isDark) {
    final alignment = msg.isUser ? Alignment.topRight : Alignment.topLeft;
    final bubbleBg = msg.isUser 
        ? const Color(0xff2563eb) 
        : (isDark ? const Color(0xff1e293b) : const Color(0xfff1f5f9));
    final bubbleTextColor = msg.isUser 
        ? Colors.white 
        : textMain;
    final borderRadius = msg.isUser 
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: alignment,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleBg,
            borderRadius: borderRadius,
          ),
          constraints: BoxConstraints(maxWidth: Get.width * 0.75),
          child: Text(
            msg.text,
            style: TextStyle(
              color: bubbleTextColor,
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(Color textMuted, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1e293b) : const Color(0xfff1f5f9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textMuted),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Sedang mengetik...",
                style: TextStyle(
                  color: textMuted,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChips(HomeController controller, Color textMain, bool isDark) {
    final chipBg = isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0);
    final suggestions = [
      "Makanan Sehat 🥬",
      "Tips Diet 🏃‍♂️",
      "Kontrol Gula 🍚",
      "Batasi Garam 🧂",
      "Fitur App 🩺",
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, idx) {
          final suggestion = suggestions[idx];
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ActionChip(
              label: Text(
                suggestion,
                style: TextStyle(
                  color: textMain,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: chipBg,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide.none,
              ),
              onPressed: () {
                controller.sendMessage(suggestion);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _chatBot(Color cardBg, Color textMain, Color textMuted, bool isDark) {
    final controller = Get.find<HomeController>();
    final c = TextEditingController();
    final scrollController = ScrollController();

    // Auto-scroll on new message
    ever(controller.chatMessages, (_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });

    return Container(
      height: Get.height * 0.7,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Chatbot Kesehatan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textMain,
            ),
          ),

          const SizedBox(height: 14),

          // Message history list
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.chatMessages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, idx) {
                  if (idx < controller.chatMessages.length) {
                    final msg = controller.chatMessages[idx];
                    return _buildBubble(msg, textMain, isDark);
                  } else {
                    return _buildTypingIndicator(textMuted, isDark);
                  }
                },
              );
            }),
          ),

          const SizedBox(height: 8),

          // Suggestion Chips
          _buildSuggestionChips(controller, textMain, isDark),

          // Input Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c,
                  style: TextStyle(color: textMain),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      controller.sendMessage(val);
                      c.clear();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Tulis pesan...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: isDark ? const Color(0xff080c14) : const Color(0xfff1f5f9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  final val = c.text;
                  if (val.trim().isNotEmpty) {
                    controller.sendMessage(val);
                    c.clear();
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xff2563eb),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _MetricItem({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsCtrl.isDarkModeEnabled.value;
      final textMain = valueColor ?? (isDark ? Colors.white : const Color(0xff0f172a));
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);
      final containerBg = isDark ? const Color(0xff1e293b) : const Color(0xffdbeafe);
      final iconColor = isDark ? const Color(0xff00f0ff) : const Color(0xff2563eb);

      return Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: containerBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textMain,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}