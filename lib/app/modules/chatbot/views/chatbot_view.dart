import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settingsCtrl.isDarkModeEnabled.value;
      final cardBg = isDark ? const Color(0xff0f1524) : Colors.white;
      final textMain = isDark ? Colors.white : const Color(0xff0f172a);
      final textMuted = isDark ? Colors.white60 : const Color(0xff64748b);

      return Scaffold(
        backgroundColor: isDark ? const Color(0xff080c14) : const Color(0xfff5f9ff),
        appBar: AppBar(
          title: const Text(
            "Asisten Medis Sehat Kita",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: cardBg,
          elevation: 0.5,
          foregroundColor: textMain,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Chat Messages Area
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.chatMessages.length + (controller.isTyping.value ? 1 : 0),
                    itemBuilder: (context, idx) {
                      if (idx < controller.chatMessages.length) {
                        final msg = controller.chatMessages[idx];
                        return _buildBubble(msg, textMain, isDark);
                      } else {
                        return _buildTypingIndicator(textMuted, isDark);
                      }
                    },
                  );
                }),
              ),

              // Bottom Input Area
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSuggestionChips(textMain, isDark),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.textController,
                            style: TextStyle(color: textMain),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (val) => controller.sendMessage(val),
                            decoration: InputDecoration(
                              hintText: "Tanyakan keluhan gizi Anda...",
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              filled: true,
                              fillColor: isDark ? const Color(0xff080c14) : const Color(0xfff1f5f9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xff2563eb),
                          child: IconButton(
                            onPressed: () => controller.sendMessage(controller.textController.text),
                            icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBubble(ChatMessage msg, Color textMain, bool isDark) {
    final alignment = msg.isUser ? Alignment.topRight : Alignment.topLeft;
    final bubbleBg = msg.isUser 
        ? const Color(0xff2563eb) 
        : (isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0));
    final bubbleTextColor = msg.isUser ? Colors.white : textMain;
    final borderRadius = msg.isUser 
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: alignment,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleBg,
            borderRadius: borderRadius,
          ),
          constraints: BoxConstraints(maxWidth: Get.width * 0.75),
          child: Text(
            msg.text,
            style: TextStyle(
              color: bubbleTextColor,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(Color textMuted, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2563eb)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Asisten sedang menganalisis...",
                style: TextStyle(
                  color: textMuted,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChips(Color textMain, bool isDark) {
    final chipBg = isDark ? const Color(0xff1e293b) : const Color(0xffe2e8f0);
    final suggestions = [
      "Makanan Sehat 🥬",
      "Tips Diet 🏃‍♂️",
      "Kontrol Gula 🍚",
      "Batasi Garam 🧂",
      "Fitur App 🩺",
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, idx) {
          final suggestion = suggestions[idx];
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ActionChip(
              label: Text(
                suggestion,
                style: TextStyle(
                  color: textMain,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: chipBg,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide.none,
              ),
              onPressed: () => controller.sendMessage(suggestion),
            ),
          );
        },
      ),
    );
  }
}