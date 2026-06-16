import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rekomendasi_controller.dart';

class RekomendasiView extends GetView<RekomendasiController> {
  const RekomendasiView({super.key});

  @override
  Widget build(BuildContext context) {
    double w = Get.width;
    double h = Get.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Rekomendasi")),
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [

            Container(
              width: w,
              padding: EdgeInsets.all(w * 0.04),
              color: Colors.green.shade100,
              child: Text("${controller.kalori} kcal"),
            ),

            SizedBox(height: h * 0.02),

            Container(
              width: w,
              padding: EdgeInsets.all(w * 0.04),
              color: Colors.orange.shade100,
              child: Text(controller.saran),
            ),
          ],
        ),
      ),
    );
  }
}