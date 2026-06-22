part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const MAIN_NAV = _Paths.MAIN_NAV;
  static const HOME = _Paths.HOME;
  static const INPUT = _Paths.INPUT;
  static const REKOMENDASI = _Paths.REKOMENDASI;
  static const SETTINGS = _Paths.SETTINGS;
  static const RIWAYAT = _Paths.RIWAYAT;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const INSIGHT = _Paths.INSIGHT;
  static const VERIFY_OTP = _Paths.VERIFY_OTP;
}

abstract class _Paths {
  _Paths._();
  static const MAIN_NAV = '/main-nav';
  static const HOME = '/home';
  static const INPUT = '/input';
  static const REKOMENDASI = '/rekomendasi';
  static const SETTINGS = '/settings';
  static const RIWAYAT = '/riwayat';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const INSIGHT = '/insight';
  static const VERIFY_OTP = '/verify-otp';
}
