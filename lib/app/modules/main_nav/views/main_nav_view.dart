import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehat_app/app/modules/auth/controllers/auth_controller.dart';

import '../../home/views/home_view.dart';
import '../../insight/views/insight_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    if (!auth.isLoggedIn.value) {
      Future.microtask(() => Get.offAllNamed('/login'));
    }

    final pages = [
      const HomeView(),
      const InsightView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff2563eb),
          unselectedItemColor: const Color(0xff94a3b8),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              label: "Insight",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}