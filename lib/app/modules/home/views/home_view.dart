import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final horizontal = w > 700 ? w * 0.12 : w * 0.05;

        return Scaffold(
          backgroundColor: const Color(0xfff5f9ff),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff2563eb),
            onPressed: () {
              Get.bottomSheet(
                _chatBot(),
                isScrollControlled: true,
              );
            },
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f172a),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Pantau aktivitas sehat harianmu.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff64748b),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _overviewCard(),

                  const SizedBox(height: 18),

                  _insightCard(),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: _smallCard(
                          title: "Hydration",
                          value: "1.8 / 2.5L",
                          subtitle: "72% tercapai",
                          icon: Icons.water_drop_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _smallCard(
                          title: "Aktivitas",
                          value: "45 mins",
                          subtitle: "Goal achieved",
                          icon: Icons.directions_run,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _overviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Overview",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0f172a),
                ),
              ),
              Chip(
                label: Text("Today"),
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
                    color: const Color(0xff2563eb),
                    width: 7,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "82",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f172a),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Skor Sehat",
                        style: TextStyle(
                          color: Color(0xff64748b),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              const Expanded(
                child: Column(
                  children: [
                    _MetricItem(
                      icon: Icons.local_fire_department_outlined,
                      title: "Kalori",
                      value: "1,240 kcal",
                    ),
                    SizedBox(height: 12),
                    _MetricItem(
                      icon: Icons.directions_run,
                      title: "Aktivitas",
                      value: "45 mins",
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.INPUT),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2563eb),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text("Input Data"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2563eb),
            Color(0xff3b82f6),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            "Morning Insight",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Aktivitas hari ini lebih baik dari kemarin. Pertahankan ritme sehatmu.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCard({
    required String title,
    required String value,
    required String subtitle,
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
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff64748b),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff64748b),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatBot() {
    final c = TextEditingController();

    return Container(
      height: Get.height * 0.65,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
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

          const SizedBox(height: 16),

          const Text(
            "Chatbot Kesehatan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          const Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Halo 👋 Ada yang bisa saya bantu?",
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c,
                  decoration: InputDecoration(
                    hintText: "Tulis pesan...",
                    filled: true,
                    fillColor: const Color(0xfff1f5f9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
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

  const _MetricItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xffdbeafe),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: const Color(0xff2563eb),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff64748b),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0f172a),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}