import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/input_controller.dart';

class InputView extends GetView<InputController> {
  const InputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Data"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final horizontal = w > 700 ? w * 0.15 : w * 0.05;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerCard(),

                  const SizedBox(height: 24),

                  const Text(
                    "Makanan Harian",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _field(
                    controller: controller.pagiC,
                    label: "Makanan Pagi",
                    icon: Icons.wb_sunny_outlined,
                  ),

                  const SizedBox(height: 12),

                  _field(
                    controller: controller.siangC,
                    label: "Makanan Siang",
                    icon: Icons.lunch_dining_outlined,
                  ),

                  const SizedBox(height: 12),

                  _field(
                    controller: controller.malamC,
                    label: "Makanan Malam",
                    icon: Icons.nightlight_outlined,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Aktivitas",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _field(
                    controller: controller.aktivitasC,
                    label: "Aktivitas",
                    icon: Icons.directions_run,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Kondisi Kesehatan",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.penyakit.value,
                      decoration: _inputDecoration(
                        "Pilih kondisi",
                        Icons.health_and_safety_outlined,
                      ),
                      items: controller.penyakitList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.penyakit.value = v!;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  Obx(() {
                    if (controller.penyakit.value == "Diabetes") {
                      return _field(
                        controller: controller.gulaDarahC,
                        label: "Gula Darah (mg/dL)",
                        icon: Icons.monitor_heart_outlined,
                        keyboardType: TextInputType.number,
                      );
                    }

                    if (controller.penyakit.value == "Hipertensi") {
                      return Column(
                        children: [
                          _field(
                            controller: controller.sistolikC,
                            label: "Sistolik",
                            icon: Icons.favorite_border,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          _field(
                            controller: controller.diastolikC,
                            label: "Diastolik",
                            icon: Icons.favorite_border,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      );
                    }

                    if (controller.penyakit.value == "Obesitas") {
                      return Column(
                        children: [
                          _field(
                            controller: controller.tinggiC,
                            label: "Tinggi Badan (cm)",
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          _field(
                            controller: controller.beratC,
                            label: "Berat Badan (kg)",
                            icon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  }),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: controller.submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2563eb),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Lanjut ke Rekomendasi"),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
          Text(
            "Catat Gaya Hidup Harian",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Masukkan makanan, aktivitas, dan kondisi kesehatan.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}