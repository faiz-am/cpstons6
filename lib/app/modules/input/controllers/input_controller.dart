import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class InputController extends GetxController {
  final pagiC = TextEditingController();
  final siangC = TextEditingController();
  final malamC = TextEditingController();
  final aktivitasC = TextEditingController();

  // diabetes
  final gulaDarahC = TextEditingController();

  // hipertensi
  final sistolikC = TextEditingController();
  final diastolikC = TextEditingController();

  // obesitas
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();

  var penyakit = "Tidak ada".obs;

  final List<String> penyakitList = [
    "Tidak ada",
    "Diabetes",
    "Hipertensi",
    "Obesitas",
  ];

  void submitData() {
    if (pagiC.text.isEmpty ||
        siangC.text.isEmpty ||
        malamC.text.isEmpty ||
        aktivitasC.text.isEmpty) {
      Get.snackbar("Error", "Semua data utama harus diisi");
      return;
    }

    final data = {
      "pagi": pagiC.text,
      "siang": siangC.text,
      "malam": malamC.text,
      "aktivitas": aktivitasC.text,
      "penyakit": penyakit.value,
    };

    if (penyakit.value == "Diabetes") {
      if (gulaDarahC.text.isEmpty) {
        Get.snackbar("Error", "Gula darah harus diisi");
        return;
      }

      data["gula_darah"] = gulaDarahC.text;
    }

    if (penyakit.value == "Hipertensi") {
      if (sistolikC.text.isEmpty || diastolikC.text.isEmpty) {
        Get.snackbar("Error", "Tekanan darah harus diisi");
        return;
      }

      data["sistolik"] = sistolikC.text;
      data["diastolik"] = diastolikC.text;
    }

    if (penyakit.value == "Obesitas") {
      if (tinggiC.text.isEmpty || beratC.text.isEmpty) {
        Get.snackbar("Error", "Tinggi dan berat badan harus diisi");
        return;
      }

      data["tinggi"] = tinggiC.text;
      data["berat"] = beratC.text;
    }

    Get.toNamed(
      Routes.REKOMENDASI,
      arguments: data,
    );
  }

  @override
  void onClose() {
    pagiC.dispose();
    siangC.dispose();
    malamC.dispose();
    aktivitasC.dispose();

    gulaDarahC.dispose();

    sistolikC.dispose();
    diastolikC.dispose();

    tinggiC.dispose();
    beratC.dispose();

    super.onClose();
  }
}