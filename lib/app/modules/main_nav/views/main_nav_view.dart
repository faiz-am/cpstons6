import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../settings/controllers/settings_controller.dart';

import '../../home/views/home_view.dart';
import '../../insight/views/insight_view.dart';
import '../../analytics/views/analytics_view.dart';
import '../../settings/views/settings_view.dart';

import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {

  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Get.find<AuthController>();
    final settingsCtrl = Get.find<SettingsController>();

    if (!auth.isLoggedIn.value) {
      Future.microtask(() {
        Get.offAllNamed('/login');
      });
    }

    final pages = const [
      HomeView(),
      InsightView(),
      AnalyticsView(),
      SettingsView(),
    ];

    return Scaffold(

      body: Obx(() {

        return IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        );
      }),

      bottomNavigationBar: Obx(() {
        final isDark = settingsCtrl.isDarkModeEnabled.value;

        return BottomNavigationBar(
          backgroundColor: isDark ? const Color(0xff0f1524) : Colors.white,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,

          selectedItemColor: const Color(0xff2563eb),
          unselectedItemColor: const Color(0xff94a3b8),
          type: BottomNavigationBarType.fixed,

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: "Tips",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: "Analytics",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        );
      }),
    );
  }
}