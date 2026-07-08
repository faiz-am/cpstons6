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
            "Dashboard Analitik",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textMain),
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
                      // Overview Header Section
                      _buildOverviewSection(controller, cardBg, textMain, textMuted, borderColor),
                      const SizedBox(height: 20),

                      if (isWide) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildBarChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                            const SizedBox(width: 20),
                            Expanded(child: _buildPieChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildExtLineChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                            const SizedBox(width: 20),
                            Expanded(child: _buildLineChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark)),
                          ],
                        ),
                      ] else ...[
                        // Chart 1: Bar Chart (Big Data - Top Calories)
                        _buildBarChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                        const SizedBox(height: 20),

                        // Chart 2: Pie Chart (Big Data - Health Distribution)
                        _buildPieChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                        const SizedBox(height: 20),

                        // Chart 2.5: Line Chart (Big Data - Calories Progression)
                        _buildExtLineChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                        const SizedBox(height: 20),

                        // Chart 3: Line Chart (User Nutrition Progression)
                        _buildLineChartSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                      ],
                      const SizedBox(height: 20),

                      // Section 4: Foods List (Big Data)
                      _buildFoodsListSection(controller, cardBg, textMain, textMuted, borderColor, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  // --- Overview Card ---
  Widget _buildOverviewSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor) {
    final summary = controller.bigDataSummary;
    final totalFoods = summary['total_foods'] ?? 0;
    final avgCal = summary['avg_calories'] ?? 0.0;
    final avgProt = summary['avg_protein'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color(0xff2563eb), size: 28),
              const SizedBox(width: 8),
              Text(
                "Rangkuman Big Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCol("Total Makanan", "$totalFoods item", textMain, textMuted),
              _buildStatCol("Rata-rata Kalori", "${avgCal} kcal", textMain, textMuted),
              _buildStatCol("Rata-rata Protein", "${avgProt}g", textMain, textMuted),
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
        Text(label, style: TextStyle(fontSize: 12, color: textMuted)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textMain)),
      ],
    );
  }

  // --- CHART 1: BAR CHART (BIG DATA) ---
  Widget _buildBarChartSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final foods = controller.topCaloriesFoods;

    double maxCal = 600.0;
    for (var f in foods) {
      final cal = (f['calories'] as num?)?.toDouble() ?? 0.0;
      if (cal > maxCal) {
        maxCal = cal;
      }
    }
    final double computedMaxY = ((maxCal * 1.15) / 100).ceil() * 100.0;

    return Container(
      height: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top 5 Makanan Tinggi Kalori (Big Data)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
          ),
          const SizedBox(height: 4),
          Text(
            "Diambil dari FatSecret Big Data database.",
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: foods.isEmpty
                ? Center(child: Text("Tidak ada data", style: TextStyle(color: textMain)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: computedMaxY,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: isDark ? const Color(0xff1e293b) : Colors.blue.shade50,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final foodName = foods[groupIndex]['name'] ?? 'Makanan';
                            return BarTooltipItem(
                              "$foodName\n${rod.toY.round()} kcal",
                              TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 12),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final int index = value.toInt();
                              if (index >= 0 && index < foods.length) {
                                final String rawName = foods[index]['name'] ?? '';
                                final String shortName = rawName.length > 8
                                    ? "${rawName.substring(0, 7)}.."
                                    : rawName;
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    shortName,
                                    style: TextStyle(color: textMuted, fontSize: 10),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 28,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  "${value.toInt()}",
                                  style: TextStyle(color: textMuted, fontSize: 9),
                                ),
                              );
                            },
                            reservedSize: 36,
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(foods.length, (index) {
                        final val = (foods[index]['calories'] as num).toDouble();
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: val,
                              color: const Color(0xff2563eb),
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: computedMaxY,
                                color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
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

  // --- CHART 2: PIE CHART (BIG DATA) ---
  Widget _buildPieChartSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final summary = controller.bigDataSummary;
    final int healthy = summary['healthy_count'] ?? 0;
    final int lessHealthy = summary['less_healthy_count'] ?? 0;
    final int total = healthy + lessHealthy;

    final double healthyPercent = total > 0 ? (healthy / total) * 100 : 0.0;
    final double lessHealthyPercent = total > 0 ? (lessHealthy / total) * 100 : 0.0;

    return Container(
      height: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distribusi Kehalalan Gizi (Big Data)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: total == 0
                ? Center(child: Text("Tidak ada data", style: TextStyle(color: textMain)))
                : Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xff10b981),
                                value: healthyPercent,
                                title: "${healthyPercent.toStringAsFixed(1)}%",
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: const Color(0xfff43f5e),
                                value: lessHealthyPercent,
                                title: "${lessHealthyPercent.toStringAsFixed(1)}%",
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(const Color(0xff10b981), "Healthy ($healthy)", textMain),
                          const SizedBox(height: 8),
                          _buildLegendItem(const Color(0xfff43f5e), "Less Healthy ($lessHealthy)", textMain),
                        ],
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, Color textMain) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13, color: textMain, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // --- CHART 3: LINE CHART (USER DATA) ---
  Widget _buildLineChartSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final history = controller.userHistoryList;

    return Container(
      height: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress Kesehatan Harian Anda (User)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
          ),
          const SizedBox(height: 4),
          Text(
            "Menampilkan riwayat skor kesehatan (0 - 100) gizi Anda.",
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_toggle_off_rounded, color: textMuted, size: 40),
                        const SizedBox(height: 8),
                        Text("Belum ada riwayat konsumsi Anda", style: TextStyle(color: textMuted, fontSize: 13)),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  "${value.toInt()}",
                                  style: TextStyle(color: textMuted, fontSize: 9),
                                ),
                              );
                            },
                            reservedSize: 24,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1.0,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final int index = value.toInt();
                              if (value != index.toDouble()) {
                                return const SizedBox();
                              }
                              if (index >= 0 && index < history.length) {
                                final String dateStr = history[index].tanggal;
                                // Display only date part e.g. "25 Jun" or just day number
                                final parts = dateStr.split(" ");
                                final String shortDate = parts.length >= 2
                                    ? "${parts[0]} ${parts[1].substring(0, min(3, parts[1].length))}"
                                    : dateStr;
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    shortDate,
                                    style: TextStyle(color: textMuted, fontSize: 9),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 24,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: 100,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: isDark ? const Color(0xff1e293b) : Colors.blue.shade50,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final data = history[spot.x.toInt()];
                              return LineTooltipItem(
                                "Skor: ${spot.y.round()}\nStatus: ${data.statusKondisi}",
                                TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 12),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(history.length, (index) {
                            final double score = history[index].skor.toDouble();
                            return FlSpot(index.toDouble(), score);
                          }),
                          isCurved: true,
                          color: const Color(0xff10b981),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xff10b981).withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;

  // --- SECTION 4: FOODS LIST (BIG DATA) ---
  Widget _buildFoodsListSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final searchC = TextEditingController();

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
              const Icon(Icons.dataset_rounded, color: Color(0xff7c3aed), size: 24),
              const SizedBox(width: 8),
              Text(
                "Eksplorasi FatSecret Big Data",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Cari dan ketahui kandungan gizi dari puluhan makanan hasil ekstraksi dataset.",
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 16),
          
          // Search Field
          TextField(
            controller: searchC,
            style: TextStyle(color: textMain, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Cari makanan (misal: rice, chicken)...",
              hintStyle: TextStyle(color: textMuted, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: textMuted, size: 18),
                onPressed: () {
                  searchC.clear();
                  controller.fetchBigDataFoods("");
                },
              ),
              filled: true,
              fillColor: isDark ? const Color(0xff182235) : Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (val) {
              controller.fetchBigDataFoods(val.trim());
            },
          ),
          const SizedBox(height: 18),

          // Foods List Builder
          Obx(() {
            if (controller.isFoodsLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final foods = controller.bigDataFoods;
            if (foods.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, color: textMuted, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        "Makanan tidak ditemukan",
                        style: TextStyle(color: textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foods.length,
              separatorBuilder: (context, index) => Divider(color: borderColor, height: 20),
              itemBuilder: (context, index) {
                final food = foods[index];
                final String name = food['name'] ?? 'Makanan';
                final double cal = food['calories'] ?? 0.0;
                final double prot = food['protein'] ?? 0.0;
                final double fat = food['fat'] ?? 0.0;
                final double carbs = food['carbs'] ?? 0.0;
                final String status = food['health_status'] ?? 'Healthy';
                final isHealthy = status == 'Healthy';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isHealthy 
                                ? const Color(0xff10b981).withOpacity(0.12)
                                : const Color(0xffef4444).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isHealthy ? const Color(0xff10b981) : const Color(0xffef4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Nutrient Specs Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNutrientTag("🔥 Kalori", "${cal.round()} kcal", Colors.orange, textMuted),
                        _buildNutrientTag("💪 Protein", "${prot.toStringAsFixed(1)}g", Colors.blue, textMuted),
                        _buildNutrientTag("🍞 Karbo", "${carbs.toStringAsFixed(1)}g", Colors.amber.shade700, textMuted),
                        _buildNutrientTag("🥑 Lemak", "${fat.toStringAsFixed(1)}g", Colors.red.shade400, textMuted),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNutrientTag(String label, String value, Color color, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // --- CHART 2.5: LINE CHART (BIG DATA - EXTERNAL) ---
  Widget _buildExtLineChartSection(AnalyticsController controller, Color cardBg, Color textMain, Color textMuted, Color borderColor, bool isDark) {
    final foods = controller.topCaloriesFoods;

    double maxCal = 600.0;
    for (var f in foods) {
      final cal = (f['calories'] as num?)?.toDouble() ?? 0.0;
      if (cal > maxCal) {
        maxCal = cal;
      }
    }
    final double computedMaxY = ((maxCal * 1.15) / 100).ceil() * 100.0;

    return Container(
      height: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress Kalori Makanan (Big Data)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
          ),
          const SizedBox(height: 4),
          Text(
            "Menampilkan perbandingan kalori (kcal) makanan terpopuler.",
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: foods.isEmpty
                ? Center(child: Text("Tidak ada data", style: TextStyle(color: textMain)))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  "${value.toInt()}",
                                  style: TextStyle(color: textMuted, fontSize: 9),
                                ),
                              );
                            },
                            reservedSize: 36,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1.0,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final int index = value.toInt();
                              if (value != index.toDouble()) {
                                return const SizedBox();
                              }
                              if (index >= 0 && index < foods.length) {
                                final String rawName = foods[index]['name'] ?? '';
                                final String shortName = rawName.length > 8
                                    ? "${rawName.substring(0, 7)}.."
                                    : rawName;
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    shortName,
                                    style: TextStyle(color: textMuted, fontSize: 9),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 24,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: computedMaxY,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: isDark ? const Color(0xff1e293b) : Colors.blue.shade50,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final food = foods[spot.x.toInt()];
                              final String name = food['name'] ?? 'Makanan';
                              return LineTooltipItem(
                                "$name\n${spot.y.round()} kcal",
                                TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 12),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(foods.length, (index) {
                            final double cal = (foods[index]['calories'] as num).toDouble();
                            return FlSpot(index.toDouble(), cal);
                          }),
                          isCurved: true,
                          color: const Color(0xff7c3aed), // Purple styling to match external data
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xff7c3aed).withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
