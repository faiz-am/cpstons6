import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/analytics_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsCtrl.isDarkModeEnabled.value;
      final scaffoldBg = isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff);
      final cardBg = isDark ? const Color(0xff0f1524) : Colors.white;
      final textMain = isDark ? Colors.white : const Color(0xff0f172a);
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);
      final borderColor = isDark ? const Color(0xff1e293b) : Colors.grey.shade200;

      final double w = MediaQuery.of(context).size.width;
      final bool isWide = w > 850;
      final double paddingHorizontal = isWide ? w * 0.08 : 16.0;

      return Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          title: Text(
            "Dashboard Analitik Komparatif",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textMain),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: cardBg,
          iconTheme: IconThemeData(color: textMain),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: textMain),
              onPressed: () => controller.fetchAnalyticsData(),
            )
          ],
        ),
        body: SafeArea(
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rangkuman Atas
                      _buildOverviewSection(controller, cardBg, textMain, textMuted, borderColor),
                      const SizedBox(height: 24),

                      // =========================================================
                      // KATEGORI 1: DATA INTERNAL USER (MYSQL)
                      // =========================================================
                      Text(
                        "1. Analisis Data Internal (Aktivitas Konsumsi Anda)",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xff10b981)),
                      ),
                      const SizedBox(height: 12),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildInternalLineChart(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInternalBarChart(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                          ],
                        )
                      else ...[
                        _buildInternalLineChart(controller, cardBg, textMain, textMuted, borderColor, isDark),
                        const SizedBox(height: 16),
                        _buildInternalBarChart(controller, cardBg, textMain, textMuted, borderColor, isDark),
                      ],

                      const SizedBox(height: 28),

                      // =========================================================
                      // KATEGORI 2: DATA EKSTERNAL DATASET (FATSECRET)
                      // =========================================================
                      Text(
                        "2. Analisis Data Eksternal (Dataset Medis FatSecret)",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xff2563eb)),
                      ),
                      const SizedBox(height: 12),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildExternalBarChart(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildExternalPieChart(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                          ],
                        )
                      else ...[
                        _buildExternalBarChart(controller, cardBg, textMain, textMuted, borderColor, isDark),
                        const SizedBox(height: 16),
                        _buildExternalPieChart(controller, cardBg, textMain, textMuted, borderColor, isDark),
                      ],

                      const SizedBox(height: 24),
                      // Daftar Makanan Dataset
                      _buildFoodsListSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildOverviewSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor) {
    final summary = controller.bigDataSummary;
    final totalFoods = summary['total_foods'] ?? 0;
    final avgCal = summary['avg_calories'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color(0xff2563eb), size: 24),
              const SizedBox(width: 8),
              Text("Dashboard Analitik Skripsi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain)),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildStatCol("Total Data Sampel", "$totalFoods item", textMain, textMuted),
              _buildStatCol("Rata-rata Energi Kalori", "${avgCal} kcal", textMain, textMuted),
              _buildStatCol("Riwayat Log Internal", "${controller.userHistoryList.length} Hari", textMain, textMuted),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String val, Color textMain, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
      ],
    );
  }

  // =========================================================================
  // GRAPH 1 (INTERNAL): LINE CHART - PROGRESS SKOR USER
  // =========================================================================
  Widget _buildInternalLineChart(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final history = controller.userHistoryList;
    if (history.isEmpty) return _emptyBox(cardBg, borderColor, textMuted, "Grafik Internal: Tren Skor Sehat");

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tren Skor Gizi Anda (Internal)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 20, // Menghindari penumpukan teks sumbu Y (0, 20, 40, dst)
                      getTitlesWidget: (value, meta) => Text("${value.toInt()}", style: TextStyle(color: textMuted, fontSize: 9)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < history.length) {
                          return Text(history[idx].tanggal.split(" ")[0], style: TextStyle(color: textMuted, fontSize: 8));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(history.length, (i) => FlSpot(i.toDouble(), history[i].skor.toDouble())),
                    isCurved: true,
                    color: const Color(0xff10b981),
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: const Color(0xff10b981).withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // GRAPH 2 (INTERNAL): BAR CHART - RATA-RATA MAKRO NUTRISI USER (SOLUSI FIX MELEBIHI BATAS)
  // =========================================================================
  Widget _buildInternalBarChart(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final avg = controller.userMacroAverage;
    if (avg.isEmpty) return _emptyBox(cardBg, borderColor, textMuted, "Grafik Internal: Rata-rata Asupan Makro");

    final keys = avg.keys.toList();

    // 🟢 PERBAIKAN TOTAL: Menghitung Max Y secara akurat berdasarkan angka tertinggi dari database
    double highestGram = 100.0; 
    for (var val in avg.values) {
      if (val > highestGram) highestGram = val;
    }
    
    // Memberikan batas atas aman 30% ekstra agar ujung diagram tidak menabrak bingkai atas card
    double computedMaxY = (highestGram * 1.30); 
    // Menghitung interval label sumbu Y secara proporsional (jika data besar, loncatan intervalnya per 50g atau 100g)
    double calculatedInterval = (computedMaxY / 4).roundToDouble();
    if (calculatedInterval < 10) calculatedInterval = 25.0;

    return Container(
      height: 320, // Ditambah sedikit tinggi wadah agar teks aman
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rerata Gram Nutrisi Harian (Internal)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: computedMaxY, // Menggunakan kalkulasi batas dinamis
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36, // Ditambah ruang sumbu kiri agar tidak terpotong
                      interval: calculatedInterval, // Label sumbu Y berloncat rapi secara matematis
                      getTitlesWidget: (value, meta) => Text("${value.toInt()}g", style: TextStyle(color: textMuted, fontSize: 9)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < keys.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(keys[idx], style: TextStyle(color: textMuted, fontSize: 9, fontWeight: FontWeight.bold)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(keys.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: avg[keys[i]] ?? 0.0,
                        color: i == 0 ? Colors.blue : (i == 1 ? Colors.amber.shade700 : Colors.red.shade400),
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // GRAPH 3 (EXTERNAL): BAR CHART - TOP KALORI DATASET (SOLUSI FIX MELEBIHI BATAS)
  // =========================================================================
  Widget _buildExternalBarChart(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final foods = controller.topCaloriesFoods;
    if (foods.isEmpty) return _emptyBox(cardBg, borderColor, textMuted, "Grafik Eksternal: Top Kalori Dataset");

    double maxCal = 500.0;
    for (var f in foods) {
      double cal = (f['calories'] as num).toDouble();
      if (cal > maxCal) maxCal = cal;
    }
    
    double computedMaxY = (maxCal * 1.25); // Bonus 25% area kosong vertikal
    double calculatedInterval = (computedMaxY / 4).roundToDouble();

    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top 5 Makanan Tinggi Kalori (Eksternal Dataset)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: computedMaxY,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: calculatedInterval,
                      getTitlesWidget: (value, meta) => Text("${value.toInt()}", style: TextStyle(color: textMuted, fontSize: 9)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < foods.length) {
                          String name = foods[idx]['name'] ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(name.length > 6 ? "${name.substring(0, 5)}.." : name, style: TextStyle(color: textMuted, fontSize: 9)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(foods.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (foods[i]['calories'] as num).toDouble(),
                        color: const Color(0xff2563eb),
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // GRAPH 4 (EXTERNAL): PIE CHART - DISTRIBUSI STATUS KESEHATAN DATASET
  // =========================================================================
  Widget _buildExternalPieChart(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final summary = controller.bigDataSummary;
    final int healthy = summary['healthy_count'] ?? 0;
    final int lessHealthy = summary['less_healthy_count'] ?? 0;
    final int total = healthy + lessHealthy;

    if (total == 0) return _emptyBox(cardBg, borderColor, textMuted, "Grafik Eksternal: Distribusi Halal Gizi");

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Distribusi Gizi Sampel Dataset (Eksternal)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMain)),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 35,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xff10b981),
                          value: (healthy / total) * 100,
                          title: "${((healthy / total) * 100).toStringAsFixed(0)}%",
                          radius: 40,
                          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          color: const Color(0xfff43f5e),
                          value: (lessHealthy / total) * 100,
                          title: "${((lessHealthy / total) * 100).toStringAsFixed(0)}%",
                          radius: 40,
                          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendRow(const Color(0xff10b981), "Healthy ($healthy)", textMain),
                    const SizedBox(height: 8),
                    _legendRow(const Color(0xfff43f5e), "Less Healthy ($lessHealthy)", textMain),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color c, String text, Color textMain) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 11, color: textMain, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _emptyBox(Color cardBg, Color borderColor, Color textMuted, String title) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Center(
        child: Text("$title\n(Data kosong/Menunggu input gizi)", textAlign: TextAlign.center, style: TextStyle(color: textMuted, fontSize: 12)),
      ),
    );
  }

  // --- EXPLORASI LIST DATASET ---
  Widget _buildFoodsListSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dataset_rounded, color: Color(0xff7c3aed), size: 22),
              const SizedBox(width: 8),
              Text("Eksplorasi FatSecret Big Data", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textMain)),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            style: TextStyle(color: textMain, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Cari makanan sampel dataset...",
              hintStyle: TextStyle(color: textMuted, fontSize: 12),
              prefixIcon: Icon(Icons.search, color: textMuted, size: 18),
              filled: true,
              fillColor: isDark ? const Color(0xff182235) : Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
            onSubmitted: (val) => controller.fetchBigDataFoods(val.trim()),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isFoodsLoading.value) return const Center(child: CircularProgressIndicator());
            final foods = controller.bigDataFoods;
            if (foods.isEmpty) return Center(child: Text("Tidak ada data", style: TextStyle(color: textMuted)));

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: min(5, foods.length),
              separatorBuilder: (c, i) => Divider(color: borderColor),
              itemBuilder: (context, index) {
                final food = foods[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(food['name'] ?? '', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textMain)),
                  subtitle: Text("🔥 ${food['calories']} kcal | 💪 P: ${food['protein']}g | 🥑 L: ${food['fat']}g", style: TextStyle(fontSize: 11, color: textMuted)),
                  trailing: Text(food['health_status'] ?? '', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: food['health_status'] == 'Healthy' ? Colors.green : Colors.red)),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}