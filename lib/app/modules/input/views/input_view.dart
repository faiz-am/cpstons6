import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/input_controller.dart';

class InputView extends GetView<InputController> {
  const InputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Data"),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Get.offAllNamed(Routes.MAIN_NAV);
        },
      ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // MAKANAN PAGI
            // =========================

            _foodField(
              label: "Makanan Pagi",
              icon: Icons.wb_sunny_outlined,
              foodController: controller.pagiC,
              porsiController: controller.pagiPorsiC,
              type: "pagi",
            ),

            const SizedBox(height: 20),

            // =========================
            // MAKANAN SIANG
            // =========================

            _foodField(
              label: "Makanan Siang",
              icon: Icons.lunch_dining_outlined,
              foodController: controller.siangC,
              porsiController: controller.siangPorsiC,
              type: "siang",
            ),

            const SizedBox(height: 20),

            // =========================
            // MAKANAN MALAM
            // =========================

            _foodField(
              label: "Makanan Malam",
              icon: Icons.nightlight_outlined,
              foodController: controller.malamC,
              porsiController: controller.malamPorsiC,
              type: "malam",
            ),

            const SizedBox(height: 25),

            // =========================
            // AKTIVITAS
            // =========================

            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.aktivitas.value,
                      decoration: _inputDecoration(
                        "Aktivitas",
                        Icons.directions_run,
                      ),
                      items: controller.aktivitasList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.aktivitas.value = v!;
                      },
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Kategori Aktivitas",
                      content: const Column(
                        children: [
                          Text(
                            "Ringan:\n"
                            "Duduk, belajar, kerja kantor",
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Sedang:\n"
                            "Jalan kaki, bersih rumah",
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Berat:\n"
                            "Gym, lari, angkat beban",
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // PENYAKIT
            // =========================

            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.penyakit.value,
                decoration: _inputDecoration(
                  "Pilih Penyakit",
                  Icons.health_and_safety,
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

            const SizedBox(height: 20),

            // =========================
            // FORM PENYAKIT
            // =========================

            Obx(() {
              if (controller.penyakit.value == "Diabetes") {
                return _textField(
                  controller: controller.gulaDarahC,
                  label: "Gula Darah (mg/dL)",
                  icon: Icons.monitor_heart,
                );
              }

              if (controller.penyakit.value == "Hipertensi") {
                return Column(
                  children: [
                    _textField(
                      controller: controller.sistolikC,
                      label: "Sistolik",
                      icon: Icons.favorite,
                    ),

                    const SizedBox(height: 12),

                    _textField(
                      controller: controller.diastolikC,
                      label: "Diastolik",
                      icon: Icons.favorite,
                    ),
                  ],
                );
              }

              if (controller.penyakit.value == "Obesitas") {
                return Column(
                  children: [
                    _textField(
                      controller: controller.tinggiC,
                      label: "Tinggi Badan (cm)",
                      icon: Icons.height,
                    ),

                    const SizedBox(height: 12),

                    _textField(
                      controller: controller.beratC,
                      label: "Berat Badan (kg)",
                      icon: Icons.monitor_weight,
                    ),
                  ],
                );
              }

              return const SizedBox();
            }),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.submitData,
                child: const Text(
                  "Lanjut",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // FOOD FIELD
  // =========================

  Widget _foodField({
    required String label,
    required IconData icon,
    required TextEditingController foodController,
    required TextEditingController porsiController,
    required String type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadField<String>(
          suggestionsCallback: (search) async {
            return controller.makananList.where(
              (item) {
                return item.toLowerCase().contains(
                      search.toLowerCase(),
                    );
              },
            ).toList();
          },

          itemBuilder: (context, item) {
            return ListTile(
              title: Text(item),
            );
          },

          onSelected: (item) {
            foodController.text = item;
          },

          builder: (
            context,
            textEditingController,
            focusNode,
          ) {
            return TextField(
              controller: foodController,
              focusNode: focusNode,
              decoration: _inputDecoration(
                label,
                icon,
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: porsiController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  "Porsi (gram)",
                  Icons.scale,
                ),
              ),
            ),

            const SizedBox(width: 12),

            InkWell(
              onTap: () {
                controller.pickImage(type);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Obx(() {
          File? image;

          if (type == "pagi") {
            image = controller.pagiImage.value;
          }

          if (type == "siang") {
            image = controller.siangImage.value;
          }

          if (type == "malam") {
            image = controller.malamImage.value;
          }

          if (image == null) {
            return const SizedBox();
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        }),
      ],
    );
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(
        label,
        icon,
      ),
    );
  }

  // =========================
  // INPUT DECORATION
  // =========================

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
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