import 'package:get/get.dart';

import '../modules/home/views/home_view.dart';
import '../modules/input/controllers/input_controller.dart';
import '../modules/input/views/input_view.dart';
import '../modules/insight/bindings/insight_binding.dart';
import '../modules/insight/views/insight_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_nav/controllers/main_nav_controller.dart';
import '../modules/main_nav/views/main_nav_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/rekomendasi/controllers/rekomendasi_controller.dart';
import '../modules/rekomendasi/views/rekomendasi_view.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/scan/controllers/scan_controller.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // MAIN NAV (ROOT)
    GetPage(
      name: _Paths.MAIN_NAV,
      page: () => const MainNavView(),

      binding: BindingsBuilder(() {

        Get.put(
          MainNavController(),
        );

        Get.put(
          ScanController(),
        );

      }),
    ),

    GetPage(name: _Paths.HOME, page: () => const HomeView()),

    GetPage(
      name: _Paths.INPUT,
      page: () => const InputView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => InputController());
      }),
    ),

    GetPage(
      name: _Paths.REKOMENDASI,
      page: () => const RekomendasiView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RekomendasiController());
      }),
    ),

    GetPage(name: _Paths.SETTINGS, page: () => const SettingsView()),
    GetPage(name: _Paths.RIWAYAT, page: () => const RiwayatView()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.INSIGHT,
      page: () => const InsightView(),
      binding: InsightBinding(),
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),
  ];
}
