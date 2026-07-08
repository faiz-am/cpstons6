import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/input_controller.dart';

class InputView extends GetView<InputController> {
  const InputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Input Data Kesehatan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(Routes.MAIN_NAV),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ====================================================
            // MAKANAN DENGAN PARAMETER CONTEXT (SUDAH DIPERBAIKI)
            // ====================================================
            _foodField(
              context: context, // <-- OPER CONTEXT DI SINI
              label: "Makanan Pagi",
              icon: Icons.wb_sunny_outlined,
              foodController: controller.pagiC,
              porsiController: controller.pagiPorsiC,
              satuanObs: controller.pagiSatuan,
              foodObs: controller.pagiMakanan,
              type: "pagi",
            ),
            const SizedBox(height: 20),
            _foodField(
              context: context, // <-- OPER CONTEXT DI SINI
              label: "Makanan Siang",
              icon: Icons.lunch_dining_outlined,
              foodController: controller.siangC,
              porsiController: controller.siangPorsiC,
              satuanObs: controller.siangSatuan,
              foodObs: controller.siangMakanan,
              type: "siang",
            ),
            const SizedBox(height: 20),
            _foodField(
              context: context, // <-- OPER CONTEXT DI SINI
              label: "Makanan Malam",
              icon: Icons.nightlight_outlined,
              foodController: controller.malamC,
              porsiController: controller.malamPorsiC,
              satuanObs: controller.malamSatuan,
              foodObs: controller.malamMakanan,
              type: "malam",
            ),
            const SizedBox(height: 25),

            // ================== FIELD AKTIVITAS & PENYAKIT ==================
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.aktivitas.value,
                    decoration: _inputDecoration("Aktivitas", Icons.directions_run),
                    items: controller.aktivitasList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => controller.aktivitas.value = v!,
                  )),
                ),
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Kategori Aktivitas",
                      content: const Column(
                        children: [
                          Text("Ringan:\nDuduk, belajar, kerja kantor\n"),
                          Text("Sedang:\nJalan kaki, bersih rumah\n"),
                          Text("Berat:\nGym, lari, angkat beban"),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.penyakit.value,
              decoration: _inputDecoration("Pilih Penyakit", Icons.health_and_safety),
              items: controller.penyakitList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => controller.penyakit.value = v!,
            )),
            const SizedBox(height: 20),
            
            // FORM DINAMIS PENYAKIT
            Obx(() {
              if (controller.penyakit.value == "Diabetes") {
                return _textField(controller: controller.gulaDarahC, label: "Gula Darah (mg/dL)", icon: Icons.monitor_heart);
              }
              if (controller.penyakit.value == "Hipertensi") {
                return Column(
                  children: [
                    _textField(controller: controller.sistolikC, label: "Sistolik", icon: Icons.favorite),
                    const SizedBox(height: 12),
                    _textField(controller: controller.diastolikC, label: "Diastolik", icon: Icons.favorite),
                  ],
                );
              }
              if (controller.penyakit.value == "Obesitas") {
                return Column(
                  children: [
                    _textField(controller: controller.tinggiC, label: "Tinggi Badan (cm)", icon: Icons.height),
                    const SizedBox(height: 12),
                    _textField(controller: controller.beratC, label: "Berat Badan (kg)", icon: Icons.monitor_weight),
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
                child: const Text("Lanjut ke Rekomendasi", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // 🌟 MODIFIKASI FOOD FIELD (FIX AUTO-FILL 100% WORKING)
  // ====================================================
  Widget _foodField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required TextEditingController foodController,
    required TextEditingController porsiController,
    required RxString satuanObs,
    required RxString foodObs,
    required String type,
  }) {
    // Kita buat variabel penampung local controller agar bisa diakses di onSelected
    TextEditingController? internalController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final listFoods = controller.daftarMakanan;
          if (listFoods.isEmpty) {
            return DropdownButtonFormField<String>(
              decoration: _inputDecoration(label, icon),
              items: const [],
              onChanged: null,
              hint: const Text("Loading makanan..."),
            );
          }
          
          final selectedValue = foodObs.value.isNotEmpty && listFoods.contains(foodObs.value) 
              ? foodObs.value 
              : listFoods.first;
              
          if (foodController.text != selectedValue) {
            foodController.text = selectedValue;
          }

          return DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: _inputDecoration(label, icon),
            items: listFoods.map((food) {
              return DropdownMenuItem<String>(
                value: food,
                child: Text(food),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                foodObs.value = v;
                foodController.text = v;
              }
            },
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: porsiController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Jumlah", Icons.scale),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Obx(() => DropdownButtonFormField<String>(
                value: satuanObs.value,
                decoration: _inputDecoration("Satuan", Icons.unfold_more),
                items: const [
                  DropdownMenuItem(value: "gram", child: Text("Gram")),
                  DropdownMenuItem(value: "mangkok", child: Text("Mangkok")),
                  DropdownMenuItem(value: "porsi", child: Text("Porsi")),
                  DropdownMenuItem(value: "bungkus", child: Text("Bungkus")),
                  DropdownMenuItem(value: "tusuk", child: Text("Tusuk")),
                  DropdownMenuItem(value: "besar", child: Text("Besar")),
                ],
                onChanged: (v) => satuanObs.value = v!,
              )),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => controller.pickImage(type),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          Uint8List? imageBytes;
          if (type == "pagi") imageBytes = controller.pagiImage.value;
          if (type == "siang") imageBytes = controller.siangImage.value;
          if (type == "malam") imageBytes = controller.malamImage.value;
          if (imageBytes == null) return const SizedBox();
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(imageBytes, height: 140, width: double.infinity, fit: BoxFit.cover),
          );
        }),
      ],
    );
  }

  Widget _textField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    );
  }
}