import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/riwayat_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class HomeController extends GetxController {
  var isLoading = false.obs;
  var displayName = "Pengguna Sehat".obs;
  var latestRiwayat = Rxn<RiwayatModel>();

  final String baseUrl = "http://127.0.0.1:5000/api";
  final GetConnect _connect = GetConnect();
  final _storage = const FlutterSecureStorage();

  // Chatbot State
  var chatMessages = <ChatMessage>[].obs;
  var isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    // Default greeting
    chatMessages.add(ChatMessage(
      text: "Halo! 👋 Saya Asisten Kesehatan Sehat Kita. Tanyakan apa saja tentang pola makan sehat, diet, cara kontrol gula/garam, atau tentang fitur aplikasi ini.",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final email = auth.userEmail.value;

      if (email.isNotEmpty) {
        // 1. Ambil Nama Profil dari SecureStorage
        final savedName = await _storage.read(key: "${email}_profile_name");
        if (savedName != null && savedName.trim().isNotEmpty) {
          displayName.value = savedName;
        } else {
          // Fallback ke bagian depan email
          if (email.contains('@')) {
            displayName.value = email.split('@')[0];
          } else {
            displayName.value = email;
          }
        }

        // 2. Ambil data riwayat terakhir dari backend
        final response = await _connect.get('$baseUrl/ambil-riwayat?username=$email');

        if (response.body != null && response.body['success'] == true) {
          final List dataAsli = response.body['data'];
          if (dataAsli.isNotEmpty) {
            // Indeks pertama (dataAsli[0]) adalah riwayat terbaru
            latestRiwayat.value = RiwayatModel.fromJson(dataAsli.first);
          } else {
            latestRiwayat.value = null;
          }
        } else {
          latestRiwayat.value = null;
        }
      }
    } catch (e) {
      print("Eror Fetch Dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Chatbot logic - terhubung ke backend Flask
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Tambah pesan pengguna
    chatMessages.add(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Aktifkan indikator mengetik
    isTyping.value = true;

    try {
      // Kirim request ke API chat di backend
      final response = await _connect.post(
        '$baseUrl/chat',
        {'message': message},
      );

      if (response.statusCode == 200 && response.body != null && response.body['success'] == true) {
        final reply = response.body['reply']?.toString() ?? "Tidak ada respon dari asisten.";
        chatMessages.add(ChatMessage(
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else {
        String errMsg = "Gagal mendapatkan respon dari server.";
        if (response.body != null && response.body['message'] != null) {
          errMsg = response.body['message'].toString();
        }
        chatMessages.add(ChatMessage(
          text: "⚠️ Eror: $errMsg",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      chatMessages.add(ChatMessage(
        text: "⚠️ Koneksi Terputus: Gagal terhubung ke backend ($e)",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      // Matikan indikator mengetik
      isTyping.value = false;
    }
  }
}

