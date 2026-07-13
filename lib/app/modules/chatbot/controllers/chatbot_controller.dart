import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

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

class ChatbotController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  var chatMessages = <ChatMessage>[].obs;
  var isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    chatMessages.add(ChatMessage(
      text: "Halo! 👋 Saya Asisten Kesehatan Sehat Kita. Tanyakan apa saja tentang pola makan sehat, diet, cara kontrol gula/garam, atau tentang fitur aplikasi ini.",
      isUser: false,
      timestamp: DateTime.now(),
    ));

    ever(chatMessages, (_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    chatMessages.add(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    textController.clear();
    isTyping.value = true;

    try {
      final response = await _api.post(
        '/api/chat',
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
      isTyping.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}