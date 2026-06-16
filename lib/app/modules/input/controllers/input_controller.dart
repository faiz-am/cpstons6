import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class InputController extends GetxController {
  // =========================
  // MAKANAN
  // =========================

  final pagiC = TextEditingController();
  final siangC = TextEditingController();
  final malamC = TextEditingController();

  // =========================
  // PORSI (GRAM)
  // =========================

  final pagiPorsiC = TextEditingController();
  final siangPorsiC = TextEditingController();
  final malamPorsiC = TextEditingController();

  // =========================
  // AKTIVITAS
  // =========================

  var aktivitas = "Ringan".obs;

  final aktivitasList = [
    "Ringan",
    "Sedang",
    "Berat",
  ];

  // =========================
  // PENYAKIT
  // =========================

  var penyakit = "Tidak ada".obs;

  final List<String> penyakitList = [
    "Tidak ada",
    "Diabetes",
    "Hipertensi",
    "Obesitas",
  ];

  // diabetes
  final gulaDarahC = TextEditingController();

  // hipertensi
  final sistolikC = TextEditingController();
  final diastolikC = TextEditingController();

  // obesitas
  final tinggiC = TextEditingController();
  final beratC = TextEditingController();

  // =========================
  // IMAGE PICKER
  // =========================

  final picker = ImagePicker();

  var pagiImage = Rx<File?>(null);
  var siangImage = Rx<File?>(null);
  var malamImage = Rx<File?>(null);

  Future<void> pickImage(String type) async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      final file = File(picked.path);

      if (type == "pagi") {
        pagiImage.value = file;
      }

      if (type == "siang") {
        siangImage.value = file;
      }

      if (type == "malam") {
        malamImage.value = file;
      }
    }
  }

  // =========================
  // SUGGESTION MAKANAN
  // =========================

  final List<String> makananList = [
    "Nasi Putih",
    "Nasi Goreng",
    "Mie Ayam",
    "Mie Sedap",
    "Indomie Goreng",
    "Bakso",
    "Ayam Bakar",
    "Ayam Goreng",
    "Telur",
    "Roti",
    "Burger",
    "Pizza",
    "Soto Ayam",
    "Sate Ayam",
    "Rendang",
    "Ikan Bakar",
  ];

  // =========================
  // SUBMIT
  // =========================

  void submitData() {
    if (pagiC.text.isEmpty ||
        siangC.text.isEmpty ||
        malamC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua makanan harus diisi",
      );
      return;
    }

    if (pagiPorsiC.text.isEmpty ||
        siangPorsiC.text.isEmpty ||
        malamPorsiC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Porsi makanan harus diisi",
      );
      return;
    }

    final data = {
      "pagi": pagiC.text,
      "pagi_porsi": pagiPorsiC.text,

      "siang": siangC.text,
      "siang_porsi": siangPorsiC.text,

      "malam": malamC.text,
      "malam_porsi": malamPorsiC.text,

      "aktivitas": aktivitas.value,
      "penyakit": penyakit.value,

      "pagi_image": pagiImage.value?.path,
      "siang_image": siangImage.value?.path,
      "malam_image": malamImage.value?.path,
    };

    // diabetes
    if (penyakit.value == "Diabetes") {
      if (gulaDarahC.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Gula darah harus diisi",
        );
        return;
      }

      data["gula_darah"] = gulaDarahC.text;
    }

    // hipertensi
    if (penyakit.value == "Hipertensi") {
      if (sistolikC.text.isEmpty ||
          diastolikC.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Tekanan darah harus diisi",
        );
        return;
      }

      data["sistolik"] = sistolikC.text;
      data["diastolik"] = diastolikC.text;
    }

    // obesitas
    if (penyakit.value == "Obesitas") {
      if (tinggiC.text.isEmpty ||
          beratC.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Tinggi dan berat badan harus diisi",
        );
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

    pagiPorsiC.dispose();
    siangPorsiC.dispose();
    malamPorsiC.dispose();

    gulaDarahC.dispose();

    sistolikC.dispose();
    diastolikC.dispose();

    tinggiC.dispose();
    beratC.dispose();

    super.onClose();
  }
}