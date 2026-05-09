import 'package:flutter/material.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat")),
      body: const Center(
        child: Text("Belum ada data"),
      ),
    );
  }
}